#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/types.h>
#include <linux/errno.h>
#include <linux/sched.h>
#include <linux/kernel.h>
#include <linux/kernel_stat.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <asm/uaccess.h>
#include <linux/net.h>
#include <linux/socket.h>

#include <linux/netdevice.h>
#include <linux/etherdevice.h>
#include <linux/string.h>
#include <net/ip.h>
#include <net/protocol.h>
#include <net/route.h>
#include <net/sock.h>
#include <net/arp.h>
#include <net/raw.h>
#include <net/checksum.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/netlink.h>
#include <linux/inetdevice.h>
#include <linux/icmp.h>
#include <net/udp.h>
#include <net/tcp.h>

#include <net/rtl/rtl_types.h>
#ifdef CONFIG_NETFILTER
#include <net/netfilter/nf_conntrack.h>
#include <net/rtl/fastpath/fastpath_core.h>
#endif
#include <net/rtl/rtl865x_netif.h>
#include <net/rtl/rtl_nic.h>

#ifdef CONFIG_RTL_LAYERED_ASIC_DRIVER
#include <AsicDriver/asicRegs.h>
#include <AsicDriver/rtl865x_asicCom.h>
#include <AsicDriver/rtl865x_asicL2.h>
#else
#include <AsicDriver/asicRegs.h>
#include <AsicDriver/rtl8651_tblAsicDrv.h>
#endif


struct sock *hw_qos_sk = NULL;

struct qos_cmd_info_s{
	int action;
	union{
		struct{
			char port[8];
			unsigned int portmask;
		} port_based_priority, queue_num;
		struct{
			char vlan[8];
			unsigned int vlanmask;
		}vlan_based_priority;
		struct{
			char dscp[64];
			unsigned int dscpmask1;
			unsigned int dscpmask2;
		}dscp_based_priority;
		struct{
			unsigned char queue[8][6];
			unsigned int portmask;
			unsigned int queuemask;
		}queue_type;
		struct{
			char priority[8];
			unsigned int prioritymask;
		}sys_priority;
		struct{
			char decision[5];
		}pri_decision;
		struct{
			char remark[8][8];
			unsigned int portmask;
			unsigned int prioritymask;
		}vlan_remark, dscp_remark;
		struct{
			unsigned short apr[8][6];
			unsigned char burst[8][6];
			unsigned char ppr[8][6];
			unsigned int portmask;
			unsigned int queuemask;
		}queue_rate;
		struct{
			unsigned int portmask;
			unsigned short apr[8];
		}port_rate;
	} qos_data;
};

#define PORT_BASED_PRIORITY_ASSIGN 1
#define VLAN_BASED_PRIORITY_ASSIGN 2
#define DSCP_BASED_PRIORITY_ASSIGN 3
#define QUEUE_NUMBER 4
#define QUEUE_TYPE_STRICT 5
#define QUEUE_TYPE_WEIGHTED 6
#define PRIORITY_TO_QID 7
#define PRIORITY_DECISION 8
#define VLAN_REMARK 9
#define DSCP_REMARK 10
#define PORT_BASED_PRIORITY_SHOW 11
#define VLAN_BASED_PRIORITY_SHOW 12
#define DSCP_BASED_PRIORITY_SHOW 13
#define QUEUE_NUMBER_SHOW 14
#define QUEUE_TYPE_STRICT_SHOW 15
#define QUEUE_TYPE_WEIGHTED_SHOW 16
#define PRIORITY_TO_QID_SHOW 17
#define PRIORITY_DECISION_SHOW 18
#define VLAN_REMARK_SHOW 19
#define DSCP_REMARK_SHOW 20
#define QUEUE_RATE 21
#define QUEUE_RATE_SHOW 22
#define FLOW_CONTROL_ENABLE 23
#define FLOW_CONTROL_DISABLE 24
#define FLOW_CONTROL_CONFIGURATION_SHOW 25
#define PORT_RATE 26
#define PORT_RATE_SHOW 27


static inline void port_based_priority_show(void)
{
	int i, ret;
	enum PRIORITYVALUE priority;

	printk("PORT_BASED_PRIORITY: \n");
	for(i=0; i<9; i++){
		ret = rtl8651_getAsicPortBasedPriority(i, &priority);
		if(ret == SUCCESS)
			printk("    Priority of port[%d] is %d\n", i, priority);
	}

	return;
}

static inline void vlan_based_priority_show(void)
{
	int i, ret;
	enum PRIORITYVALUE priority;

	printk("VLAN_BASED_PRIORITY: \n");
	for(i=0; i<9; i++){
		ret = rtl8651_getAsicDot1qAbsolutelyPriority(i, &priority);
		if(ret == SUCCESS)
			printk("    Priority of vlan_pri[%d] is %d\n", i, priority);
	}

	return;
}

static inline void dscp_based_priority_show(void)
{
	int i, ret;
	enum PRIORITYVALUE priority;

	printk("DSCP_BASED_PRIORITY: \n");
	for(i=0; i<64; i++){
		ret = rtl8651_getAsicDscpPriority(i, &priority);
		if(ret == SUCCESS)
			printk("    Priority of dscp[%d] is %d\n", i, priority);
	}

	return;
}

static inline void queue_number_show(void)
{
	int i, ret;
	enum QUEUENUM qnum;

	printk("QUEUE_NUMBER: \n");
	for(i=0; i<8; i++){
		ret = rtl8651_getAsicOutputQueueNumber(i, &qnum);
		if(ret == SUCCESS)
			printk("    Queue number of port[%d] is %d\n", i, qnum);
	}

	return;
}

static inline void queue_type_strict_show(void)
{
	int i, ret, j;
	enum QUEUETYPE queueType;

	printk("QUEUE_TYPE_STRICT: \n");
	for(i=0; i<8; i++){
		for(j=0; j<5; j++){
			ret = rtl8651_getAsicQueueStrict(i, j, &queueType);
			if((ret == SUCCESS) && (queueType == 0))
				printk("    Port[%d]'s  Queue[%d] type is STRICT\n", i, j);
		}
	}

	return;
}

static inline void queue_type_weighted_show(void)
{
	int i, ret, j, weight;
	enum QUEUETYPE queueType;

	printk("QUEUE_TYPE_WEIGHTED: \n");
	for(i=0; i<8; i++){
		for(j=0; j<5; j++){
			ret = rtl8651_getAsicQueueWeight(i, j, &queueType, &weight);
			if((ret == SUCCESS) && (queueType == 1))
				printk("    Port[%d]'s  Queue[%d] type is WEIGHTED, and weight is %u\n", i, j, weight);
		}
	}

	return;
}

static inline void priority_to_qid_show(void)
{
	int i, j, ret;
	enum QUEUEID qid;

	printk("PRIORITY_TO_QID: \n");
	for(i=1; i<7; i++){
		for(j=0; j<8; j++){
			ret = rtl8651_getAsicPriorityToQIDMappingTable(i, j, &qid);
			if(ret == SUCCESS)
				printk("    For Queue number[%d], priority[%d] is mapping to qid[%d]\n", i, j, qid);
		}
	}

	return;
}


static inline void priority_decision_show(void)
{
	unsigned int portpri, dot1qpri, dscppri, aclpri, natpri;
	int ret;

	printk("PRIORITY_DECISION: \n");
	ret = rtl8651_getAsicPriorityDecision(&portpri, &dot1qpri, &dscppri, &aclpri, &natpri);
	if(ret == SUCCESS){
		printk("    Port   based decision priority is %d\n", portpri);
		printk("    Vlan  based decision priority is %d\n", dot1qpri);
		printk("    Dscp based decision priority is %d\n", dscppri);
		printk("    Acl    based decision priority is %d\n", aclpri);
		printk("    Nat    based decision priority is %d\n", natpri);
	}

	return;
}

static inline void vlan_remark_show(void)
{
	int i, j, ret, remark;

	printk("VLAN_REMARK: \n");
	for(i=0; i<8; i++){
		for(j=0; j<8; j++){
			ret = rtl8651_getAsicVlanRemark(i, j, &remark);
			if(ret == SUCCESS)
				printk("    Port[%d]'s sys_pri[%d] is remarked as vlan_pri[%d]\n", i, j, remark);
		}

	}

	return;
}

static inline void dscp_remark_show(void)
{
	int i, j, ret, remark;

	printk("DSCP_REMARK: \n");
	for(i=0; i<8; i++){
		for(j=0; j<8; j++){
			ret = rtl8651_getAsicDscpRemark(i, j, &remark);
			if(ret == SUCCESS)
				printk("    Port[%d]'s sys_pri[%d] is remarked as dscp[%d]\n", i, j, remark);
		}

	}

	return;
}

static inline void queue_rate_show(void)
{
	int i, j, ret;
	unsigned int ppr, apr, burst;

	printk("QUEUE_RATE: \n");
	for(i=0; i<8; i++){
		for(j=0; j<6; j++){
			ret = rtl8651_getAsicQueueRate(i, j, &ppr, &burst, &apr);
			if(ret == SUCCESS)
				printk("    Port[%d] queue[%d]'s  ppr is %d, burst is %d, apr is %d\n", i, j, ppr, burst, apr);
		}

	}

	return;
}

static inline void port_rate_show(void)
{
	int i, ret;
	unsigned int apr;

	printk("PORT_RATE: \n");
	for(i=0; i<8; i++){
		ret = rtl8651_getAsicPortEgressBandwidth(i, &apr);
		if(ret == SUCCESS)
			printk("    Port[%d]'s apr is %d\n", i, apr);
	}

	return;
}

static inline void flow_control_config_show(void)
{
	unsigned int flow_control_enable = 0;
	int ret;

	ret = rtl8651_getAsicQueueFlowControlConfigureRegister(0, 0, &flow_control_enable);
	if(ret == SUCCESS){
		if(flow_control_enable == 1){
			printk("    QOS Flow Control is enabled!\n");
		}else{
			printk("    QOS Flow Control is disabled!\n");
		}
	}
}


void hw_qos_netlink_receive (struct sk_buff *__skb)
{
	unsigned int i, j;
	enum QUEUENUM queue_num;
	int ret;
	int pid = 0;
	struct qos_cmd_info_s send_data,recv_data;

	pid=rtk_nlrecvmsg(__skb, sizeof(struct qos_cmd_info_s), &recv_data);
	if(pid<0)
		return;

	switch(recv_data.action)
	{
		case PORT_BASED_PRIORITY_ASSIGN:
			for(i=0; i<8; i++){
				if((1<<i) & recv_data.qos_data.port_based_priority.portmask){
					ret = rtl8651_setAsicPortBasedPriority(i, recv_data.qos_data.port_based_priority.port[i]);
					if(ret == FAILED){
						printk("Port based priority set to PBPCR register failed\n ");
					}

				}
			}
			send_data.action = PORT_BASED_PRIORITY_ASSIGN;
			break;
		case VLAN_BASED_PRIORITY_ASSIGN:
			for(i=0; i<8; i++){
				if((1<<i) & recv_data.qos_data.vlan_based_priority.vlanmask){
					ret = rtl8651_setAsicDot1qAbsolutelyPriority(i, recv_data.qos_data.vlan_based_priority.vlan[i]);
					if(ret == FAILED){
						printk("Vlan based priority set to LPTM8021Q register failed\n ");
					}
				}
			}
			send_data.action = VLAN_BASED_PRIORITY_ASSIGN;
			break;
		case DSCP_BASED_PRIORITY_ASSIGN:
			for(i=0; i<64; i++){
				if(((i<32) && ((1<<i) & recv_data.qos_data.dscp_based_priority.dscpmask1)) ||
				   ((i>=32) && ((1<<(i-32)) & recv_data.qos_data.dscp_based_priority.dscpmask2))){
					ret = rtl8651_setAsicDscpPriority(i, recv_data.qos_data.dscp_based_priority.dscp[i]);
					if(ret == FAILED){
						printk("Dscp based priority set to DSCPCR register failed\n ");
					}
				}
			}
			send_data.action = DSCP_BASED_PRIORITY_ASSIGN;
			break;
		case QUEUE_NUMBER:
			for(i=0; i<8; i++){
				if((1<<i) && recv_data.qos_data.queue_num.portmask){
					ret = rtl8651_setAsicOutputQueueNumber(i, recv_data.qos_data.queue_num.port[i]);
					if(ret == FAILED){
						printk("Queue number set to QNUMCR register failed\n ");
					}
				}
			}
			send_data.action = QUEUE_NUMBER;
			break;
		case QUEUE_TYPE_STRICT:
			for(i=0; i<8; i++){
				if((1<<i) & recv_data.qos_data.queue_type.portmask){
					for(j=0; j<6; j++){
						if((1<<j) & recv_data.qos_data.queue_type.queuemask){
							if(recv_data.qos_data.queue_type.queue[i][j] == 255){
									ret = rtl8651_setAsicQueueStrict(i, j, STR_PRIO);
									if(ret == FAILED){
										printk("Queue type STRICT set to WFQWCR0P0 register failed\n ");
									}
								}
						}
					}
				}
			}
			send_data.action = QUEUE_TYPE_STRICT;
			break;
		case QUEUE_TYPE_WEIGHTED:
			for(i=0; i<8; i++){
				if((1<<i) & recv_data.qos_data.queue_type.portmask){
					for(j=0; j<6; j++){
						if((1<<j) & recv_data.qos_data.queue_type.queuemask){
							if((recv_data.qos_data.queue_type.queue[i][j] > 0) &&
					    		    (recv_data.qos_data.queue_type.queue[i][j] != 255)){
								ret = rtl8651_setAsicQueueWeight(i, j, WFQ_PRIO, recv_data.qos_data.queue_type.queue[i][j]);
								if(ret == FAILED){
									printk("Queue type WEIGHTED set to WFQWCR0P0 register failed\n ");
								}
							}
						}
					}
				}
			}
			send_data.action = QUEUE_TYPE_WEIGHTED;
			break;
		case PRIORITY_TO_QID:
			for(i=0; i<8; i++){
				ret = rtl8651_getAsicOutputQueueNumber(i, &queue_num);
				if(ret == SUCCESS){
					for(j=0; j<8; j++)
					{
						if((1<<j) & recv_data.qos_data.sys_priority.prioritymask){
							ret = rtl8651_setAsicPriorityToQIDMappingTable(queue_num, j, recv_data.qos_data.sys_priority.priority[j]);
							if(ret == FAILED){
								printk("Priority to qid set to UPTCMCR register failed\n ");
							}
						}
					}
				}
			}
			send_data.action = PRIORITY_TO_QID;
			break;
		case PRIORITY_DECISION:
			ret = rtl8651_setAsicPriorityDecision(recv_data.qos_data.pri_decision.decision[0], recv_data.qos_data.pri_decision.decision[1],
										   recv_data.qos_data.pri_decision.decision[2], recv_data.qos_data.pri_decision.decision[3],
										   recv_data.qos_data.pri_decision.decision[4]);
			if(ret == FAILED){
				printk("Priority decision set to QIDDPCR register failed\n ");
			}
			send_data.action = PRIORITY_DECISION;
			break;
		case VLAN_REMARK:
			for(i=0; i<8; i++){
				if((1<<i) & recv_data.qos_data.vlan_remark.portmask){
					for(j=0; j<8; j++){
						if((1<<j) & recv_data.qos_data.vlan_remark.prioritymask){
							ret = rtl8651_setAsicVlanRemark(i, j, recv_data.qos_data.vlan_remark.remark[i][j]);
							if(ret == FAILED){
								printk("Vlan remark set to RMCR1P register failed\n ");
							}
						}
					}
				}
			}
			send_data.action = VLAN_REMARK;
			break;
		case DSCP_REMARK:
			for(i=0; i<8; i++){
				if((1<<i) & recv_data.qos_data.dscp_remark.portmask){
					for(j=0; j<8; j++){
						if((1<<j) & recv_data.qos_data.dscp_remark.prioritymask){
							ret = rtl8651_setAsicDscpRemark(i, j, recv_data.qos_data.dscp_remark.remark[i][j]);
							if(ret == FAILED){
								printk("Dscp remark set to DSCPRM register failed\n ");
							}
						}
					}
				}
			}
			send_data.action = DSCP_REMARK;
			break;
		case QUEUE_RATE:
			for(i=0; i<8; i++){
				if((1<<i) & recv_data.qos_data.queue_rate.portmask){
					for(j=0; j<6; j++){
						if((1<<j) & recv_data.qos_data.queue_rate.queuemask){
							ret = rtl8651_setAsicQueueRate(i, j, recv_data.qos_data.queue_rate.ppr[i][j],
								                                      recv_data.qos_data.queue_rate.burst[i][j],
								                                      recv_data.qos_data.queue_rate.apr[i][j]);
							if(ret == FAILED){
								printk("Queue rate set to P0Q0RGCR register failed\n ");
							}
						}
					}
				}
			}
			send_data.action = QUEUE_RATE;
			break;
		case PORT_RATE:
			for(i=0; i<8; i++){
				if((1<<i) & recv_data.qos_data.port_rate.portmask){
					ret = rtl8651_setAsicPortEgressBandwidth(i, recv_data.qos_data.port_rate.apr[i]);
					if(ret == FAILED){
						printk("Port rate set to WFQRCRP0 register failed\n ");
					}
				}
			}
			send_data.action = PORT_RATE;
			break;
		case FLOW_CONTROL_ENABLE:
			for(i=0; i<7; i++){
				for(j=0; j<6; j++){
					ret = rtl8651_setAsicQueueFlowControlConfigureRegister(i, j, 1);
					if(ret == FAILED){
						printk("Set Flow Control Enable failed\n ");
					}
				}
			}
			break;
		case FLOW_CONTROL_DISABLE:
			for(i=0; i<7; i++){
				for(j=0; j<6; j++){
					ret = rtl8651_setAsicQueueFlowControlConfigureRegister(i, j, 0);
					if(ret == FAILED){
						printk("Set Flow Control Disable failed\n ");
					}
				}
			}
			break;
		case PORT_BASED_PRIORITY_SHOW:
			port_based_priority_show();
			break;
		case VLAN_BASED_PRIORITY_SHOW:
			vlan_based_priority_show();
			break;
		case DSCP_BASED_PRIORITY_SHOW:
			dscp_based_priority_show();
			break;
		case QUEUE_NUMBER_SHOW:
			queue_number_show();
			break;
		case QUEUE_TYPE_STRICT_SHOW:
			queue_type_strict_show();
			break;
		case QUEUE_TYPE_WEIGHTED_SHOW:
			queue_type_weighted_show();
			break;
		case PRIORITY_TO_QID_SHOW:
			priority_to_qid_show();
			break;
		case PRIORITY_DECISION_SHOW:
			priority_decision_show();
			break;
		case VLAN_REMARK_SHOW:
			vlan_remark_show();
			break;
		case DSCP_REMARK_SHOW:
			dscp_remark_show();
			break;
		case QUEUE_RATE_SHOW:
			queue_rate_show();
			break;
		case PORT_RATE_SHOW:
			port_rate_show();
			break;
		case FLOW_CONTROL_CONFIGURATION_SHOW:
			flow_control_config_show();
			break;
		default:
			break;
	}

	rtk_nlsendmsg(pid, hw_qos_sk, sizeof(struct qos_cmd_info_s), &send_data);
	return;

}


int hw_qos_init_netlink(void)
{
  	hw_qos_sk = netlink_kernel_create(&init_net, NETLINK_RTK_HW_QOS, 0, hw_qos_netlink_receive, NULL, THIS_MODULE);

  	if (!hw_qos_sk) {
    		printk(KERN_ERR "Netlink[Kernel] Cannot create netlink socket for hw qos config.\n");
    		return -EIO;
  	}
  	printk("Netlink[Kernel] create socket for hw qos config ok.\n");
  	return 0;
}






