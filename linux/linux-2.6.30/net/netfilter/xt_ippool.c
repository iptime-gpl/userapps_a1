/* Kernel module to match an IP address pool. */

#include <linux/module.h>
#include <linux/ip.h>
#include <linux/skbuff.h>

#include <linux/netfilter/x_tables.h>
#include <linux/netfilter/xt_ippool.h>
#include <linux/netfilter/xt_ippool_api.h>

static inline int match_pool(
	ip_pool_t index,
	__u32 addr,
	int inv
) {
	if (ip_pool_match(index, ntohl(addr)))
		inv = !inv;
	return inv;
}

#undef printk
static bool match(const struct sk_buff *skb, const struct xt_match_param *par)
{
	const struct xt_pool_info *info = par->matchinfo;
	const struct iphdr *iph = ip_hdr(skb);

	if (info->src != IP_POOL_NONE && !match_pool(info->src, iph->saddr,
						info->flags&IPT_POOL_INV_SRC))
		return false;

	if (info->dst != IP_POOL_NONE && !match_pool(info->dst, iph->daddr,
						info->flags&IPT_POOL_INV_DST))
		return false;

	return true;
}

static bool checkentry(const struct xt_mtchk_param *par)
{
	return true;
}

static struct xt_match pool_match = {
                .name           = "pool",
                .family         = AF_INET,
                .checkentry     = checkentry,
                .match          = match,
                .matchsize      = sizeof(struct xt_pool_info),
                .me             = THIS_MODULE,
};

static int __init init(void)
{
	return xt_register_match(&pool_match);
}

static void __exit fini(void)
{
	xt_unregister_match(&pool_match);
}

module_init(init);
module_exit(fini);
