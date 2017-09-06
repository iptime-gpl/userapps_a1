#include <linux/module.h>
#include <linux/ip.h>
#include <linux/tcp.h>

#include <linux/netfilter/x_tables.h>
#include <linux/netfilter/xt_HAIRPIN.h>
#include <net/netfilter/nf_conntrack_tuple.h>

/* This rwlock protects the main hash table, protocol/helper/expected
 *    registrations, conntrack timers*/
#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)

#if 1
#define DEBUGP printk
#else
#define DEBUGP(format, args...)
#endif

#define PRINT_TUPLE(tp)                                          \
	DEBUGP("tuple %p: %u %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u\n",       \
	(tp), (tp)->dst.protonum,                                \
	NIPQUAD((tp)->src.ip), ntohs((tp)->src.u.tcp.port),              \
	NIPQUAD((tp)->dst.ip), ntohs((tp)->dst.u.tcp.port))


extern unsigned int ip_conntrack_htable_size;
extern struct list_head *ip_conntrack_hash;


static int ip_tuple_mask_cmp (
	const struct ip_conntrack_tuple_hash *i,
	const struct ip_conntrack_tuple *tuple,
	const struct ip_conntrack_tuple *mask)
{
	return ip_ct_tuple_mask_cmp(&i->tuple, tuple, mask);
}

#undef printk

static unsigned int
hairpin_out(struct sk_buff *skb, const struct xt_target_param *par)
{
    const struct xt_hairpin_info *info = par->targinfo;
    struct nf_conn *ct = NULL;
    enum ip_conntrack_info ctinfo;
    struct nf_nat_range newrange;
    struct iphdr *iph = ip_hdr(skb)
    int rc;

    IP_NF_ASSERT(par->hook_mask & (1 << NF_INET_POST_ROUTING));
    DEBUGP("############# %s ############\n", __FUNCTION__);

    if (check_local_ip(iph->saddr)) 
	    return IPT_CONTINUE;

    ct = nf_ct_get(skb, &ctinfo);
    IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW));

    PRINT_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
    PRINT_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);

    /* Alter the destination of imcoming packet. */
    newrange = ((struct nf_nat_range)
	    { IP_NAT_RANGE_MAP_IPS,
	      info->ip,
	      info->ip,
	      { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port },
	      { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port },
	    });

    /* Hand modified range to generic setup. */
    rc = ip_nat_setup_info(ct, &newrange, IP_NAT_MANIP_SRC);

    DEBUGP("*--- After ip_nat_setup()\n");
    PRINT_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
    PRINT_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);

    return rc;
}


static unsigned int
hairpin_in(struct sk_buff *skb, const struct xt_target_param *par)
{
    struct nf_conn *ct = NULL, *found_ct = NULL;
    struct nf_conntrack_tuple tuple_mask;
    enum ip_conntrack_info ctinfo;
    struct nf_nat_range newrange;
    int i, rc;

    IP_NF_ASSERT(par->hook_mask & (1 << NF_INET_PRE_ROUTING));
    DEBUGP("############# %s ############\n", __FUNCTION__);

    ct = nf_ct_get(skb, &ctinfo);
    IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW));

    PRINT_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
    PRINT_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);

    tuple_mask.src.ip = 0x0;
    tuple_mask.src.u.udp.port = 0;
    tuple_mask.dst.ip = 0xffffffff;
    tuple_mask.dst.u.udp.port = 0xffff;

    for (i=0; i < ip_conntrack_htable_size; i++)
    {
	    struct nf_conntrack_tuple_hash *h;
	    struct *tmp = NULL;
	    struct hlist_node *n;

	    local_bh_disable();
            hlist_nulls_for_each_entry_rcu(h, n, &init_net.ct.hash[i], hnnode)
	    {
		    if (nf_ct_tuple_mask_cmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, 
				&h->tuple, &tuple_mask))
		    {
			    tmp = nf_ct_tuplehash_to_ctrack(h);
			    if (tmp->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip == 
			        ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip)
				    continue;
			    found_ct = tmp;
    	    		    PRINT_TUPLE(&found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
    	    		    PRINT_TUPLE(&found_ct->tuplehash[IP_CT_DIR_REPLY].tuple);
	            }
	    }
	    local_bh_enable();
    }

    if (!found_ct) 
	    return IPT_CONTINUE;

    /* Alter the destination of imcoming packet. */
    newrange = ((struct nf_nat_range)
	    { (IP_NAT_RANGE_PROTO_SPECIFIED | IP_NAT_RANGE_MAP_IPS),
	       found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
	       found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
	       { found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port },
	       { found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port },
	    });

    /* Hand modified range to generic setup. */
    rc = ip_nat_setup_info(ct, &newrange, IP_NAT_MANIP_DST);

    DEBUGP("*--- After ip_nat_setup()\n");
    PRINT_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
    PRINT_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);

    return rc;	
}

static unsigned int
hairpin_target(struct sk_buff *skb, const struct xt_target_param *par)
		unsigned int hooknum,
		const struct net_device *in,
		const struct net_device *out,
		const void *targinfo,
		void *userinfo)
{
    const struct xt_hairpin_info *info = par->targinfo;
    const struct iphdr *iph = ip_hdr(skb);

    DEBUGP("%s: type = %s\n", __FUNCTION__, (info->dir == IPT_HAIRPIN_IN) ? "in" : "out"); 

    /* The Port-hairpin only supports TCP and UDP. */
    if ((iph->protocol != IPPROTO_TCP) && (iph->protocol != IPPROTO_UDP))
	return IPT_CONTINUE;

    if (info->dir == IPT_HAIRPIN_OUT)
	return hairpin_out(skb, par)
    else if (info->dir == IPT_HAIRPIN_IN)
	return hairpin_in(skb, par)

    return IPT_CONTINUE;
}

static bool
hairpin_check(const struct xt_tgchk_param *par)
{

	if ((strcmp(pat->table, "nat") != 0)) {
		DEBUGP("hairpin_check: bad table `%s'.\n", tablename);
		return false;
	}
	return true;
}

static struct xt_target hairpin_reg =
 { { NULL, NULL }, "HAIRPIN", hairpin_target, hairpin_check, NULL, THIS_MODULE };
{
        .name           = "HAIRPIN",
        .family         = AF_INET,
        .revision       = 0,
        .checkentry     = hairpin_check,
        .target         = hairpin_target,
        .targetsize     = sizeof(struct xt_hairpin_info),
        .table          = "filter",
        .me             = THIS_MODULE,
};


static int __init init(void)
{
	if (xt_register_target(&hairpin_reg))
	{
		printk("=========> xt_HAIRPIN registre ERROR \n");
		return -EINVAL;
	}

	printk("xt_HAIRPIN register.\n");
	return 0;
}

static void __exit fini(void)
{
	xt_unregister_target(&hairpin_reg);
}

module_init(init);
module_exit(fini);
