	.file	1 "fastpath_core.c"
	.section .mdebug.abi32
	.previous
	.gnu_attribute 4, 3
#APP
	.macro _ssnop; sll $0, $0, 1; .endm
	.macro _ehb; sll $0, $0, 3; .endm
	.macro mtc0_tlbw_hazard; nop; nop; .endm
	.macro tlbw_use_hazard; nop; nop; nop; .endm
	.macro tlb_probe_hazard; nop; nop; nop; .endm
	.macro irq_enable_hazard; _ssnop; _ssnop; _ssnop;; .endm
	.macro irq_disable_hazard; nop; nop; nop; .endm
	.macro back_to_back_c0_hazard; _ssnop; _ssnop; _ssnop;; .endm
		.macro	raw_local_irq_enable				
	.set	push						
	.set	reorder						
	.set	noat						
	mfc0	$1,$12						
	ori	$1,0x1f						
	xori	$1,0x1e						
	mtc0	$1,$12						
	irq_enable_hazard					
	.set	pop						
	.endm
		.macro	raw_local_irq_disable
	.set	push						
	.set	noat						
	mfc0	$1,$12						
	ori	$1,0x1f						
	xori	$1,0x1f						
	.set	noreorder					
	mtc0	$1,$12						
	irq_disable_hazard					
	.set	pop						
	.endm							

		.macro	raw_local_save_flags flags			
	.set	push						
	.set	reorder						
	mfc0	\flags, $12					
	.set	pop						
	.endm							

		.macro	raw_local_irq_save result			
	.set	push						
	.set	reorder						
	.set	noat						
	mfc0	\result, $12					
	ori	$1, \result, 0x1f				
	xori	$1, 0x1f					
	.set	noreorder					
	mtc0	$1, $12						
	irq_disable_hazard					
	.set	pop						
	.endm							

		.macro	raw_local_irq_restore flags			
	.set	push						
	.set	noreorder					
	.set	noat						
	mfc0	$1, $12						
	andi	\flags, 1					
	ori	$1, 0x1f					
	xori	$1, 0x1f					
	or	\flags, $1					
	mtc0	\flags, $12					
	irq_disable_hazard					
	.set	pop						
	.endm							

#NO_APP
	.section	.text.cache_timeout,"ax",@progbits
	.align	2
	.set	nomips16
	.ent	cache_timeout
	.type	cache_timeout, @function
cache_timeout:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	lbu	$2,0($4)
	nop
	beq	$2,$0,$L7
	nop

	lw	$6,8($4)
	lw	$5,4($4)
	lhu	$3,2($4)
	lbu	$2,1($4)
	xor	$5,$6,$5
	lui	$6,%hi(max_udp_frag_entry)
	xor	$3,$3,$5
	lw	$6,%lo(max_udp_frag_entry)($6)
	srl	$5,$5,16
	xor	$3,$3,$5
	lw	$5,40($4)
	xor	$2,$3,$2
	srl	$3,$3,8
	xor	$2,$2,$3
	addiu	$6,$6,-1
	sb	$0,0($4)
	lw	$3,44($4)
	beq	$5,$0,$L3
	and	$2,$2,$6

	j	$L4
	sw	$3,44($5)

$L3:
	li	$5,12			# 0xc
	mult	$2,$5
	lui	$6,%hi(udp_cache_table)
	lw	$6,%lo(udp_cache_table)($6)
	nop
	lw	$6,0($6)
	mflo	$5
	addu	$5,$6,$5
	sw	$3,4($5)
$L4:
	li	$3,12			# 0xc
	mult	$2,$3
	lw	$5,40($4)
	lw	$3,44($4)
	nop
	sw	$5,0($3)
	lui	$3,%hi(udp_cache_table)
	lw	$6,%lo(udp_cache_table)($3)
	lui	$3,%hi(udp_cache_list_free)
	addiu	$3,$3,%lo(udp_cache_list_free)
	lw	$6,0($6)
	addiu	$5,$4,48
	mflo	$2
	addu	$2,$6,$2
	lw	$6,8($2)
	nop
	addiu	$6,$6,-1
	sw	$6,8($2)
	sw	$0,48($4)
	lw	$2,4($3)
	nop
	sw	$2,52($4)
	lw	$2,4($3)
	nop
	sw	$4,0($2)
	lw	$2,8($3)
	sw	$5,4($3)
	addiu	$2,$2,1
	sw	$2,8($3)
$L7:
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	cache_timeout
	.size	cache_timeout, .-cache_timeout
	.section	.text.negative_cache_timeout,"ax",@progbits
	.align	2
	.set	nomips16
	.ent	negative_cache_timeout
	.type	negative_cache_timeout, @function
negative_cache_timeout:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	lw	$6,8($4)
	lw	$5,4($4)
	lhu	$3,2($4)
	lbu	$2,1($4)
	xor	$5,$6,$5
	lui	$6,%hi(max_udp_frag_entry)
	xor	$3,$3,$5
	lw	$6,%lo(max_udp_frag_entry)($6)
	srl	$5,$5,16
	xor	$3,$3,$5
	lw	$5,36($4)
	xor	$2,$3,$2
	srl	$3,$3,8
	xor	$2,$2,$3
	addiu	$6,$6,-1
	sb	$0,0($4)
	lw	$3,40($4)
	beq	$5,$0,$L9
	and	$2,$2,$6

	j	$L10
	sw	$3,40($5)

$L9:
	li	$5,12			# 0xc
	mult	$2,$5
	lui	$6,%hi(negative_cache_table)
	lw	$6,%lo(negative_cache_table)($6)
	mflo	$5
	addu	$5,$6,$5
	sw	$3,4($5)
$L10:
	li	$3,12			# 0xc
	mult	$2,$3
	lw	$5,36($4)
	lw	$3,40($4)
	nop
	sw	$5,0($3)
	lui	$3,%hi(negative_cache_table)
	lw	$6,%lo(negative_cache_table)($3)
	lui	$3,%hi(negative_cache_list_free)
	addiu	$3,$3,%lo(negative_cache_list_free)
	addiu	$5,$4,44
	mflo	$2
	addu	$2,$6,$2
	lw	$6,8($2)
	nop
	addiu	$6,$6,-1
	sw	$6,8($2)
	sw	$0,44($4)
	lw	$2,4($3)
	nop
	sw	$2,48($4)
	lw	$2,4($3)
	nop
	sw	$4,0($2)
	lw	$2,8($3)
	sw	$5,4($3)
	addiu	$2,$2,1
	j	$31
	sw	$2,8($3)

	.set	macro
	.set	reorder
	.end	negative_cache_timeout
	.size	negative_cache_timeout, .-negative_cache_timeout
	.section	.text.rtk_addArp,"ax",@progbits
	.align	2
	.globl	rtk_addArp
	.set	nomips16
	.ent	rtk_addArp
	.type	rtk_addArp, @function
rtk_addArp:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	j	$31
	move	$2,$0

	.set	macro
	.set	reorder
	.end	rtk_addArp
	.size	rtk_addArp, .-rtk_addArp
	.section	.text.rtk_modifyArp,"ax",@progbits
	.align	2
	.globl	rtk_modifyArp
	.set	nomips16
	.ent	rtk_modifyArp
	.type	rtk_modifyArp, @function
rtk_modifyArp:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	j	$31
	move	$2,$0

	.set	macro
	.set	reorder
	.end	rtk_modifyArp
	.size	rtk_modifyArp, .-rtk_modifyArp
	.section	.text.rtk_delArp,"ax",@progbits
	.align	2
	.globl	rtk_delArp
	.set	nomips16
	.ent	rtk_delArp
	.type	rtk_delArp, @function
rtk_delArp:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	j	$31
	li	$2,-4			# 0xfffffffc

	.set	macro
	.set	reorder
	.end	rtk_delArp
	.size	rtk_delArp, .-rtk_delArp
	.section	.text.rtk_addRoute,"ax",@progbits
	.align	2
	.globl	rtk_addRoute
	.set	nomips16
	.ent	rtk_addRoute
	.type	rtk_addRoute, @function
rtk_addRoute:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	j	$31
	move	$2,$0

	.set	macro
	.set	reorder
	.end	rtk_addRoute
	.size	rtk_addRoute, .-rtk_addRoute
	.section	.text.rtk_modifyRoute,"ax",@progbits
	.align	2
	.globl	rtk_modifyRoute
	.set	nomips16
	.ent	rtk_modifyRoute
	.type	rtk_modifyRoute, @function
rtk_modifyRoute:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	j	$31
	move	$2,$0

	.set	macro
	.set	reorder
	.end	rtk_modifyRoute
	.size	rtk_modifyRoute, .-rtk_modifyRoute
	.section	.text.rtk_delRoute,"ax",@progbits
	.align	2
	.globl	rtk_delRoute
	.set	nomips16
	.ent	rtk_delRoute
	.type	rtk_delRoute, @function
rtk_delRoute:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	j	$31
	li	$2,-4			# 0xfffffffc

	.set	macro
	.set	reorder
	.end	rtk_delRoute
	.size	rtk_delRoute, .-rtk_delRoute
	.section	.text.rtk_addSession,"ax",@progbits
	.align	2
	.globl	rtk_addSession
	.set	nomips16
	.ent	rtk_addSession
	.type	rtk_addSession, @function
rtk_addSession:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	j	$31
	move	$2,$0

	.set	macro
	.set	reorder
	.end	rtk_addSession
	.size	rtk_addSession, .-rtk_addSession
	.section	.text.rtk_delSession,"ax",@progbits
	.align	2
	.globl	rtk_delSession
	.set	nomips16
	.ent	rtk_delSession
	.type	rtk_delSession, @function
rtk_delSession:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	j	$31
	move	$2,$0

	.set	macro
	.set	reorder
	.end	rtk_delSession
	.size	rtk_delSession, .-rtk_delSession
	.section	.text.FastPath_Route,"ax",@progbits
	.align	2
	.globl	FastPath_Route
	.set	nomips16
	.ent	FastPath_Route
	.type	FastPath_Route, @function
FastPath_Route:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	lui	$2,%hi(route_list_inuse)
	lw	$3,%lo(route_list_inuse)($2)
	move	$6,$0
	j	$L29
	move	$2,$0

$L32:
	lw	$5,8($3)
	nop
	sltu	$7,$5,$6
	bne	$7,$0,$L30
	and	$8,$4,$5

	lw	$7,4($3)
	nop
	bne	$8,$7,$L30
	nop

	j	$L31
	addiu	$2,$3,16

$L30:
	move	$5,$6
$L31:
	lw	$3,44($3)
	move	$6,$5
$L29:
	bne	$3,$0,$L32
	nop

	j	$31
	nop

	.set	macro
	.set	reorder
	.end	FastPath_Route
	.size	FastPath_Route, .-FastPath_Route
	.section	.text.mark_path_invalid,"ax",@progbits
	.align	2
	.set	nomips16
	.ent	mark_path_invalid
	.type	mark_path_invalid, @function
mark_path_invalid:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	srl	$2,$4,8
	xor	$2,$2,$4
	srl	$3,$6,16
	andi	$5,$5,0xffff
	xor	$2,$2,$6
	xor	$2,$2,$3
	srl	$8,$5,4
	lhu	$3,18($sp)
	xor	$2,$2,$8
	andi	$7,$7,0xffff
	lui	$8,%hi(path_table_list_max)
	xor	$2,$2,$7
	lw	$8,%lo(path_table_list_max)($8)
	xor	$2,$2,$3
	srl	$9,$2,12
	xor	$2,$9,$2
	addiu	$8,$8,-1
	and	$2,$2,$8
	li	$9,12			# 0xc
	mult	$2,$9
	lui	$9,%hi(table_path)
	lw	$9,%lo(table_path)($9)
	nop
	lw	$9,0($9)
	mflo	$2
	addu	$2,$9,$2
	lw	$9,0($2)
	j	$L35
	li	$10,255			# 0xff

$L39:
	lw	$2,12($9)
	nop
	bne	$2,$5,$L36
	nop

	lw	$2,8($9)
	nop
	bne	$2,$7,$L36
	nop

	lw	$2,16($9)
	nop
	bne	$2,$4,$L36
	nop

	lw	$2,20($9)
	nop
	bne	$2,$6,$L36
	nop

	lbu	$11,0($9)
	nop
	bne	$11,$10,$L36
	nop

	lbu	$10,2($9)
	li	$6,1			# 0x1
	bne	$10,$6,$L37
	sb	$0,0($9)

	lw	$6,24($9)
	lhu	$10,30($9)
	j	$L38
	nop

$L37:
	lw	$6,32($9)
	lhu	$10,38($9)
	j	$L38
	nop

$L36:
	lw	$9,64($9)
	nop
$L35:
	bne	$9,$0,$L39
	nop

	j	$31
	nop

$L38:
	beq	$6,$0,$L48
	nop

	lbu	$11,2($9)
	li	$9,1			# 0x1
	bne	$11,$9,$L41
	srl	$9,$4,16

	srl	$9,$2,8
	xor	$9,$9,$2
	xor	$3,$9,$3
	srl	$9,$7,4
	xor	$3,$3,$9
	xor	$3,$3,$6
	xor	$10,$3,$10
	j	$L47
	srl	$6,$6,16

$L41:
	xor	$9,$9,$4
	xor	$9,$9,$5
	xor	$3,$9,$3
	xor	$3,$3,$6
	srl	$6,$6,8
	xor	$6,$3,$6
	srl	$10,$10,4
$L47:
	xor	$10,$6,$10
	srl	$6,$10,12
	xor	$10,$6,$10
	and	$8,$10,$8
	li	$3,12			# 0xc
	mult	$8,$3
	lui	$3,%hi(table_path)
	lw	$3,%lo(table_path)($3)
	nop
	lw	$3,0($3)
	mflo	$8
	addu	$8,$3,$8
	lw	$3,0($8)
	j	$L43
	li	$6,255			# 0xff

$L45:
	lw	$8,24($3)
	nop
	bne	$8,$2,$L44
	nop

	lw	$8,28($3)
	nop
	bne	$8,$7,$L44
	nop

	lw	$8,32($3)
	nop
	bne	$8,$4,$L44
	nop

	lw	$8,36($3)
	nop
	bne	$8,$5,$L44
	nop

	lbu	$8,0($3)
	nop
	bne	$8,$6,$L44
	nop

	sb	$0,0($3)
$L44:
	lw	$3,64($3)
	nop
$L43:
	bne	$3,$0,$L45
	nop

$L48:
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	mark_path_invalid
	.size	mark_path_invalid, .-mark_path_invalid
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
$LC0:
	.ascii	"%s:%s\012\000"
	.align	2
$LC1:
	.ascii	"Realtek FastPath\000"
	.align	2
$LC2:
	.ascii	"v1.03\000"
	.section	.text.get_fastpath_module_info,"ax",@progbits
	.align	2
	.globl	get_fastpath_module_info
	.set	nomips16
	.ent	get_fastpath_module_info
	.type	get_fastpath_module_info, @function
get_fastpath_module_info:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	beq	$4,$0,$L53
	lui	$5,%hi($LC0)

	lui	$6,%hi($LC1)
	lui	$7,%hi($LC2)
	addiu	$5,$5,%lo($LC0)
	addiu	$6,$6,%lo($LC1)
	addiu	$7,$7,%lo($LC2)
	j	sprintf
	nop

$L53:
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	get_fastpath_module_info
	.size	get_fastpath_module_info, .-get_fastpath_module_info
	.section	.rodata.str1.4
	.align	2
$LC3:
	.ascii	"napt num: %d, path num: %d.\012\000"
	.section	.text.fastpath_dump_napt_entry_num,"ax",@progbits
	.align	2
	.globl	fastpath_dump_napt_entry_num
	.set	nomips16
	.ent	fastpath_dump_napt_entry_num
	.type	fastpath_dump_napt_entry_num, @function
fastpath_dump_napt_entry_num:
	.frame	$sp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$16,16($sp)
	lui	$2,%hi(path_list_inuse)
	move	$16,$5
	lw	$2,%lo(path_list_inuse)($2)
	j	$L55
	move	$7,$0

$L56:
	lw	$2,72($2)
	addiu	$7,$7,1
$L55:
	bne	$2,$0,$L56
	move	$6,$0

	lui	$2,%hi(napt_list_inuse)
	lw	$2,%lo(napt_list_inuse)($2)
	j	$L57
	nop

$L58:
	lw	$2,44($2)
	addiu	$6,$6,1
$L57:
	bne	$2,$0,$L58
	lui	$5,%hi($LC3)

	addu	$4,$4,$16
	jal	sprintf
	addiu	$5,$5,%lo($LC3)

	addu	$2,$2,$16
	lw	$31,20($sp)
	lw	$16,16($sp)
	j	$31
	addiu	$sp,$sp,24

	.set	macro
	.set	reorder
	.end	fastpath_dump_napt_entry_num
	.size	fastpath_dump_napt_entry_num, .-fastpath_dump_napt_entry_num
	.section	.text.init_table_path,"ax",@progbits
	.align	2
	.globl	init_table_path
	.set	nomips16
	.ent	init_table_path
	.type	init_table_path, @function
init_table_path:
	.frame	$sp,40,$31		# vars= 0, regs= 5/0, args= 16, gp= 0
	.mask	0x800f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
$L61 = .
$L62 = .
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$19,32($sp)
	sw	$18,28($sp)
	sw	$17,24($sp)
	sw	$16,20($sp)
	lui	$2,%hi(malloc_sizes+4)
	move	$17,$4
	lw	$4,%lo(malloc_sizes+4)($2)
	move	$19,$5
	jal	kmem_cache_alloc
	li	$5,32			# 0x20

	lui	$16,%hi(table_path)
	move	$18,$2
	beq	$2,$0,$L63
	sw	$2,%lo(table_path)($16)

$L64 = .
	li	$4,12			# 0xc
	mult	$17,$4
	lui	$7,%hi(path_list_inuse)
	lui	$6,%hi(path_list_free)
	addiu	$2,$6,%lo(path_list_free)
	addiu	$3,$7,%lo(path_list_inuse)
	sw	$0,%lo(path_list_free)($6)
	li	$5,32			# 0x20
	lui	$6,%hi(path_table_list_max)
	sw	$3,4($3)
	sw	$2,4($2)
	sw	$0,8($3)
	sw	$0,8($2)
	sw	$0,%lo(path_list_inuse)($7)
	sw	$17,%lo(path_table_list_max)($6)
	jal	__kmalloc
	mflo	$4

	sw	$2,0($18)
	lw	$2,%lo(table_path)($16)
	nop
	lw	$2,0($2)
	nop
	beq	$2,$0,$L63
	move	$2,$0

	j	$L65
	li	$3,12			# 0xc

$L66:
	lw	$5,%lo(table_path)($16)
	addiu	$2,$2,1
	lw	$5,0($5)
	mflo	$4
	addu	$5,$5,$4
	sw	$0,8($5)
	lw	$5,%lo(table_path)($16)
	nop
	lw	$5,0($5)
	nop
	addu	$5,$5,$4
	sw	$0,0($5)
	lw	$5,%lo(table_path)($16)
	nop
	lw	$5,0($5)
	nop
	addu	$4,$5,$4
	sw	$4,4($4)
$L65:
	slt	$4,$2,$17
	bne	$4,$0,$L66
	mult	$2,$3

	lui	$18,%hi(malloc_sizes)
	lui	$16,%hi(path_list_free)
	addiu	$18,$18,%lo(malloc_sizes)
	addiu	$16,$16,%lo(path_list_free)
	j	$L67
	move	$17,$0

$L68:
$L69 = .
	lw	$4,20($18)
	jal	kmem_cache_alloc
	li	$5,32			# 0x20

	bne	$2,$0,$L70
	addiu	$3,$2,72

	j	$L71
	li	$2,-2			# 0xfffffffe

$L70:
	sw	$0,72($2)
	lw	$4,4($16)
	addiu	$17,$17,1
	sw	$4,76($2)
	lw	$4,4($16)
	nop
	sw	$2,0($4)
	lw	$2,8($16)
	sw	$3,4($16)
	addiu	$2,$2,1
	sw	$2,8($16)
$L67:
	slt	$2,$17,$19
	bne	$2,$0,$L68
	move	$2,$0

	j	$L71
	nop

$L63:
	li	$2,-1			# 0xffffffff
$L71:
	lw	$31,36($sp)
	lw	$19,32($sp)
	lw	$18,28($sp)
	lw	$17,24($sp)
	lw	$16,20($sp)
	j	$31
	addiu	$sp,$sp,40

	.set	macro
	.set	reorder
	.end	init_table_path
	.size	init_table_path, .-init_table_path
	.section	.text.init_table_napt,"ax",@progbits
	.align	2
	.globl	init_table_napt
	.set	nomips16
	.ent	init_table_napt
	.type	init_table_napt, @function
init_table_napt:
	.frame	$sp,40,$31		# vars= 0, regs= 5/0, args= 16, gp= 0
	.mask	0x800f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
$L74 = .
$L75 = .
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$19,32($sp)
	sw	$18,28($sp)
	sw	$17,24($sp)
	sw	$16,20($sp)
	lui	$2,%hi(malloc_sizes+4)
	move	$17,$4
	lw	$4,%lo(malloc_sizes+4)($2)
	move	$19,$5
	jal	kmem_cache_alloc
	li	$5,32			# 0x20

	lui	$16,%hi(table_napt)
	move	$18,$2
	beq	$2,$0,$L76
	sw	$2,%lo(table_napt)($16)

$L77 = .
	li	$4,12			# 0xc
	mult	$17,$4
	lui	$7,%hi(napt_list_inuse)
	lui	$6,%hi(napt_list_free)
	addiu	$2,$6,%lo(napt_list_free)
	addiu	$3,$7,%lo(napt_list_inuse)
	sw	$0,%lo(napt_list_free)($6)
	li	$5,32			# 0x20
	lui	$6,%hi(napt_table_list_max)
	sw	$3,4($3)
	sw	$2,4($2)
	sw	$0,8($3)
	sw	$0,8($2)
	sw	$0,%lo(napt_list_inuse)($7)
	sw	$17,%lo(napt_table_list_max)($6)
	jal	__kmalloc
	mflo	$4

	sw	$2,0($18)
	lw	$2,%lo(table_napt)($16)
	nop
	lw	$2,0($2)
	nop
	beq	$2,$0,$L76
	move	$2,$0

	j	$L78
	li	$3,12			# 0xc

$L79:
	lw	$5,%lo(table_napt)($16)
	addiu	$2,$2,1
	lw	$5,0($5)
	mflo	$4
	addu	$5,$5,$4
	sw	$0,8($5)
	lw	$5,%lo(table_napt)($16)
	nop
	lw	$5,0($5)
	nop
	addu	$5,$5,$4
	sw	$0,0($5)
	lw	$5,%lo(table_napt)($16)
	nop
	lw	$5,0($5)
	nop
	addu	$4,$5,$4
	sw	$4,4($4)
$L78:
	slt	$4,$2,$17
	bne	$4,$0,$L79
	mult	$2,$3

	lui	$18,%hi(malloc_sizes)
	lui	$16,%hi(napt_list_free)
	addiu	$18,$18,%lo(malloc_sizes)
	addiu	$16,$16,%lo(napt_list_free)
	j	$L80
	move	$17,$0

$L81:
$L82 = .
	lw	$4,12($18)
	jal	kmem_cache_alloc
	li	$5,32			# 0x20

	bne	$2,$0,$L83
	addiu	$3,$2,44

	j	$L84
	li	$2,-2			# 0xfffffffe

$L83:
	sw	$0,44($2)
	lw	$4,4($16)
	addiu	$17,$17,1
	sw	$4,48($2)
	lw	$4,4($16)
	nop
	sw	$2,0($4)
	lw	$2,8($16)
	sw	$3,4($16)
	addiu	$2,$2,1
	sw	$2,8($16)
$L80:
	slt	$2,$17,$19
	bne	$2,$0,$L81
	move	$2,$0

	j	$L84
	nop

$L76:
	li	$2,-1			# 0xffffffff
$L84:
	lw	$31,36($sp)
	lw	$19,32($sp)
	lw	$18,28($sp)
	lw	$17,24($sp)
	lw	$16,20($sp)
	j	$31
	addiu	$sp,$sp,40

	.set	macro
	.set	reorder
	.end	init_table_napt
	.size	init_table_napt, .-init_table_napt
	.section	.rodata.str1.4
	.align	2
$LC4:
	.ascii	"lo\000"
	.section	.text.enter_fast_path,"ax",@progbits
	.align	2
	.globl	enter_fast_path
	.set	nomips16
	.ent	enter_fast_path
	.type	enter_fast_path, @function
enter_fast_path:
	.frame	$sp,88,$31		# vars= 24, regs= 10/0, args= 24, gp= 0
	.mask	0xc0ff0000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-88
	sw	$31,84($sp)
	sw	$fp,80($sp)
	sw	$23,76($sp)
	sw	$22,72($sp)
	sw	$21,68($sp)
	sw	$20,64($sp)
	sw	$19,60($sp)
	sw	$18,56($sp)
	sw	$17,52($sp)
	sw	$16,48($sp)
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_dev_name
	move	$21,$4
	.set	macro
	.set	reorder

	move	$4,$21
	.set	noreorder
	.set	nomacro
	jal	rtl_ip_hdr
	move	$16,$2
	.set	macro
	.set	reorder

	move	$17,$2
	lbu	$2,8($2)
	#nop
	sltu	$2,$2,2
	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L87
	li	$2,6			# 0x6
	.set	macro
	.set	reorder

	lbu	$22,9($17)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$22,$2,$L88
	li	$2,17			# 0x11
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$22,$2,$L89
	move	$4,$0
	.set	macro
	.set	reorder

$L88:
	lbu	$19,0($17)
	move	$4,$17
	move	$6,$21
	andi	$19,$19,0xf
	sll	$19,$19,2
	addu	$19,$17,$19
	.set	noreorder
	.set	nomacro
	jal	fast_path_pre_process_check
	move	$5,$19
	.set	macro
	.set	reorder

	move	$4,$2
	li	$2,6			# 0x6
	.set	noreorder
	.set	nomacro
	bne	$4,$2,$L89
	lui	$3,%hi($LC4)
	.set	macro
	.set	reorder

	addiu	$2,$3,%lo($LC4)
#APP
 # 75 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/string.h" 1
	.set	noreorder
	.set	noat
	lbu	$3,($16)
1:	lbu	$1,($2)
	addiu	$16,1
	bne	$1,$3,2f
	addiu	$2,1
	bnez	$3,1b
	lbu	$3,($16)
	nop
	move	$3,$1
2:	subu	$3,$1
3:	.set	at
	.set	reorder
 # 0 "" 2
#NO_APP
	beq	$3,$0,$L87
	lhu	$5,0($19)
	lhu	$7,2($19)
	lhu	$2,6($17)
	lw	$20,12($17)
	lw	$23,16($17)
	move	$3,$5
	.set	noreorder
	.set	nomacro
	bne	$22,$4,$L90
	move	$8,$7
	.set	macro
	.set	reorder

	andi	$4,$2,0x3fff
	.set	noreorder
	.set	nomacro
	beq	$4,$0,$L91
	li	$4,8192			# 0x2000
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$2,$4,$L221
	andi	$4,$2,0x3fff
	.set	macro
	.set	reorder

	j	$L91
$L218:
	move	$4,$20
	move	$6,$23
	.set	noreorder
	.set	nomacro
	jal	mark_path_invalid
	sw	$2,16($sp)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L89
	move	$4,$0
	.set	macro
	.set	reorder

$L183:
	li	$5,393216			# 0x60000
	and	$4,$4,$5
	.set	noreorder
	.set	nomacro
	bne	$4,$0,$L89
	move	$4,$0
	.set	macro
	.set	reorder

$L90:
	andi	$4,$2,0x3fff
$L221:
	.set	noreorder
	.set	nomacro
	beq	$4,$0,$L92
	move	$18,$0
	.set	macro
	.set	reorder

	li	$4,8192			# 0x2000
	.set	noreorder
	.set	nomacro
	bne	$2,$4,$L93
	move	$9,$0
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L94
	li	$fp,1			# 0x1
	.set	macro
	.set	reorder

$L93:
	andi	$4,$2,0x2000
	.set	noreorder
	.set	nomacro
	bne	$4,$0,$L94
	move	$fp,$0
	.set	macro
	.set	reorder

	andi	$2,$2,0x1fff
	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L94
	li	$9,1			# 0x1
	.set	macro
	.set	reorder

	move	$9,$0
	move	$fp,$0
$L94:
	lhu	$5,4($17)
	xor	$7,$23,$20
	lui	$6,%hi(max_udp_frag_entry)
	lbu	$4,9($17)
	lw	$10,%lo(max_udp_frag_entry)($6)
	xor	$2,$5,$7
	srl	$7,$7,16
	xor	$2,$2,$7
	xor	$6,$2,$4
	srl	$2,$2,8
	addiu	$7,$10,-1
	xor	$6,$6,$2
	and	$6,$6,$7
	li	$2,12			# 0xc
	mult	$6,$2
	lui	$7,%hi(negative_cache_table)
	lw	$7,%lo(negative_cache_table)($7)
	mflo	$2
	addu	$2,$7,$2
	lw	$2,0($2)
	.set	noreorder
	.set	nomacro
	j	$L96
	li	$10,3			# 0x3
	.set	macro
	.set	reorder

$L98:
	lhu	$7,2($2)
	#nop
	bne	$7,$5,$L97
	lw	$7,4($2)
	#nop
	bne	$7,$20,$L97
	lw	$7,8($2)
	#nop
	bne	$7,$23,$L97
	lbu	$7,1($2)
	#nop
	bne	$7,$4,$L97
	lbu	$7,0($2)
	#nop
	beq	$7,$10,$L87
$L97:
	lw	$2,36($2)
	#nop
$L96:
	bne	$2,$0,$L98
	.set	noreorder
	.set	nomacro
	j	$L216
	li	$2,12			# 0xc
	.set	macro
	.set	reorder

$L102:
	lhu	$2,2($18)
	#nop
	bne	$2,$5,$L100
	lw	$2,4($18)
	#nop
	bne	$2,$20,$L100
	lw	$2,8($18)
	#nop
	bne	$2,$23,$L100
	lbu	$2,1($18)
	#nop
	bne	$2,$4,$L100
	lbu	$2,0($18)
	#nop
	beq	$2,$10,$L101
$L100:
	lw	$18,40($18)
	#nop
$L178:
	bne	$18,$0,$L102
	j	$L217
$L101:
	lhu	$3,12($18)
	lhu	$8,14($18)
	.set	noreorder
	.set	nomacro
	beq	$fp,$0,$L105
	sw	$0,24($sp)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L219
	li	$fp,1			# 0x1
	.set	macro
	.set	reorder

$L179:
	lui	$3,%hi(negative_cache_list_free)
	lw	$2,%lo(negative_cache_list_free)($3)
	#nop
	beq	$2,$0,$L87
	lw	$7,44($2)
	sb	$4,1($2)
	li	$4,3			# 0x3
	sb	$4,0($2)
	sh	$5,2($2)
	sw	$20,4($2)
	sw	$23,8($2)
	lw	$4,48($2)
	.set	noreorder
	.set	nomacro
	beq	$7,$0,$L106
	addiu	$3,$3,%lo(negative_cache_list_free)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L107
	sw	$4,48($7)
	.set	macro
	.set	reorder

$L106:
	sw	$4,4($3)
$L107:
	li	$3,12			# 0xc
	mult	$6,$3
	lw	$5,44($2)
	lw	$3,48($2)
	lui	$4,%hi(negative_cache_list_free)
	addiu	$4,$4,%lo(negative_cache_list_free)
	sw	$5,0($3)
	lw	$5,8($4)
	lui	$3,%hi(negative_cache_table)
	addiu	$7,$2,36
	addiu	$5,$5,-1
	sw	$5,8($4)
	sw	$0,36($2)
	lw	$5,%lo(negative_cache_table)($3)
	addiu	$4,$2,12
	mflo	$6
	addu	$5,$5,$6
	lw	$5,4($5)
	#nop
	sw	$5,40($2)
	lw	$5,%lo(negative_cache_table)($3)
	#nop
	addu	$5,$5,$6
	lw	$5,4($5)
	#nop
	sw	$2,0($5)
	lw	$5,%lo(negative_cache_table)($3)
	#nop
	addu	$5,$5,$6
	sw	$7,4($5)
	lw	$3,%lo(negative_cache_table)($3)
	#nop
	addu	$6,$3,$6
	lw	$3,8($6)
	#nop
	addiu	$3,$3,1
	sw	$3,8($6)
	lui	$3,%hi(jiffies)
	lw	$3,%lo(jiffies)($3)
	#nop
	addiu	$3,$3,1000
	.set	noreorder
	.set	nomacro
	jal	add_timer
	sw	$3,20($2)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L89
	move	$4,$0
	.set	macro
	.set	reorder

$L92:
	li	$2,1			# 0x1
	move	$9,$0
	move	$fp,$0
	.set	noreorder
	.set	nomacro
	j	$L105
	sw	$2,24($sp)
	.set	macro
	.set	reorder

$L219:
	sw	$fp,24($sp)
$L105:
	xor	$4,$23,$20
	srl	$2,$20,8
	xor	$2,$4,$2
	srl	$4,$23,16
	xor	$2,$2,$4
	sw	$4,28($sp)
	xor	$2,$2,$22
	lui	$4,%hi(path_table_list_max)
	srl	$5,$3,4
	xor	$2,$2,$8
	lw	$4,%lo(path_table_list_max)($4)
	xor	$2,$2,$5
	srl	$5,$2,12
	xor	$2,$5,$2
	addiu	$4,$4,-1
	and	$2,$2,$4
	li	$4,12			# 0xc
	mult	$2,$4
	lui	$4,%hi(table_path)
	lw	$4,%lo(table_path)($4)
	li	$12,255			# 0xff
	li	$11,2			# 0x2
	lw	$4,0($4)
	li	$7,1			# 0x1
	li	$6,17			# 0x11
	mflo	$2
	addu	$2,$4,$2
	lw	$16,0($2)
	.set	noreorder
	.set	nomacro
	j	$L108
	li	$5,6			# 0x6
	.set	macro
	.set	reorder

$L175:
	lw	$2,12($16)
	#nop
	bne	$2,$3,$L109
	lw	$2,8($16)
	#nop
	bne	$2,$8,$L109
	lw	$2,16($16)
	#nop
	bne	$2,$20,$L109
	lw	$10,20($16)
	#nop
	bne	$10,$23,$L109
	lbu	$2,0($16)
	#nop
	bne	$2,$12,$L109
	lw	$2,4($16)
	#nop
	bne	$2,$11,$L110
	bne	$22,$5,$L109
	j	$L111
$L110:
	bne	$2,$7,$L109
	bne	$22,$6,$L109
$L111:
	lw	$5,32($16)
	lbu	$7,1($17)
	move	$4,$21
	move	$6,$20
	sw	$3,40($sp)
	sw	$8,36($sp)
	sw	$9,32($sp)
	.set	noreorder
	.set	nomacro
	jal	rtl_ip_route_input
	sw	$10,44($sp)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L89
	move	$4,$0
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_skb_dst_check
	move	$4,$21
	.set	macro
	.set	reorder

	li	$4,-1			# 0xffffffff
	lw	$3,40($sp)
	lw	$8,36($sp)
	lw	$9,32($sp)
	lw	$10,44($sp)
	.set	noreorder
	.set	nomacro
	beq	$2,$4,$L117
	li	$2,6			# 0x6
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	beq	$22,$2,$L114
	addiu	$7,$19,16
	.set	macro
	.set	reorder

	lhu	$7,6($19)
	addiu	$2,$19,6
	movz	$2,$0,$7
	move	$7,$2
$L114:
	.set	noreorder
	.set	nomacro
	beq	$fp,$0,$L116
	lui	$6,%hi(udp_cache_list_free)
	.set	macro
	.set	reorder

	lw	$2,%lo(udp_cache_list_free)($6)
	lui	$4,%hi(max_udp_frag_entry)
	lw	$11,%lo(max_udp_frag_entry)($4)
	lhu	$5,4($17)
	beq	$2,$0,$L117
	lw	$9,48($2)
	sh	$3,12($2)
	li	$3,1			# 0x1
	sh	$8,14($2)
	sb	$3,0($2)
	sh	$5,2($2)
	sw	$20,4($2)
	sw	$10,8($2)
	sb	$22,1($2)
	lw	$4,52($2)
	.set	noreorder
	.set	nomacro
	beq	$9,$0,$L118
	addiu	$6,$6,%lo(udp_cache_list_free)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L119
	sw	$4,52($9)
	.set	macro
	.set	reorder

$L118:
	sw	$4,4($6)
$L119:
	xor	$4,$10,$20
	xor	$10,$5,$4
	srl	$4,$4,16
	xor	$10,$10,$4
	srl	$4,$10,8
	xor	$3,$10,$22
	xor	$3,$3,$4
	addiu	$4,$11,-1
	and	$3,$3,$4
	li	$4,12			# 0xc
	mult	$3,$4
	lw	$5,52($2)
	lw	$6,48($2)
	lui	$4,%hi(udp_cache_list_free)
	addiu	$4,$4,%lo(udp_cache_list_free)
	sw	$6,0($5)
	lw	$6,8($4)
	lui	$5,%hi(udp_cache_table)
	addiu	$8,$2,40
	addiu	$6,$6,-1
	sw	$6,8($4)
	sw	$0,40($2)
	lw	$6,%lo(udp_cache_table)($5)
	addiu	$4,$2,16
	lw	$6,0($6)
	mflo	$3
	addu	$6,$6,$3
	lw	$6,4($6)
	#nop
	sw	$6,44($2)
	lw	$6,%lo(udp_cache_table)($5)
	#nop
	lw	$6,0($6)
	#nop
	addu	$6,$6,$3
	lw	$6,4($6)
	#nop
	sw	$2,0($6)
	lw	$6,%lo(udp_cache_table)($5)
	#nop
	lw	$6,0($6)
	#nop
	addu	$6,$6,$3
	sw	$8,4($6)
	lw	$5,%lo(udp_cache_table)($5)
	#nop
	lw	$5,0($5)
	#nop
	addu	$3,$5,$3
	lw	$5,8($3)
	#nop
	addiu	$5,$5,1
	sw	$5,8($3)
	lui	$3,%hi(jiffies)
	lw	$3,%lo(jiffies)($3)
	#nop
	addiu	$3,$3,1000
	sw	$3,24($2)
	.set	noreorder
	.set	nomacro
	jal	add_timer
	sw	$7,32($sp)
	.set	macro
	.set	reorder

	lw	$7,32($sp)
	.set	noreorder
	.set	nomacro
	j	$L220
	move	$4,$21
	.set	macro
	.set	reorder

$L117:
	.set	noreorder
	.set	nomacro
	jal	rtl_dst_release
	move	$4,$21
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L89
	move	$4,$0
	.set	macro
	.set	reorder

$L116:
	.set	noreorder
	.set	nomacro
	beq	$9,$0,$L220
	move	$4,$21
	.set	macro
	.set	reorder

	addiu	$4,$18,16
	.set	noreorder
	.set	nomacro
	jal	del_timer
	sw	$7,32($sp)
	.set	macro
	.set	reorder

	lw	$5,8($18)
	lw	$4,4($18)
	lhu	$3,2($18)
	lbu	$2,1($18)
	xor	$4,$5,$4
	lui	$5,%hi(max_udp_frag_entry)
	xor	$3,$3,$4
	lw	$5,%lo(max_udp_frag_entry)($5)
	srl	$4,$4,16
	xor	$3,$3,$4
	lw	$4,40($18)
	xor	$2,$3,$2
	srl	$3,$3,8
	xor	$2,$2,$3
	addiu	$5,$5,-1
	sb	$0,0($18)
	lw	$3,44($18)
	lw	$7,32($sp)
	.set	noreorder
	.set	nomacro
	beq	$4,$0,$L121
	and	$2,$2,$5
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L122
	sw	$3,44($4)
	.set	macro
	.set	reorder

$L121:
	li	$4,12			# 0xc
	mult	$2,$4
	lui	$5,%hi(udp_cache_table)
	lw	$5,%lo(udp_cache_table)($5)
	#nop
	lw	$5,0($5)
	mflo	$4
	addu	$4,$5,$4
	sw	$3,4($4)
$L122:
	li	$3,12			# 0xc
	mult	$2,$3
	lw	$4,40($18)
	lw	$3,44($18)
	#nop
	sw	$4,0($3)
	lui	$3,%hi(udp_cache_table)
	lw	$5,%lo(udp_cache_table)($3)
	lui	$3,%hi(udp_cache_list_free)
	addiu	$3,$3,%lo(udp_cache_list_free)
	lw	$5,0($5)
	addiu	$4,$18,48
	mflo	$2
	addu	$2,$5,$2
	lw	$5,8($2)
	#nop
	addiu	$5,$5,-1
	sw	$5,8($2)
	sw	$0,48($18)
	lw	$2,4($3)
	#nop
	sw	$2,52($18)
	lw	$2,4($3)
	#nop
	sw	$18,0($2)
	lw	$2,8($3)
	sw	$4,4($3)
	addiu	$2,$2,1
	sw	$2,8($3)
	move	$4,$21
$L220:
	move	$5,$17
	move	$6,$22
	.set	noreorder
	.set	nomacro
	jal	fast_path_before_nat_check
	sw	$7,32($sp)
	.set	macro
	.set	reorder

	move	$4,$2
	li	$2,1			# 0x1
	lw	$7,32($sp)
	.set	noreorder
	.set	nomacro
	beq	$4,$2,$L89
	li	$2,6			# 0x6
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$22,$2,$L123
	li	$2,1048576			# 0x100000
	.set	macro
	.set	reorder

	lw	$3,12($19)
	#nop
	and	$2,$3,$2
	.set	noreorder
	.set	nomacro
	beq	$2,$0,$L123
	li	$2,40			# 0x28
	.set	macro
	.set	reorder

	lhu	$3,2($17)
	#nop
	.set	noreorder
	.set	nomacro
	bne	$3,$2,$L123
	move	$4,$21
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	skb_trim
	li	$5,40			# 0x28
	.set	macro
	.set	reorder

	lw	$7,32($sp)
$L123:
	lbu	$2,1($16)
	#nop
	sltu	$3,$2,13
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L124
	lui	$3,%hi($L130)
	.set	macro
	.set	reorder

	addiu	$3,$3,%lo($L130)
	sll	$2,$2,2
	addu	$2,$3,$2
	lw	$2,0($2)
	lhu	$3,10($17)
	j	$2
	.rdata
	.align	2
	.align	2
$L130:
	.word	$L125
	.word	$L126
	.word	$L127
	.word	$L127
	.word	$L128
	.word	$L124
	.word	$L124
	.word	$L124
	.word	$L129
	.word	$L124
	.word	$L124
	.word	$L124
	.word	$L129
	.section	.text.enter_fast_path
$L126:
	lw	$2,24($16)
	srl	$4,$20,16
	andi	$20,$20,0xffff
	srl	$5,$2,16
	subu	$5,$0,$5
	andi	$2,$2,0xffff
	subu	$2,$5,$2
	addu	$2,$2,$4
	addu	$20,$2,$20
	addu	$3,$20,$3
	.set	noreorder
	.set	nomacro
	bgez	$3,$L131
	andi	$20,$3,0xffff
	.set	macro
	.set	reorder

	subu	$3,$0,$3
	andi	$2,$3,0xffff
	sra	$3,$3,16
	addu	$3,$2,$3
	sra	$2,$3,16
	addu	$3,$2,$3
	.set	noreorder
	.set	nomacro
	j	$L185
	nor	$3,$0,$3
	.set	macro
	.set	reorder

$L131:
	sra	$3,$3,16
	addu	$3,$20,$3
	sra	$2,$3,16
	addu	$3,$2,$3
$L185:
	sh	$3,10($17)
	lw	$2,24($sp)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$2,$0,$L140
	li	$2,17			# 0x11
	.set	macro
	.set	reorder

	bne	$22,$2,$L134
	beq	$7,$0,$L140
	lhu	$3,0($7)
	#nop
	beq	$3,$0,$L140
	lw	$5,24($16)
	lw	$4,12($17)
	srl	$2,$5,16
	subu	$2,$0,$2
	andi	$5,$5,0xffff
	srl	$6,$4,16
	subu	$2,$2,$5
	addu	$2,$2,$6
	andi	$4,$4,0xffff
	addu	$2,$2,$4
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	bgez	$2,$L135
	andi	$3,$2,0xffff
	.set	macro
	.set	reorder

	subu	$2,$0,$2
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	j	$L187
	nor	$2,$0,$2
	.set	macro
	.set	reorder

$L135:
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
$L187:
	.set	noreorder
	.set	nomacro
	j	$L140
	sh	$2,0($7)
	.set	macro
	.set	reorder

$L134:
	lw	$4,24($16)
	lw	$3,12($17)
	lhu	$2,0($7)
	srl	$5,$4,16
	subu	$5,$0,$5
	andi	$4,$4,0xffff
	subu	$4,$5,$4
	srl	$5,$3,16
	addu	$4,$4,$5
	andi	$3,$3,0xffff
	addu	$3,$4,$3
	addu	$2,$2,$3
	.set	noreorder
	.set	nomacro
	bgez	$2,$L136
	andi	$3,$2,0xffff
	.set	macro
	.set	reorder

	subu	$2,$0,$2
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	j	$L186
	nor	$2,$0,$2
	.set	macro
	.set	reorder

$L136:
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
$L186:
	sh	$2,0($7)
	lw	$3,12($19)
	li	$2,1048576			# 0x100000
	and	$2,$3,$2
	.set	noreorder
	.set	nomacro
	beq	$2,$0,$L140
	li	$2,40			# 0x28
	.set	macro
	.set	reorder

	lhu	$3,2($17)
	#nop
	.set	noreorder
	.set	nomacro
	bne	$3,$2,$L140
	move	$4,$21
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	skb_trim
	li	$5,40			# 0x28
	.set	macro
	.set	reorder

	j	$L140
$L127:
	lw	$2,24($16)
	srl	$4,$20,16
	andi	$20,$20,0xffff
	srl	$5,$2,16
	subu	$5,$0,$5
	andi	$2,$2,0xffff
	subu	$2,$5,$2
	addu	$2,$2,$4
	addu	$20,$2,$20
	addu	$3,$20,$3
	.set	noreorder
	.set	nomacro
	bgez	$3,$L138
	andi	$20,$3,0xffff
	.set	macro
	.set	reorder

	subu	$3,$0,$3
	andi	$2,$3,0xffff
	sra	$3,$3,16
	addu	$3,$2,$3
	sra	$2,$3,16
	addu	$3,$2,$3
	.set	noreorder
	.set	nomacro
	j	$L188
	nor	$3,$0,$3
	.set	macro
	.set	reorder

$L138:
	sra	$3,$3,16
	addu	$3,$20,$3
	sra	$2,$3,16
	addu	$3,$2,$3
$L188:
	sh	$3,10($17)
	lw	$3,24($sp)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L140
	li	$2,17			# 0x11
	.set	macro
	.set	reorder

	bne	$22,$2,$L141
	beq	$7,$0,$L142
	lhu	$3,0($7)
	#nop
	beq	$3,$0,$L142
	lw	$5,24($16)
	lw	$4,12($17)
	lhu	$8,0($19)
	srl	$2,$5,16
	subu	$2,$0,$2
	andi	$5,$5,0xffff
	srl	$6,$4,16
	subu	$2,$2,$5
	addu	$2,$2,$6
	andi	$4,$4,0xffff
	lw	$6,28($16)
	addu	$2,$2,$4
	addu	$2,$2,$8
	subu	$2,$2,$6
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	bgez	$2,$L143
	andi	$3,$2,0xffff
	.set	macro
	.set	reorder

	subu	$2,$0,$2
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	j	$L190
	nor	$2,$0,$2
	.set	macro
	.set	reorder

$L143:
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
$L190:
	.set	noreorder
	.set	nomacro
	j	$L142
	sh	$2,0($7)
	.set	macro
	.set	reorder

$L141:
	lw	$4,24($16)
	lw	$3,12($17)
	lhu	$8,0($19)
	srl	$2,$4,16
	subu	$2,$0,$2
	andi	$4,$4,0xffff
	srl	$5,$3,16
	subu	$2,$2,$4
	addu	$2,$2,$5
	andi	$3,$3,0xffff
	lw	$6,28($16)
	addu	$2,$2,$3
	lhu	$5,0($7)
	addu	$2,$2,$8
	subu	$2,$2,$6
	addu	$2,$5,$2
	.set	noreorder
	.set	nomacro
	bgez	$2,$L144
	andi	$3,$2,0xffff
	.set	macro
	.set	reorder

	subu	$2,$0,$2
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	j	$L189
	nor	$2,$0,$2
	.set	macro
	.set	reorder

$L144:
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
$L189:
	sh	$2,0($7)
	lw	$3,12($19)
	li	$2,1048576			# 0x100000
	and	$2,$3,$2
	.set	noreorder
	.set	nomacro
	beq	$2,$0,$L142
	li	$2,40			# 0x28
	.set	macro
	.set	reorder

	lhu	$3,2($17)
	#nop
	.set	noreorder
	.set	nomacro
	bne	$3,$2,$L142
	move	$4,$21
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	skb_trim
	li	$5,40			# 0x28
	.set	macro
	.set	reorder

$L142:
	lw	$2,28($16)
	#nop
	sh	$2,0($19)
$L140:
	lw	$2,24($16)
	.set	noreorder
	.set	nomacro
	j	$L125
	sw	$2,12($17)
	.set	macro
	.set	reorder

$L128:
	lw	$4,32($16)
	lw	$5,28($sp)
	andi	$23,$23,0xffff
	andi	$20,$4,0xffff
	addu	$2,$23,$5
	subu	$20,$2,$20
	srl	$4,$4,16
	subu	$4,$20,$4
	addu	$3,$4,$3
	.set	noreorder
	.set	nomacro
	bgez	$3,$L146
	andi	$20,$3,0xffff
	.set	macro
	.set	reorder

	subu	$3,$0,$3
	andi	$4,$3,0xffff
	sra	$3,$3,16
	addu	$3,$4,$3
	sra	$4,$3,16
	addu	$3,$4,$3
	.set	noreorder
	.set	nomacro
	j	$L191
	nor	$3,$0,$3
	.set	macro
	.set	reorder

$L146:
	sra	$3,$3,16
	addu	$3,$20,$3
	sra	$4,$3,16
	addu	$3,$4,$3
$L191:
	sh	$3,10($17)
	lw	$3,24($sp)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L200
	li	$3,17			# 0x11
	.set	macro
	.set	reorder

	bne	$22,$3,$L149
	beq	$7,$0,$L200
	lhu	$3,0($7)
	#nop
	beq	$3,$0,$L200
	lw	$4,32($16)
	#nop
	andi	$23,$4,0xffff
	subu	$23,$2,$23
	srl	$4,$4,16
	subu	$23,$23,$4
	.set	noreorder
	.set	nomacro
	j	$L206
	addu	$23,$3,$23
	.set	macro
	.set	reorder

$L149:
	lw	$3,32($16)
	lhu	$23,0($7)
	andi	$4,$3,0xffff
	subu	$2,$2,$4
	srl	$3,$3,16
	subu	$2,$2,$3
	addu	$23,$23,$2
$L206:
	.set	noreorder
	.set	nomacro
	bgez	$23,$L151
	andi	$2,$23,0xffff
	.set	macro
	.set	reorder

	subu	$23,$0,$23
	andi	$2,$23,0xffff
	sra	$23,$23,16
	addu	$23,$2,$23
	sra	$2,$23,16
	addu	$23,$2,$23
	.set	noreorder
	.set	nomacro
	j	$L192
	nor	$23,$0,$23
	.set	macro
	.set	reorder

$L151:
	sra	$23,$23,16
	addu	$23,$2,$23
	sra	$2,$23,16
	addu	$23,$2,$23
$L192:
	.set	noreorder
	.set	nomacro
	j	$L200
	sh	$23,0($7)
	.set	macro
	.set	reorder

$L129:
	lw	$2,32($16)
	lw	$4,28($sp)
	andi	$23,$23,0xffff
	andi	$20,$2,0xffff
	addu	$23,$23,$4
	subu	$20,$23,$20
	srl	$2,$2,16
	subu	$20,$20,$2
	addu	$20,$20,$3
	.set	noreorder
	.set	nomacro
	bgez	$20,$L152
	andi	$2,$20,0xffff
	.set	macro
	.set	reorder

	subu	$20,$0,$20
	andi	$2,$20,0xffff
	sra	$20,$20,16
	addu	$20,$2,$20
	sra	$2,$20,16
	addu	$20,$2,$20
	.set	noreorder
	.set	nomacro
	j	$L193
	nor	$20,$0,$20
	.set	macro
	.set	reorder

$L152:
	sra	$20,$20,16
	addu	$20,$2,$20
	sra	$2,$20,16
	addu	$20,$2,$20
$L193:
	sh	$20,10($17)
	lw	$5,24($sp)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$5,$0,$L200
	li	$2,17			# 0x11
	.set	macro
	.set	reorder

	bne	$22,$2,$L155
	beq	$7,$0,$L156
	lhu	$3,0($7)
	#nop
	beq	$3,$0,$L156
	lw	$4,32($16)
	lhu	$6,2($19)
	lw	$5,36($16)
	andi	$2,$4,0xffff
	subu	$2,$23,$2
	srl	$4,$4,16
	subu	$2,$2,$4
	addu	$2,$2,$6
	subu	$2,$2,$5
	.set	noreorder
	.set	nomacro
	j	$L208
	addu	$2,$3,$2
	.set	macro
	.set	reorder

$L155:
	lw	$3,32($16)
	lhu	$6,2($19)
	lw	$5,36($16)
	andi	$2,$3,0xffff
	subu	$2,$23,$2
	srl	$3,$3,16
	subu	$2,$2,$3
	lhu	$4,0($7)
	addu	$2,$2,$6
	subu	$2,$2,$5
	addu	$2,$4,$2
$L208:
	.set	noreorder
	.set	nomacro
	bgez	$2,$L158
	andi	$3,$2,0xffff
	.set	macro
	.set	reorder

	subu	$2,$0,$2
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	j	$L194
	nor	$2,$0,$2
	.set	macro
	.set	reorder

$L158:
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
$L194:
	sh	$2,0($7)
$L156:
	lw	$2,36($16)
	.set	noreorder
	.set	nomacro
	j	$L200
	sh	$2,2($19)
	.set	macro
	.set	reorder

$L124:
	lw	$3,24($16)
	srl	$2,$20,16
	andi	$20,$20,0xffff
	addu	$20,$20,$2
	lhu	$4,10($17)
	andi	$2,$3,0xffff
	subu	$2,$20,$2
	srl	$3,$3,16
	subu	$2,$2,$3
	addu	$2,$2,$4
	.set	noreorder
	.set	nomacro
	bgez	$2,$L159
	andi	$3,$2,0xffff
	.set	macro
	.set	reorder

	subu	$2,$0,$2
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	j	$L195
	nor	$2,$0,$2
	.set	macro
	.set	reorder

$L159:
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
$L195:
	sh	$2,10($17)
	lw	$2,32($16)
	lw	$3,28($sp)
	andi	$23,$23,0xffff
	andi	$4,$2,0xffff
	addu	$23,$23,$3
	lhu	$3,10($17)
	subu	$4,$23,$4
	srl	$2,$2,16
	subu	$4,$4,$2
	addu	$4,$4,$3
	.set	noreorder
	.set	nomacro
	bgez	$4,$L161
	andi	$2,$4,0xffff
	.set	macro
	.set	reorder

	subu	$4,$0,$4
	andi	$2,$4,0xffff
	sra	$4,$4,16
	addu	$4,$2,$4
	sra	$2,$4,16
	addu	$4,$2,$4
	.set	noreorder
	.set	nomacro
	j	$L196
	nor	$4,$0,$4
	.set	macro
	.set	reorder

$L161:
	sra	$4,$4,16
	addu	$4,$2,$4
	sra	$2,$4,16
	addu	$4,$2,$4
$L196:
	sh	$4,10($17)
	lw	$4,24($sp)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$4,$0,$L163
	li	$2,17			# 0x11
	.set	macro
	.set	reorder

	bne	$22,$2,$L164
	beq	$7,$0,$L165
	lhu	$2,0($7)
	#nop
	beq	$2,$0,$L165
	lw	$4,24($16)
	lhu	$6,0($19)
	lw	$5,28($16)
	andi	$3,$4,0xffff
	subu	$3,$20,$3
	srl	$4,$4,16
	subu	$3,$3,$4
	addu	$3,$3,$6
	subu	$3,$3,$5
	.set	noreorder
	.set	nomacro
	j	$L212
	addu	$3,$2,$3
	.set	macro
	.set	reorder

$L164:
	lw	$2,24($16)
	lhu	$6,0($19)
	lw	$5,28($16)
	andi	$3,$2,0xffff
	subu	$3,$20,$3
	srl	$2,$2,16
	subu	$3,$3,$2
	lhu	$4,0($7)
	addu	$3,$3,$6
	subu	$3,$3,$5
	addu	$3,$4,$3
$L212:
	.set	noreorder
	.set	nomacro
	bgez	$3,$L169
	andi	$2,$3,0xffff
	.set	macro
	.set	reorder

	subu	$3,$0,$3
	andi	$2,$3,0xffff
	sra	$3,$3,16
	addu	$3,$2,$3
	sra	$2,$3,16
	addu	$3,$2,$3
	.set	noreorder
	.set	nomacro
	j	$L198
	nor	$3,$0,$3
	.set	macro
	.set	reorder

$L169:
	sra	$3,$3,16
	addu	$3,$2,$3
	sra	$2,$3,16
	addu	$3,$2,$3
$L198:
	sh	$3,0($7)
	lw	$3,32($16)
	lhu	$6,2($19)
	lw	$5,36($16)
	andi	$2,$3,0xffff
	subu	$2,$23,$2
	srl	$3,$3,16
	subu	$2,$2,$3
	lhu	$4,0($7)
	addu	$2,$2,$6
	subu	$2,$2,$5
	addu	$2,$4,$2
	.set	noreorder
	.set	nomacro
	bgez	$2,$L171
	andi	$3,$2,0xffff
	.set	macro
	.set	reorder

	subu	$2,$0,$2
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	j	$L199
	nor	$2,$0,$2
	.set	macro
	.set	reorder

$L171:
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
$L199:
	sh	$2,0($7)
$L165:
	lw	$2,28($16)
	#nop
	sh	$2,0($19)
	lw	$2,36($16)
	#nop
	sh	$2,2($19)
$L163:
	lw	$2,24($16)
	#nop
	sw	$2,12($17)
$L200:
	lw	$2,32($16)
	#nop
	sw	$2,16($17)
$L125:
	lbu	$5,8($17)
	lbu	$4,9($17)
	lhu	$7,10($17)
	addiu	$3,$5,-1
	andi	$3,$3,0x00ff
	sll	$2,$5,8
	or	$2,$2,$4
	sll	$6,$3,8
	addu	$2,$2,$7
	or	$4,$6,$4
	subu	$2,$2,$4
	.set	noreorder
	.set	nomacro
	bgez	$2,$L172
	sb	$3,8($17)
	.set	macro
	.set	reorder

	subu	$2,$0,$2
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
	.set	noreorder
	.set	nomacro
	j	$L201
	nor	$2,$0,$2
	.set	macro
	.set	reorder

$L172:
	andi	$3,$2,0xffff
	sra	$2,$2,16
	addu	$2,$3,$2
	sra	$3,$2,16
	addu	$2,$3,$2
$L201:
	sh	$2,10($17)
	move	$5,$0
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_ip_summed
	move	$4,$21
	.set	macro
	.set	reorder

	move	$4,$21
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_dev
	move	$5,$0
	.set	macro
	.set	reorder

	lw	$5,48($16)
	lw	$6,52($16)
	.set	noreorder
	.set	nomacro
	jal	fastpath_set_qos_mark
	move	$4,$21
	.set	macro
	.set	reorder

	lui	$2,%hi(jiffies)
	lw	$2,%lo(jiffies)($2)
	move	$4,$17
	move	$5,$19
	sw	$2,40($16)
	.set	noreorder
	.set	nomacro
	jal	fast_path_post_process_xmit_check
	move	$6,$21
	.set	macro
	.set	reorder

	li	$3,1			# 0x1
	.set	noreorder
	.set	nomacro
	beq	$2,$3,$L89
	li	$4,1			# 0x1
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	ip_finish_output3
	move	$4,$21
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L89
	li	$4,1			# 0x1
	.set	macro
	.set	reorder

$L109:
	lw	$16,64($16)
	#nop
$L108:
	bne	$16,$0,$L175
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_inDev
	move	$4,$21
	.set	macro
	.set	reorder

	move	$4,$17
	move	$5,$19
	move	$6,$21
	lw	$31,84($sp)
	lw	$fp,80($sp)
	lw	$23,76($sp)
	lw	$22,72($sp)
	lw	$21,68($sp)
	lw	$20,64($sp)
	lw	$19,60($sp)
	lw	$18,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	.set	noreorder
	.set	nomacro
	j	fast_path_post_process_return_check
	addiu	$sp,$sp,88
	.set	macro
	.set	reorder

$L87:
	move	$4,$0
$L89:
	lw	$31,84($sp)
	lw	$fp,80($sp)
	lw	$23,76($sp)
	lw	$22,72($sp)
	lw	$21,68($sp)
	lw	$20,64($sp)
	lw	$19,60($sp)
	lw	$18,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	move	$2,$4
	.set	noreorder
	.set	nomacro
	j	$31
	addiu	$sp,$sp,88
	.set	macro
	.set	reorder

$L91:
	lw	$4,12($19)
	li	$6,65536			# 0x10000
	and	$6,$4,$6
	beq	$6,$0,$L183
	.set	noreorder
	.set	nomacro
	j	$L218
	li	$2,6			# 0x6
	.set	macro
	.set	reorder

$L216:
	mult	$6,$2
	lui	$7,%hi(udp_cache_table)
	lw	$7,%lo(udp_cache_table)($7)
	#nop
	lw	$7,0($7)
	mflo	$2
	addu	$2,$7,$2
	lw	$18,0($2)
	.set	noreorder
	.set	nomacro
	j	$L178
	li	$10,1			# 0x1
	.set	macro
	.set	reorder

$L217:
	.set	noreorder
	.set	nomacro
	beq	$fp,$0,$L179
	li	$fp,1			# 0x1
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L105
	sw	$fp,24($sp)
	.set	macro
	.set	reorder

	.end	enter_fast_path
	.size	enter_fast_path, .-enter_fast_path
	.section	.text.rtl_fp_mark_invalid,"ax",@progbits
	.align	2
	.globl	rtl_fp_mark_invalid
	.set	nomips16
	.ent	rtl_fp_mark_invalid
	.type	rtl_fp_mark_invalid, @function
rtl_fp_mark_invalid:
	.frame	$sp,72,$31		# vars= 8, regs= 10/0, args= 24, gp= 0
	.mask	0xc0ff0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-72
	sw	$31,68($sp)
	sw	$fp,64($sp)
	sw	$23,60($sp)
	sw	$22,56($sp)
	sw	$21,52($sp)
	sw	$20,48($sp)
	sw	$19,44($sp)
	sw	$18,40($sp)
	sw	$17,36($sp)
	sw	$16,32($sp)
	li	$5,1			# 0x1
	move	$21,$4
	jal	rtl_get_ct_ip_by_dir
	move	$6,$0

	move	$4,$21
	li	$5,1			# 0x1
	li	$6,1			# 0x1
	jal	rtl_get_ct_ip_by_dir
	move	$fp,$2

	move	$4,$21
	move	$5,$0
	move	$6,$0
	jal	rtl_get_ct_ip_by_dir
	move	$22,$2

	move	$4,$21
	move	$5,$0
	li	$6,1			# 0x1
	jal	rtl_get_ct_ip_by_dir
	move	$19,$2

	move	$4,$21
	li	$5,1			# 0x1
	move	$6,$0
	jal	rtl_get_ct_port_by_dir
	move	$17,$2

	move	$4,$21
	li	$5,1			# 0x1
	li	$6,1			# 0x1
	jal	rtl_get_ct_port_by_dir
	move	$23,$2

	move	$4,$21
	move	$5,$0
	move	$6,$0
	jal	rtl_get_ct_port_by_dir
	sw	$2,24($sp)

	li	$6,1			# 0x1
	move	$4,$21
	move	$5,$0
	jal	rtl_get_ct_port_by_dir
	move	$18,$2

	move	$4,$21
	li	$5,1			# 0x1
	jal	rtl_get_ct_protonum
	move	$16,$2

	move	$4,$21
	move	$5,$0
	jal	rtl_get_ct_protonum
	move	$20,$2

	lw	$7,24($sp)
	move	$4,$fp
	move	$5,$23
	move	$6,$22
	move	$21,$2
	jal	mark_path_invalid
	sw	$20,16($sp)

	move	$4,$19
	move	$5,$18
	move	$6,$17
	move	$7,$16
	jal	mark_path_invalid
	sw	$21,16($sp)

	lw	$31,68($sp)
	lw	$fp,64($sp)
	lw	$23,60($sp)
	lw	$22,56($sp)
	lw	$21,52($sp)
	lw	$20,48($sp)
	lw	$19,44($sp)
	lw	$18,40($sp)
	lw	$17,36($sp)
	lw	$16,32($sp)
	j	$31
	addiu	$sp,$sp,72

	.set	macro
	.set	reorder
	.end	rtl_fp_mark_invalid
	.size	rtl_fp_mark_invalid, .-rtl_fp_mark_invalid
	.section	.text.rtl_br_fdb_time_update,"ax",@progbits
	.align	2
	.globl	rtl_br_fdb_time_update
	.set	nomips16
	.ent	rtl_br_fdb_time_update
	.type	rtl_br_fdb_time_update, @function
rtl_br_fdb_time_update:
	.frame	$sp,32,$31		# vars= 0, regs= 4/0, args= 16, gp= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$18,24($sp)
	sw	$17,20($sp)
	sw	$16,16($sp)
	move	$17,$4
	move	$16,$5
	move	$4,$0
	move	$5,$6
	jal	rtl_get_hw_fdb_age
	li	$6,2			# 0x2

	li	$3,300			# 0x12c
	beq	$2,$3,$L227
	li	$3,450			# 0x1c2

	beq	$2,$3,$L228
	li	$3,150			# 0x96

	bne	$2,$3,$L235
	move	$4,$16

	j	$L234
	lui	$2,%hi(jiffies)

$L228:
	lui	$2,%hi(jiffies)
	lw	$5,%lo(jiffies)($2)
	j	$L232
	move	$4,$16

$L227:
	lui	$2,%hi(jiffies)
	lw	$5,%lo(jiffies)($2)
	move	$4,$16
	j	$L232
	addiu	$5,$5,-15000

$L234:
	lw	$5,%lo(jiffies)($2)
	move	$4,$16
	addiu	$5,$5,-30000
$L232:
	jal	rtl_set_fdb_aging
	nop

	move	$4,$16
$L235:
	lui	$2,%hi(jiffies)
	lw	$16,%lo(jiffies)($2)
	jal	rtl_get_fdb_aging
	nop

	move	$4,$17
	jal	rtl_hold_time
	move	$18,$2

	addu	$2,$2,$18
	subu	$2,$16,$2
	slt	$2,$2,0
	li	$3,-1			# 0xffffffff
	lw	$31,28($sp)
	lw	$18,24($sp)
	lw	$17,20($sp)
	lw	$16,16($sp)
	movn	$3,$0,$2
	move	$2,$3
	j	$31
	addiu	$sp,$sp,32

	.set	macro
	.set	reorder
	.end	rtl_br_fdb_time_update
	.size	rtl_br_fdb_time_update, .-rtl_br_fdb_time_update
	.section	.text.rtk_idleNaptConnection,"ax",@progbits
	.align	2
	.globl	rtk_idleNaptConnection
	.set	nomips16
	.ent	rtk_idleNaptConnection
	.type	rtk_idleNaptConnection, @function
rtk_idleNaptConnection:
	.frame	$sp,24,$31		# vars= 0, regs= 1/0, args= 16, gp= 0
	.mask	0x80000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	lw	$7,4($4)
	lw	$2,20($4)
	lw	$6,24($4)
	lw	$8,8($4)
	xor	$12,$2,$7
	srl	$3,$7,8
	lw	$9,0($4)
	xor	$12,$12,$6
	xor	$12,$12,$3
	srl	$3,$2,16
	xor	$12,$12,$3
	srl	$10,$8,4
	xori	$13,$9,0x2
	li	$11,6			# 0x6
	xor	$12,$12,$10
	li	$3,17			# 0x11
	lui	$10,%hi(path_table_list_max)
	movz	$3,$11,$13
	lw	$11,%lo(path_table_list_max)($10)
	xor	$12,$12,$3
	srl	$10,$12,12
	xor	$12,$10,$12
	addiu	$11,$11,-1
	and	$12,$12,$11
	li	$10,12			# 0xc
	mult	$12,$10
	lui	$10,%hi(table_path)
	lw	$10,%lo(table_path)($10)
	li	$12,-16777216			# 0xff000000
	lui	$13,%hi(jiffies)
	lw	$10,0($10)
	ori	$15,$12,0x100
	lw	$13,%lo(jiffies)($13)
	mflo	$24
	addu	$14,$10,$24
	lw	$14,0($14)
	j	$L239
	ori	$12,$12,0xff00

$L243:
	lw	$24,4($14)
	nop
	bne	$24,$9,$L240
	nop

	lw	$24,0($14)
	nop
	and	$24,$24,$12
	bne	$24,$15,$L240
	nop

	lw	$24,16($14)
	nop
	bne	$24,$7,$L240
	nop

	lw	$24,12($14)
	nop
	bne	$24,$8,$L240
	nop

	lw	$25,24($14)
	lw	$24,12($4)
	nop
	bne	$25,$24,$L240
	nop

	lw	$25,28($14)
	lw	$24,16($4)
	nop
	bne	$25,$24,$L240
	nop

	lw	$24,20($14)
	nop
	bne	$24,$2,$L240
	nop

	lw	$24,8($14)
	nop
	bne	$24,$6,$L240
	nop

	lw	$12,40($14)
	subu	$15,$13,$5
	subu	$15,$15,$12
	bgez	$15,$L241
	nop

	lw	$4,56($14)
	j	$L249
	addu	$5,$5,$12

$L240:
	lw	$14,64($14)
	nop
$L239:
	bne	$14,$0,$L243
	nop

$L241:
	lw	$12,12($4)
	lw	$4,16($4)
	srl	$15,$2,8
	xor	$14,$12,$2
	xor	$14,$14,$4
	xor	$14,$14,$15
	srl	$15,$12,16
	xor	$14,$14,$15
	srl	$15,$6,4
	xor	$14,$14,$15
	xor	$3,$14,$3
	srl	$14,$3,12
	xor	$3,$14,$3
	and	$11,$3,$11
	li	$14,12			# 0xc
	mult	$11,$14
	li	$14,-16777216			# 0xff000000
	ori	$15,$14,0x200
	mflo	$11
	addu	$10,$10,$11
	lw	$3,0($10)
	j	$L244
	ori	$14,$14,0xff00

$L247:
	lw	$10,4($3)
	nop
	bne	$10,$9,$L245
	nop

	lw	$10,0($3)
	nop
	and	$10,$10,$14
	bne	$10,$15,$L245
	nop

	lw	$10,20($3)
	nop
	bne	$10,$12,$L245
	nop

	lw	$10,8($3)
	nop
	bne	$10,$4,$L245
	nop

	lw	$10,24($3)
	nop
	bne	$10,$2,$L245
	nop

	lw	$10,28($3)
	nop
	bne	$10,$6,$L245
	nop

	lw	$10,32($3)
	nop
	bne	$10,$7,$L245
	nop

	lw	$10,36($3)
	nop
	bne	$10,$8,$L245
	nop

	lw	$2,40($3)
	subu	$13,$13,$5
	subu	$13,$13,$2
	bgez	$13,$L246
	nop

	lw	$4,56($3)
	addu	$5,$5,$2
$L249:
	jal	rtl_set_ct_timeout_expires
	nop

	j	$L242
	li	$2,-1			# 0xffffffff

$L245:
	lw	$3,64($3)
	nop
$L244:
	bne	$3,$0,$L247
	nop

$L246:
	move	$2,$0
$L242:
	lw	$31,20($sp)
	nop
	j	$31
	addiu	$sp,$sp,24

	.set	macro
	.set	reorder
	.end	rtk_idleNaptConnection
	.size	rtk_idleNaptConnection, .-rtk_idleNaptConnection
	.section	.text.rtl_fpTimer_update,"ax",@progbits
	.align	2
	.globl	rtl_fpTimer_update
	.set	nomips16
	.ent	rtl_fpTimer_update
	.type	rtl_fpTimer_update, @function
rtl_fpTimer_update:
	.frame	$sp,72,$31		# vars= 32, regs= 6/0, args= 16, gp= 0
	.mask	0x801f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-72
	sw	$31,68($sp)
	sw	$20,64($sp)
	sw	$19,60($sp)
	sw	$18,56($sp)
	sw	$17,52($sp)
	sw	$16,48($sp)
	lui	$2,%hi(jiffies)
	move	$5,$0
	lw	$19,%lo(jiffies)($2)
	jal	rtl_get_ct_protonum
	move	$16,$4

	li	$3,17			# 0x11
	bne	$2,$3,$L251
	move	$4,$16

	jal	rtl_get_ct_udp_status
	move	$4,$16

	andi	$2,$2,0x2
	beq	$2,$0,$L252
	lui	$2,%hi(nf_ct_udp_timeout)

	lui	$2,%hi(nf_ct_udp_timeout_stream)
	lw	$17,%lo(nf_ct_udp_timeout_stream)($2)
	j	$L253
	li	$18,1			# 0x1

$L252:
	lw	$17,%lo(nf_ct_udp_timeout)($2)
	j	$L253
	li	$18,1			# 0x1

$L251:
	jal	rtl_get_ct_protonum
	move	$5,$0

	li	$3,6			# 0x6
	bne	$2,$3,$L257
	li	$2,-1			# 0xffffffff

	jal	rtl_get_ct_tcp_state
	move	$4,$16

	sltu	$2,$2,6
	beq	$2,$0,$L257
	li	$2,-1			# 0xffffffff

	jal	rtl_tcp_get_timeouts
	move	$4,$16

	move	$17,$2
	li	$18,2			# 0x2
$L253:
	move	$5,$0
	move	$6,$0
	jal	rtl_get_ct_ip_by_dir
	move	$4,$16

	move	$4,$16
	li	$5,1			# 0x1
	li	$6,1			# 0x1
	jal	rtl_get_ct_ip_by_dir
	move	$20,$2

	bne	$20,$2,$L255
	li	$6,1			# 0x1

	move	$4,$16
	li	$5,1			# 0x1
	move	$6,$0
	jal	rtl_get_ct_ip_by_dir
	sw	$18,16($sp)

	move	$4,$16
	li	$5,1			# 0x1
	move	$6,$0
	jal	rtl_get_ct_port_by_dir
	sw	$2,20($sp)

	move	$4,$16
	move	$5,$0
	li	$6,1			# 0x1
	jal	rtl_get_ct_ip_by_dir
	sw	$2,24($sp)

	move	$4,$16
	move	$5,$0
	li	$6,1			# 0x1
	jal	rtl_get_ct_port_by_dir
	sw	$2,28($sp)

	move	$4,$16
	move	$5,$0
	move	$6,$0
	jal	rtl_get_ct_ip_by_dir
	sw	$2,32($sp)

	move	$4,$16
	j	$L260
	move	$5,$0

$L255:
	move	$5,$0
	jal	rtl_get_ct_ip_by_dir
	move	$4,$16

	move	$4,$16
	li	$5,1			# 0x1
	move	$6,$0
	jal	rtl_get_ct_ip_by_dir
	move	$20,$2

	bne	$20,$2,$L257
	li	$2,-1			# 0xffffffff

	move	$4,$16
	move	$5,$0
	move	$6,$0
	jal	rtl_get_ct_ip_by_dir
	sw	$18,16($sp)

	move	$4,$16
	move	$5,$0
	move	$6,$0
	jal	rtl_get_ct_port_by_dir
	sw	$2,20($sp)

	move	$4,$16
	li	$5,1			# 0x1
	li	$6,1			# 0x1
	jal	rtl_get_ct_ip_by_dir
	sw	$2,24($sp)

	move	$4,$16
	li	$5,1			# 0x1
	li	$6,1			# 0x1
	jal	rtl_get_ct_port_by_dir
	sw	$2,28($sp)

	move	$4,$16
	li	$5,1			# 0x1
	move	$6,$0
	jal	rtl_get_ct_ip_by_dir
	sw	$2,32($sp)

	move	$4,$16
	li	$5,1			# 0x1
$L260:
	move	$6,$0
	jal	rtl_get_ct_port_by_dir
	sw	$2,36($sp)

	addiu	$4,$sp,16
	move	$5,$17
	jal	rtk_idleNaptConnection
	sw	$2,40($sp)

	beq	$2,$0,$L254
	addu	$5,$17,$19

	jal	rtl_check_for_acc
	move	$4,$16

	j	$L257
	move	$2,$0

$L254:
	li	$2,-1			# 0xffffffff
$L257:
	lw	$31,68($sp)
	lw	$20,64($sp)
	lw	$19,60($sp)
	lw	$18,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,72

	.set	macro
	.set	reorder
	.end	rtl_fpTimer_update
	.size	rtl_fpTimer_update, .-rtl_fpTimer_update
	.section	.text.rtk_delNaptConnection,"ax",@progbits
	.align	2
	.globl	rtk_delNaptConnection
	.set	nomips16
	.ent	rtk_delNaptConnection
	.type	rtk_delNaptConnection, @function
rtk_delNaptConnection:
	.frame	$sp,32,$31		# vars= 0, regs= 4/0, args= 16, gp= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$18,24($sp)
	sw	$17,20($sp)
	sw	$16,16($sp)
	lw	$3,0($4)
	li	$2,6			# 0x6
	li	$18,17			# 0x11
	xori	$3,$3,0x2
	move	$16,$4
	movz	$18,$2,$3
#APP
 # 1334 "net/rtl/fastpath/fastpath_core.c" 1
	raw_local_irq_save	$17
 # 0 "" 2
#NO_APP
	lw	$4,20($4)
	jal	filter_delconnect
	lw	$3,4($16)
	lw	$6,8($16)
	lw	$2,20($16)
	lw	$5,24($16)
	xor	$7,$6,$3
	xor	$7,$7,$2
	srl	$8,$3,16
	lw	$4,0($16)
	xor	$7,$7,$5
	xor	$7,$7,$8
	srl	$8,$2,16
	xor	$7,$7,$8
	lui	$8,%hi(napt_table_list_max)
	lw	$9,%lo(napt_table_list_max)($8)
	andi	$8,$4,0xffff
	xor	$7,$7,$8
	srl	$8,$7,12
	xor	$7,$8,$7
	addiu	$9,$9,-1
	and	$8,$7,$9
	li	$9,12			# 0xc
	mult	$8,$9
	lui	$7,%hi(table_napt)
	lw	$7,%lo(table_napt)($7)
	#nop
	lw	$7,0($7)
	mflo	$8
	addu	$7,$7,$8
	lw	$7,0($7)
	j	$L264
$L288:
	lw	$9,4($7)
	#nop
	bne	$9,$4,$L265
	lw	$9,8($7)
	#nop
	bne	$9,$3,$L265
	lw	$9,12($7)
	#nop
	bne	$9,$6,$L265
	lw	$10,16($7)
	lw	$9,12($16)
	#nop
	bne	$10,$9,$L265
	lw	$10,20($7)
	lw	$9,16($16)
	#nop
	bne	$10,$9,$L265
	lw	$9,24($7)
	#nop
	bne	$9,$2,$L265
	lw	$9,28($7)
	#nop
	bne	$9,$5,$L265
	lw	$3,36($7)
	sb	$0,0($7)
	lw	$2,40($7)
	beq	$3,$0,$L266
	.set	noreorder
	.set	nomacro
	j	$L267
	sw	$2,40($3)
	.set	macro
	.set	reorder

$L266:
	lui	$3,%hi(table_napt)
	lw	$3,%lo(table_napt)($3)
	#nop
	lw	$3,0($3)
	#nop
	addu	$3,$3,$8
	sw	$2,4($3)
$L267:
	lw	$2,40($7)
	lw	$3,36($7)
	#nop
	sw	$3,0($2)
	lui	$2,%hi(table_napt)
	lw	$2,%lo(table_napt)($2)
	#nop
	lw	$2,0($2)
	#nop
	addu	$8,$2,$8
	lw	$2,8($8)
	#nop
	addiu	$2,$2,-1
	sw	$2,8($8)
	lw	$3,44($7)
	lw	$2,48($7)
	beq	$3,$0,$L268
	.set	noreorder
	.set	nomacro
	j	$L269
	sw	$2,48($3)
	.set	macro
	.set	reorder

$L268:
	lui	$3,%hi(napt_list_inuse+4)
	sw	$2,%lo(napt_list_inuse+4)($3)
$L269:
	lw	$2,48($7)
	lw	$4,44($7)
	lui	$3,%hi(napt_list_inuse)
	addiu	$3,$3,%lo(napt_list_inuse)
	sw	$4,0($2)
	lw	$4,8($3)
	lui	$2,%hi(napt_list_free)
	addiu	$2,$2,%lo(napt_list_free)
	addiu	$4,$4,-1
	sw	$4,8($3)
	sw	$0,44($7)
	lw	$3,4($2)
	addiu	$4,$7,44
	sw	$3,48($7)
	lw	$3,4($2)
	#nop
	sw	$7,0($3)
	lw	$3,8($2)
	sw	$4,4($2)
	lui	$4,%hi(path_table_list_max)
	addiu	$3,$3,1
	sw	$3,8($2)
	lw	$3,4($16)
	lw	$2,20($16)
	lw	$5,24($16)
	lw	$8,%lo(path_table_list_max)($4)
	xor	$6,$2,$3
	lw	$4,8($16)
	srl	$7,$3,8
	xor	$6,$6,$5
	xor	$6,$6,$7
	srl	$7,$2,16
	xor	$6,$6,$7
	srl	$7,$4,4
	xor	$6,$6,$7
	xor	$6,$6,$18
	srl	$7,$6,12
	xor	$6,$7,$6
	addiu	$8,$8,-1
	and	$7,$6,$8
	li	$8,12			# 0xc
	mult	$7,$8
	lui	$6,%hi(table_path)
	lw	$6,%lo(table_path)($6)
	#nop
	lw	$6,0($6)
	mflo	$7
	addu	$6,$6,$7
	lw	$6,0($6)
	.set	noreorder
	.set	nomacro
	j	$L270
	li	$8,1			# 0x1
	.set	macro
	.set	reorder

$L277:
	lw	$10,4($6)
	lw	$9,0($16)
	#nop
	bne	$10,$9,$L271
	lbu	$9,2($6)
	#nop
	bne	$9,$8,$L271
	lw	$9,16($6)
	#nop
	bne	$9,$3,$L271
	lw	$9,12($6)
	#nop
	bne	$9,$4,$L271
	lw	$10,24($6)
	lw	$9,12($16)
	#nop
	bne	$10,$9,$L271
	lw	$10,28($6)
	lw	$9,16($16)
	#nop
	bne	$10,$9,$L271
	lw	$9,20($6)
	#nop
	bne	$9,$2,$L271
	lw	$9,8($6)
	#nop
	bne	$9,$5,$L271
	lw	$3,64($6)
	sb	$0,0($6)
	lw	$2,68($6)
	beq	$3,$0,$L272
	.set	noreorder
	.set	nomacro
	j	$L273
	sw	$2,68($3)
	.set	macro
	.set	reorder

$L272:
	lui	$3,%hi(table_path)
	lw	$3,%lo(table_path)($3)
	#nop
	lw	$3,0($3)
	#nop
	addu	$3,$3,$7
	sw	$2,4($3)
$L273:
	lw	$2,68($6)
	lw	$3,64($6)
	#nop
	sw	$3,0($2)
	lui	$2,%hi(table_path)
	lw	$2,%lo(table_path)($2)
	#nop
	lw	$2,0($2)
	#nop
	addu	$7,$2,$7
	lw	$2,8($7)
	#nop
	addiu	$2,$2,-1
	sw	$2,8($7)
	lw	$3,72($6)
	lw	$2,76($6)
	beq	$3,$0,$L274
	.set	noreorder
	.set	nomacro
	j	$L275
	sw	$2,76($3)
	.set	macro
	.set	reorder

$L274:
	lui	$3,%hi(path_list_inuse+4)
	sw	$2,%lo(path_list_inuse+4)($3)
$L275:
	lw	$2,76($6)
	lw	$4,72($6)
	lui	$3,%hi(path_list_inuse)
	addiu	$3,$3,%lo(path_list_inuse)
	sw	$4,0($2)
	lw	$4,8($3)
	lui	$2,%hi(path_list_free)
	addiu	$2,$2,%lo(path_list_free)
	addiu	$4,$4,-1
	sw	$4,8($3)
	sw	$0,72($6)
	lw	$3,4($2)
	addiu	$4,$6,72
	sw	$3,76($6)
	lw	$3,4($2)
	#nop
	sw	$6,0($3)
	lw	$3,8($2)
	sw	$4,4($2)
	addiu	$3,$3,1
	.set	noreorder
	.set	nomacro
	j	$L276
	sw	$3,8($2)
	.set	macro
	.set	reorder

$L271:
	lw	$6,64($6)
	#nop
$L270:
	bne	$6,$0,$L277
$L276:
	lw	$3,20($16)
	lw	$2,12($16)
	lw	$5,16($16)
	lw	$4,24($16)
	xor	$7,$2,$3
	srl	$6,$3,8
	xor	$7,$7,$5
	xor	$7,$7,$6
	srl	$6,$2,16
	xor	$7,$7,$6
	srl	$6,$4,4
	xor	$7,$7,$6
	lui	$6,%hi(path_table_list_max)
	lw	$6,%lo(path_table_list_max)($6)
	xor	$18,$7,$18
	srl	$7,$18,12
	xor	$18,$7,$18
	addiu	$6,$6,-1
	and	$18,$18,$6
	li	$6,12			# 0xc
	mult	$18,$6
	lui	$6,%hi(table_path)
	lw	$6,%lo(table_path)($6)
	#nop
	lw	$6,0($6)
	mflo	$18
	addu	$6,$6,$18
	lw	$6,0($6)
	.set	noreorder
	.set	nomacro
	j	$L278
	li	$7,2			# 0x2
	.set	macro
	.set	reorder

$L285:
	lw	$9,4($6)
	lw	$8,0($16)
	#nop
	bne	$9,$8,$L279
	lbu	$8,2($6)
	#nop
	bne	$8,$7,$L279
	lw	$8,20($6)
	#nop
	bne	$8,$2,$L279
	lw	$8,8($6)
	#nop
	bne	$8,$5,$L279
	lw	$8,24($6)
	#nop
	bne	$8,$3,$L279
	lw	$8,28($6)
	#nop
	bne	$8,$4,$L279
	lw	$9,32($6)
	lw	$8,4($16)
	#nop
	bne	$9,$8,$L279
	lw	$9,36($6)
	lw	$8,8($16)
	#nop
	bne	$9,$8,$L279
	lw	$3,64($6)
	sb	$0,0($6)
	lw	$2,68($6)
	beq	$3,$0,$L280
	.set	noreorder
	.set	nomacro
	j	$L281
	sw	$2,68($3)
	.set	macro
	.set	reorder

$L280:
	lui	$3,%hi(table_path)
	lw	$3,%lo(table_path)($3)
	#nop
	lw	$3,0($3)
	#nop
	addu	$3,$3,$18
	sw	$2,4($3)
$L281:
	lw	$2,68($6)
	lw	$3,64($6)
	#nop
	sw	$3,0($2)
	lui	$2,%hi(table_path)
	lw	$2,%lo(table_path)($2)
	#nop
	lw	$2,0($2)
	#nop
	addu	$18,$2,$18
	lw	$2,8($18)
	#nop
	addiu	$2,$2,-1
	sw	$2,8($18)
	lw	$3,72($6)
	lw	$2,76($6)
	beq	$3,$0,$L282
	.set	noreorder
	.set	nomacro
	j	$L283
	sw	$2,76($3)
	.set	macro
	.set	reorder

$L282:
	lui	$3,%hi(path_list_inuse+4)
	sw	$2,%lo(path_list_inuse+4)($3)
$L283:
	lw	$2,76($6)
	lw	$4,72($6)
	lui	$3,%hi(path_list_inuse)
	addiu	$3,$3,%lo(path_list_inuse)
	sw	$4,0($2)
	lw	$4,8($3)
	lui	$2,%hi(path_list_free)
	addiu	$2,$2,%lo(path_list_free)
	addiu	$4,$4,-1
	sw	$4,8($3)
	sw	$0,72($6)
	lw	$3,4($2)
	addiu	$4,$6,72
	sw	$3,76($6)
	lw	$3,4($2)
	#nop
	sw	$6,0($3)
	lw	$3,8($2)
	sw	$4,4($2)
	addiu	$3,$3,1
	.set	noreorder
	.set	nomacro
	j	$L284
	sw	$3,8($2)
	.set	macro
	.set	reorder

$L279:
	lw	$6,64($6)
	#nop
$L278:
	bne	$6,$0,$L285
$L284:
	andi	$2,$17,0x1
	bne	$2,$0,$L286
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$17
 # 0 "" 2
#NO_APP
	j	$L287
$L286:
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$17
 # 0 "" 2
#NO_APP
	.set	noreorder
	.set	nomacro
	j	$L287
	move	$2,$0
	.set	macro
	.set	reorder

$L265:
	lw	$7,36($7)
	#nop
$L264:
	bne	$7,$0,$L288
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$17
 # 0 "" 2
#NO_APP
	li	$2,-4			# 0xfffffffc
$L287:
	lw	$31,28($sp)
	lw	$18,24($sp)
	lw	$17,20($sp)
	lw	$16,16($sp)
	.set	noreorder
	.set	nomacro
	j	$31
	addiu	$sp,$sp,32
	.set	macro
	.set	reorder

	.end	rtk_delNaptConnection
	.size	rtk_delNaptConnection, .-rtk_delNaptConnection
	.section	.text.rtk_addNaptConnection,"ax",@progbits
	.align	2
	.globl	rtk_addNaptConnection
	.set	nomips16
	.ent	rtk_addNaptConnection
	.type	rtk_addNaptConnection, @function
rtk_addNaptConnection:
	.frame	$sp,144,$31		# vars= 88, regs= 10/0, args= 16, gp= 0
	.mask	0xc0ff0000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-144
	sw	$31,140($sp)
	sw	$fp,136($sp)
	sw	$23,132($sp)
	sw	$22,128($sp)
	sw	$21,124($sp)
	sw	$20,120($sp)
	sw	$19,116($sp)
	sw	$18,112($sp)
	sw	$17,108($sp)
	sw	$16,104($sp)
	move	$17,$5
	move	$16,$4
	sw	$6,152($sp)
	.set	noreorder
	.set	nomacro
	beq	$5,$0,$L292
	move	$18,$7
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$5
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	beq	$2,$0,$L292
	li	$2,6			# 0x6
	.set	macro
	.set	reorder

	lw	$3,0($16)
	lw	$4,20($16)
	xori	$3,$3,0x2
	li	$fp,17			# 0x11
	.set	noreorder
	.set	nomacro
	jal	filter_addconnect
	movz	$fp,$2,$3
	.set	macro
	.set	reorder

#APP
 # 908 "net/rtl/fastpath/fastpath_core.c" 1
	raw_local_irq_save	$23
 # 0 "" 2
#NO_APP
	lw	$4,4($16)
	lw	$6,8($16)
	lw	$3,20($16)
	lw	$5,24($16)
	xor	$7,$6,$4
	xor	$7,$7,$3
	srl	$8,$4,16
	lw	$2,0($16)
	xor	$7,$7,$5
	xor	$7,$7,$8
	srl	$8,$3,16
	xor	$7,$7,$8
	lui	$8,%hi(napt_table_list_max)
	lw	$9,%lo(napt_table_list_max)($8)
	andi	$8,$2,0xffff
	xor	$7,$7,$8
	srl	$8,$7,12
	xor	$7,$8,$7
	addiu	$9,$9,-1
	and	$8,$7,$9
	li	$9,12			# 0xc
	mult	$8,$9
	lui	$7,%hi(table_napt)
	lw	$7,%lo(table_napt)($7)
	#nop
	lw	$7,0($7)
	mflo	$8
	addu	$7,$7,$8
	lw	$7,0($7)
	j	$L295
$L299:
	lw	$9,4($7)
	#nop
	bne	$9,$2,$L296
	lw	$9,8($7)
	#nop
	bne	$9,$4,$L296
	lw	$9,12($7)
	#nop
	bne	$9,$6,$L296
	lw	$10,16($7)
	lw	$9,12($16)
	#nop
	bne	$10,$9,$L296
	lw	$10,20($7)
	lw	$9,16($16)
	#nop
	bne	$10,$9,$L296
	lw	$9,24($7)
	#nop
	bne	$9,$3,$L296
	lw	$9,28($7)
	#nop
	bne	$9,$5,$L296
	lw	$4,152($sp)
	move	$5,$fp
	.set	noreorder
	.set	nomacro
	jal	rtl_conntrack_drop_check_hook
	move	$6,$4
	.set	macro
	.set	reorder

	andi	$2,$23,0x1
	bne	$2,$0,$L297
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$23
 # 0 "" 2
#NO_APP
	j	$L298
$L297:
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$23
 # 0 "" 2
#NO_APP
	.set	noreorder
	.set	nomacro
	j	$L298
	move	$2,$0
	.set	macro
	.set	reorder

$L296:
	lw	$7,36($7)
	#nop
$L295:
	bne	$7,$0,$L299
	lui	$4,%hi(napt_list_free)
	lw	$3,%lo(napt_list_free)($4)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L300
	li	$7,-1			# 0xffffffff
	.set	macro
	.set	reorder

	sw	$2,4($3)
	lw	$2,4($16)
	lw	$5,44($3)
	sw	$2,8($3)
	lw	$6,8($16)
	lw	$2,48($3)
	sw	$6,12($3)
	lw	$6,12($16)
	#nop
	sw	$6,16($3)
	lw	$6,16($16)
	#nop
	sw	$6,20($3)
	lw	$6,20($16)
	#nop
	sw	$6,24($3)
	lw	$6,24($16)
	sw	$18,32($3)
	sb	$7,0($3)
	.set	noreorder
	.set	nomacro
	beq	$5,$0,$L301
	sw	$6,28($3)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L302
	sw	$2,48($5)
	.set	macro
	.set	reorder

$L301:
	addiu	$4,$4,%lo(napt_list_free)
	sw	$2,4($4)
$L302:
	lw	$2,48($3)
	lw	$5,44($3)
	lui	$4,%hi(napt_list_free)
	addiu	$4,$4,%lo(napt_list_free)
	sw	$5,0($2)
	lw	$5,8($4)
	lui	$2,%hi(napt_list_inuse)
	addiu	$2,$2,%lo(napt_list_inuse)
	addiu	$5,$5,-1
	sw	$5,8($4)
	sw	$0,44($3)
	lw	$5,4($2)
	addiu	$7,$3,44
	lui	$4,%hi(table_napt)
	sw	$5,48($3)
	lw	$6,4($2)
	addiu	$5,$3,36
	sw	$3,0($6)
	lw	$6,8($2)
	sw	$7,4($2)
	addiu	$6,$6,1
	sw	$6,8($2)
	sw	$0,36($3)
	lw	$2,%lo(table_napt)($4)
	#nop
	lw	$2,0($2)
	#nop
	addu	$2,$2,$8
	lw	$2,4($2)
	#nop
	sw	$2,40($3)
	lw	$2,%lo(table_napt)($4)
	#nop
	lw	$2,0($2)
	#nop
	addu	$2,$2,$8
	lw	$2,4($2)
	#nop
	sw	$3,0($2)
	lw	$2,%lo(table_napt)($4)
	#nop
	lw	$2,0($2)
	#nop
	addu	$2,$2,$8
	sw	$5,4($2)
	lw	$2,%lo(table_napt)($4)
	#nop
	lw	$2,0($2)
	#nop
	addu	$8,$2,$8
	lw	$2,8($8)
	#nop
	addiu	$2,$2,1
	sw	$2,8($8)
	li	$2,33			# 0x21
	sb	$2,17($sp)
	.set	noreorder
	.set	nomacro
	jal	rtl865x_getLanDev
	sb	$0,16($sp)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl865x_getWanDev
	move	$20,$2
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_protocol
	move	$19,$2
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_ip_hdr
	sw	$2,64($sp)
	.set	macro
	.set	reorder

	lbu	$22,0($2)
	move	$4,$17
	move	$21,$2
	andi	$22,$22,0xf
	sll	$22,$22,2
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	addu	$22,$2,$22
	.set	macro
	.set	reorder

	addiu	$5,$2,6
	li	$6,6			# 0x6
	.set	noreorder
	.set	nomacro
	jal	memcpy
	addiu	$4,$sp,20
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	move	$5,$2
	li	$6,6			# 0x6
	.set	noreorder
	.set	nomacro
	jal	memcpy
	addiu	$4,$sp,28
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	sw	$2,80($sp)
	lw	$2,12($21)
	move	$4,$17
	sw	$2,96($sp)
	lhu	$3,0($22)
	#nop
	sw	$3,88($sp)
	lw	$5,16($21)
	#nop
	sw	$5,92($sp)
	lhu	$6,2($22)
	.set	noreorder
	.set	nomacro
	jal	rtl_store_skb_dst
	sw	$6,84($sp)
	.set	macro
	.set	reorder

	lui	$2,%hi(path_list_free)
	lw	$18,%lo(path_list_free)($2)
	lui	$2,%hi(path_table_list_max)
	lw	$2,%lo(path_table_list_max)($2)
	#nop
	sw	$2,76($sp)
	lw	$2,4($16)
	#nop
	sw	$2,60($sp)
	lw	$3,8($16)
	#nop
	sw	$3,72($sp)
	lw	$5,20($16)
	#nop
	sw	$5,56($sp)
	lw	$6,24($16)
	.set	noreorder
	.set	nomacro
	beq	$18,$0,$L303
	sw	$6,68($sp)
	.set	macro
	.set	reorder

	lw	$2,0($16)
	move	$4,$0
	sw	$2,4($18)
	lw	$6,4($16)
	#nop
	sw	$6,16($18)
	lw	$2,8($16)
	#nop
	sw	$2,12($18)
	lw	$2,20($16)
	#nop
	sw	$2,20($18)
	lw	$2,24($16)
	#nop
	sw	$2,8($18)
	lw	$5,12($16)
	#nop
	sw	$5,24($18)
	lw	$2,16($16)
	#nop
	sw	$2,28($18)
	lw	$8,20($16)
	#nop
	sw	$8,32($18)
	lw	$2,24($16)
	#nop
	sw	$2,36($18)
	lui	$2,%hi(route_list_inuse)
	lw	$2,%lo(route_list_inuse)($2)
	.set	noreorder
	.set	nomacro
	j	$L304
	move	$7,$0
	.set	macro
	.set	reorder

$L307:
	lw	$3,8($2)
	#nop
	sltu	$9,$3,$4
	.set	noreorder
	.set	nomacro
	bne	$9,$0,$L305
	and	$10,$3,$8
	.set	macro
	.set	reorder

	lw	$9,4($2)
	#nop
	bne	$10,$9,$L305
	.set	noreorder
	.set	nomacro
	j	$L306
	addiu	$7,$2,16
	.set	macro
	.set	reorder

$L305:
	move	$3,$4
$L306:
	lw	$2,44($2)
	move	$4,$3
$L304:
	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L307
	li	$3,-1			# 0xffffffff
	.set	macro
	.set	reorder

	li	$2,1			# 0x1
	sw	$7,44($18)
	sb	$3,0($18)
	sb	$2,2($18)
	.set	noreorder
	.set	nomacro
	beq	$6,$5,$L308
	sb	$0,1($18)
	.set	macro
	.set	reorder

	sb	$2,1($18)
$L308:
	lw	$3,12($18)
	lw	$2,28($18)
	#nop
	beq	$3,$2,$L309
	lbu	$2,1($18)
	#nop
	ori	$2,$2,0x2
	sb	$2,1($18)
$L309:
	sw	$0,48($18)
	sw	$0,52($18)
	lw	$2,4($16)
	addiu	$3,$sp,36
	move	$4,$3
	sw	$2,12($21)
	lw	$2,8($16)
	move	$5,$0
	li	$6,14			# 0xe
	sh	$2,0($22)
	lw	$2,20($16)
	#nop
	sw	$2,16($21)
	lw	$2,24($16)
	#nop
	sh	$2,2($22)
	.set	noreorder
	.set	nomacro
	jal	memset
	sw	$3,100($sp)
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_mark
	move	$5,$0
	.set	macro
	.set	reorder

	lw	$3,100($sp)
	.set	noreorder
	.set	nomacro
	beq	$20,$0,$L310
	move	$6,$3
	.set	macro
	.set	reorder

	lw	$4,4($16)
	.set	noreorder
	.set	nomacro
	jal	rtl_arp_req_get_ha
	move	$5,$20
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L310
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_ppp_proto_check
	addiu	$5,$sp,16
	.set	macro
	.set	reorder

	move	$3,$2
	li	$2,1			# 0x1
	.set	noreorder
	.set	nomacro
	bne	$3,$2,$L311
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_skb_mac_header_was_set
	sw	$3,100($sp)
	.set	macro
	.set	reorder

	lw	$3,100($sp)
	#nop
	bne	$2,$3,$L311
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	lbu	$3,12($2)
	lbu	$2,13($2)
	sll	$3,$3,8
	or	$3,$2,$3
	li	$2,2048			# 0x800
	.set	noreorder
	.set	nomacro
	beq	$3,$2,$L311
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_skb_set_mac_header
	li	$5,-22			# 0xffffffea
	.set	macro
	.set	reorder

$L311:
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	addiu	$4,$2,6
	li	$6,6			# 0x6
	.set	noreorder
	.set	nomacro
	jal	memcpy
	addiu	$5,$sp,36
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_dmac
	move	$5,$20
	.set	macro
	.set	reorder

	lw	$3,64($sp)
	li	$2,2048			# 0x800
	.set	noreorder
	.set	nomacro
	bne	$3,$2,$L310
	lui	$2,%hi(nf_hooks+128)
	.set	macro
	.set	reorder

	lw	$3,%lo(nf_hooks+128)($2)
	addiu	$2,$2,%lo(nf_hooks+128)
	.set	noreorder
	.set	nomacro
	beq	$3,$2,$L312
	move	$4,$17
	.set	macro
	.set	reorder

	move	$5,$0
	move	$6,$20
	.set	noreorder
	.set	nomacro
	jal	rtl_ipt_do_table
	move	$7,$19
	.set	macro
	.set	reorder

$L312:
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	beq	$2,$0,$L313
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L354
	sw	$2,48($18)
	.set	macro
	.set	reorder

$L313:
	lw	$2,48($18)
	#nop
	sw	$2,48($18)
$L354:
	lui	$2,%hi(nf_hooks+160)
	lw	$3,%lo(nf_hooks+160)($2)
	addiu	$2,$2,%lo(nf_hooks+160)
	.set	noreorder
	.set	nomacro
	beq	$3,$2,$L315
	move	$4,$17
	.set	macro
	.set	reorder

	li	$5,4			# 0x4
	move	$6,$20
	.set	noreorder
	.set	nomacro
	jal	rtl_ipt_do_table
	move	$7,$19
	.set	macro
	.set	reorder

$L315:
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	beq	$2,$0,$L316
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L310
	sw	$2,52($18)
	.set	macro
	.set	reorder

$L316:
	lw	$2,52($18)
	#nop
	sw	$2,52($18)
$L310:
	lw	$2,12($16)
	addiu	$3,$sp,36
	move	$4,$3
	sw	$2,12($21)
	lw	$2,16($16)
	move	$5,$0
	li	$6,14			# 0xe
	sh	$2,0($22)
	lw	$2,20($16)
	#nop
	sw	$2,16($21)
	lw	$2,24($16)
	#nop
	sh	$2,2($22)
	.set	noreorder
	.set	nomacro
	jal	memset
	sw	$3,100($sp)
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_mark
	move	$5,$0
	.set	macro
	.set	reorder

	lw	$3,100($sp)
	.set	noreorder
	.set	nomacro
	beq	$19,$0,$L318
	move	$6,$3
	.set	macro
	.set	reorder

	lw	$4,20($16)
	.set	noreorder
	.set	nomacro
	jal	rtl_arp_req_get_ha
	move	$5,$19
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L357
	li	$2,6			# 0x6
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_ppp_proto_check
	addiu	$5,$sp,16
	.set	macro
	.set	reorder

	move	$3,$2
	li	$2,1			# 0x1
	bne	$3,$2,$L319
	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_skb_mac_header_was_set
	sw	$3,100($sp)
	.set	macro
	.set	reorder

	lw	$3,100($sp)
	#nop
	bne	$2,$3,$L319
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	lbu	$3,12($2)
	lbu	$2,13($2)
	sll	$3,$3,8
	or	$3,$2,$3
	li	$2,2048			# 0x800
	beq	$3,$2,$L319
	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_skb_set_mac_header
	li	$5,-22			# 0xffffffea
	.set	macro
	.set	reorder

$L319:
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	move	$4,$2
	li	$6,6			# 0x6
	.set	noreorder
	.set	nomacro
	jal	memcpy
	addiu	$5,$sp,36
	.set	macro
	.set	reorder

	move	$5,$19
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_smac
	move	$4,$17
	.set	macro
	.set	reorder

	lw	$5,64($sp)
	li	$2,2048			# 0x800
	.set	noreorder
	.set	nomacro
	bne	$5,$2,$L357
	li	$2,6			# 0x6
	.set	macro
	.set	reorder

	lui	$2,%hi(nf_hooks+160)
	lw	$3,%lo(nf_hooks+160)($2)
	addiu	$2,$2,%lo(nf_hooks+160)
	.set	noreorder
	.set	nomacro
	beq	$3,$2,$L320
	move	$4,$17
	.set	macro
	.set	reorder

	li	$5,4			# 0x4
	move	$6,$20
	.set	noreorder
	.set	nomacro
	jal	rtl_ipt_do_table
	move	$7,$19
	.set	macro
	.set	reorder

$L320:
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	beq	$2,$0,$L321
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L318
	sw	$2,52($18)
	.set	macro
	.set	reorder

$L321:
	lw	$2,52($18)
	#nop
	sw	$2,52($18)
$L318:
	li	$2,6			# 0x6
$L357:
	.set	noreorder
	.set	nomacro
	bne	$fp,$2,$L323
	lui	$2,%hi(nf_ct_udp_timeout_stream)
	.set	macro
	.set	reorder

	lw	$4,152($sp)
	jal	rtl_tcp_get_timeouts
	.set	noreorder
	.set	nomacro
	j	$L355
	sw	$2,60($18)
	.set	macro
	.set	reorder

$L323:
	lw	$2,%lo(nf_ct_udp_timeout_stream)($2)
	#nop
	sw	$2,60($18)
$L355:
	lw	$6,152($sp)
	lui	$2,%hi(jiffies)
	lw	$3,72($18)
	sw	$6,56($18)
	lw	$4,%lo(jiffies)($2)
	lw	$2,76($18)
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L325
	sw	$4,40($18)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L326
	sw	$2,76($3)
	.set	macro
	.set	reorder

$L325:
	lui	$3,%hi(path_list_free+4)
	sw	$2,%lo(path_list_free+4)($3)
$L326:
	lw	$2,76($18)
	lw	$3,72($18)
	lw	$6,60($sp)
	lw	$5,56($sp)
	sw	$3,0($2)
	lw	$2,68($sp)
	xor	$4,$5,$6
	srl	$3,$6,8
	xor	$4,$4,$2
	xor	$4,$4,$3
	lw	$3,56($sp)
	lw	$6,72($sp)
	lui	$2,%hi(path_list_free)
	addiu	$2,$2,%lo(path_list_free)
	srl	$5,$3,16
	lw	$3,8($2)
	xor	$4,$4,$5
	srl	$5,$6,4
	xor	$4,$4,$5
	xor	$4,$4,$fp
	addiu	$3,$3,-1
	sw	$3,8($2)
	sw	$0,72($18)
	srl	$3,$4,12
	xor	$4,$3,$4
	lw	$3,76($sp)
	lui	$2,%hi(path_list_inuse)
	addiu	$2,$2,%lo(path_list_inuse)
	addiu	$5,$3,-1
	and	$4,$4,$5
	lw	$3,4($2)
	li	$5,12			# 0xc
	mult	$4,$5
	addiu	$5,$18,72
	sw	$3,76($18)
	lw	$6,4($2)
	lui	$3,%hi(table_path)
	sw	$18,0($6)
	lw	$6,8($2)
	sw	$5,4($2)
	addiu	$5,$18,64
	addiu	$6,$6,1
	sw	$6,8($2)
	sw	$0,64($18)
	lw	$2,%lo(table_path)($3)
	#nop
	lw	$2,0($2)
	mflo	$4
	addu	$2,$2,$4
	lw	$2,4($2)
	#nop
	sw	$2,68($18)
	lw	$2,%lo(table_path)($3)
	#nop
	lw	$2,0($2)
	#nop
	addu	$2,$2,$4
	lw	$2,4($2)
	#nop
	sw	$18,0($2)
	lw	$2,%lo(table_path)($3)
	#nop
	lw	$2,0($2)
	#nop
	addu	$2,$2,$4
	sw	$5,4($2)
	lw	$2,%lo(table_path)($3)
	#nop
	lw	$2,0($2)
	#nop
	addu	$4,$2,$4
	lw	$2,8($4)
	#nop
	addiu	$2,$2,1
	sw	$2,8($4)
$L303:
	lui	$2,%hi(path_list_free)
	lw	$18,%lo(path_list_free)($2)
	lui	$2,%hi(path_table_list_max)
	lw	$2,%lo(path_table_list_max)($2)
	#nop
	sw	$2,76($sp)
	lw	$2,20($16)
	#nop
	sw	$2,60($sp)
	lw	$3,24($16)
	#nop
	sw	$3,72($sp)
	lw	$5,12($16)
	#nop
	sw	$5,56($sp)
	lw	$6,16($16)
	.set	noreorder
	.set	nomacro
	beq	$18,$0,$L327
	sw	$6,68($sp)
	.set	macro
	.set	reorder

	lw	$2,0($16)
	move	$5,$0
	sw	$2,4($18)
	lw	$2,20($16)
	#nop
	sw	$2,16($18)
	lw	$2,24($16)
	#nop
	sw	$2,12($18)
	lw	$6,12($16)
	#nop
	sw	$6,20($18)
	lw	$2,16($16)
	#nop
	sw	$2,8($18)
	lw	$2,20($16)
	#nop
	sw	$2,24($18)
	lw	$2,24($16)
	#nop
	sw	$2,28($18)
	lw	$4,4($16)
	#nop
	sw	$4,32($18)
	lw	$2,8($16)
	#nop
	sw	$2,36($18)
	lui	$2,%hi(route_list_inuse)
	lw	$2,%lo(route_list_inuse)($2)
	.set	noreorder
	.set	nomacro
	j	$L328
	move	$7,$0
	.set	macro
	.set	reorder

$L331:
	lw	$3,8($2)
	#nop
	sltu	$8,$3,$5
	.set	noreorder
	.set	nomacro
	bne	$8,$0,$L329
	and	$9,$3,$4
	.set	macro
	.set	reorder

	lw	$8,4($2)
	#nop
	bne	$9,$8,$L329
	.set	noreorder
	.set	nomacro
	j	$L330
	addiu	$7,$2,16
	.set	macro
	.set	reorder

$L329:
	move	$3,$5
$L330:
	lw	$2,44($2)
	move	$5,$3
$L328:
	bne	$2,$0,$L331
	li	$2,2			# 0x2
	sb	$2,2($18)
	li	$2,-1			# 0xffffffff
	sw	$7,44($18)
	sb	$2,0($18)
	.set	noreorder
	.set	nomacro
	beq	$6,$4,$L332
	sb	$0,1($18)
	.set	macro
	.set	reorder

	li	$2,4			# 0x4
	sb	$2,1($18)
$L332:
	lw	$3,8($18)
	lw	$2,36($18)
	#nop
	beq	$3,$2,$L333
	lbu	$2,1($18)
	#nop
	ori	$2,$2,0x8
	sb	$2,1($18)
$L333:
	sw	$0,48($18)
	sw	$0,52($18)
	lw	$2,20($16)
	addiu	$3,$sp,36
	move	$4,$3
	sw	$2,12($21)
	lw	$2,24($16)
	move	$5,$0
	li	$6,14			# 0xe
	sh	$2,0($22)
	lw	$2,12($16)
	#nop
	sw	$2,16($21)
	lw	$2,16($16)
	#nop
	sh	$2,2($22)
	.set	noreorder
	.set	nomacro
	jal	memset
	sw	$3,100($sp)
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_mark
	move	$5,$0
	.set	macro
	.set	reorder

	lw	$3,100($sp)
	.set	noreorder
	.set	nomacro
	beq	$19,$0,$L334
	move	$6,$3
	.set	macro
	.set	reorder

	lw	$4,20($16)
	.set	noreorder
	.set	nomacro
	jal	rtl_arp_req_get_ha
	move	$5,$19
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L334
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_ppp_proto_check
	addiu	$5,$sp,16
	.set	macro
	.set	reorder

	move	$3,$2
	li	$2,1			# 0x1
	.set	noreorder
	.set	nomacro
	bne	$3,$2,$L335
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_skb_mac_header_was_set
	sw	$3,100($sp)
	.set	macro
	.set	reorder

	lw	$3,100($sp)
	#nop
	bne	$2,$3,$L335
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	lbu	$3,12($2)
	lbu	$2,13($2)
	sll	$3,$3,8
	or	$3,$2,$3
	li	$2,2048			# 0x800
	.set	noreorder
	.set	nomacro
	beq	$3,$2,$L335
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_skb_set_mac_header
	li	$5,-22			# 0xffffffea
	.set	macro
	.set	reorder

$L335:
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	addiu	$4,$2,6
	li	$6,6			# 0x6
	.set	noreorder
	.set	nomacro
	jal	memcpy
	addiu	$5,$sp,36
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_dmac
	move	$5,$19
	.set	macro
	.set	reorder

	lw	$3,64($sp)
	li	$2,2048			# 0x800
	.set	noreorder
	.set	nomacro
	bne	$3,$2,$L336
	lui	$2,%hi(nf_hooks+128)
	.set	macro
	.set	reorder

	lw	$3,%lo(nf_hooks+128)($2)
	addiu	$2,$2,%lo(nf_hooks+128)
	.set	noreorder
	.set	nomacro
	beq	$3,$2,$L336
	move	$4,$17
	.set	macro
	.set	reorder

	move	$5,$0
	move	$6,$19
	.set	noreorder
	.set	nomacro
	jal	rtl_ipt_do_table
	move	$7,$20
	.set	macro
	.set	reorder

$L336:
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	beq	$2,$0,$L337
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L334
	sw	$2,48($18)
	.set	macro
	.set	reorder

$L337:
	lw	$2,48($18)
	#nop
	sw	$2,48($18)
$L334:
	lw	$2,20($16)
	addiu	$3,$sp,36
	move	$4,$3
	sw	$2,12($21)
	lw	$2,24($16)
	move	$5,$0
	li	$6,14			# 0xe
	sh	$2,0($22)
	lw	$2,4($16)
	#nop
	sw	$2,16($21)
	lw	$2,8($16)
	#nop
	sh	$2,2($22)
	.set	noreorder
	.set	nomacro
	jal	memset
	sw	$3,100($sp)
	.set	macro
	.set	reorder

	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_mark
	move	$5,$0
	.set	macro
	.set	reorder

	lw	$3,100($sp)
	.set	noreorder
	.set	nomacro
	beq	$20,$0,$L339
	move	$6,$3
	.set	macro
	.set	reorder

	lw	$4,4($16)
	.set	noreorder
	.set	nomacro
	jal	rtl_arp_req_get_ha
	move	$5,$20
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$2,$0,$L339
	move	$4,$17
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_ppp_proto_check
	addiu	$5,$sp,16
	.set	macro
	.set	reorder

	move	$16,$2
	li	$2,1			# 0x1
	bne	$16,$2,$L340
	.set	noreorder
	.set	nomacro
	jal	rtl_skb_mac_header_was_set
	move	$4,$17
	.set	macro
	.set	reorder

	bne	$2,$16,$L340
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	lbu	$3,12($2)
	lbu	$2,13($2)
	sll	$3,$3,8
	or	$3,$2,$3
	li	$2,2048			# 0x800
	beq	$3,$2,$L340
	move	$4,$17
	.set	noreorder
	.set	nomacro
	jal	rtl_skb_set_mac_header
	li	$5,-22			# 0xffffffea
	.set	macro
	.set	reorder

$L340:
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	move	$4,$2
	li	$6,6			# 0x6
	.set	noreorder
	.set	nomacro
	jal	memcpy
	addiu	$5,$sp,36
	.set	macro
	.set	reorder

	move	$5,$20
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_smac
	move	$4,$17
	.set	macro
	.set	reorder

	lw	$5,64($sp)
	li	$2,2048			# 0x800
	.set	noreorder
	.set	nomacro
	bne	$5,$2,$L339
	lui	$2,%hi(nf_hooks+160)
	.set	macro
	.set	reorder

	lw	$3,%lo(nf_hooks+160)($2)
	addiu	$2,$2,%lo(nf_hooks+160)
	.set	noreorder
	.set	nomacro
	beq	$3,$2,$L339
	move	$4,$17
	.set	macro
	.set	reorder

	li	$5,4			# 0x4
	move	$6,$19
	.set	noreorder
	.set	nomacro
	jal	rtl_ipt_do_table
	move	$7,$20
	.set	macro
	.set	reorder

$L339:
	.set	noreorder
	.set	nomacro
	jal	rtl_get_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	sw	$2,52($18)
	li	$2,6			# 0x6
	.set	noreorder
	.set	nomacro
	bne	$fp,$2,$L341
	lui	$2,%hi(nf_ct_udp_timeout_stream)
	.set	macro
	.set	reorder

	lw	$4,152($sp)
	jal	rtl_tcp_get_timeouts
	.set	noreorder
	.set	nomacro
	j	$L356
	sw	$2,60($18)
	.set	macro
	.set	reorder

$L341:
	lw	$2,%lo(nf_ct_udp_timeout_stream)($2)
	#nop
	sw	$2,60($18)
$L356:
	lw	$6,152($sp)
	lui	$2,%hi(jiffies)
	lw	$3,72($18)
	sw	$6,56($18)
	lw	$4,%lo(jiffies)($2)
	lw	$2,76($18)
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L343
	sw	$4,40($18)
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L344
	sw	$2,76($3)
	.set	macro
	.set	reorder

$L343:
	lui	$3,%hi(path_list_free+4)
	sw	$2,%lo(path_list_free+4)($3)
$L344:
	lw	$2,76($18)
	lw	$3,72($18)
	lw	$6,60($sp)
	lw	$5,56($sp)
	sw	$3,0($2)
	lw	$2,68($sp)
	xor	$4,$5,$6
	srl	$3,$6,8
	xor	$4,$4,$2
	xor	$4,$4,$3
	lw	$3,56($sp)
	lw	$6,72($sp)
	lui	$2,%hi(path_list_free)
	addiu	$2,$2,%lo(path_list_free)
	srl	$5,$3,16
	lw	$3,8($2)
	xor	$4,$4,$5
	srl	$5,$6,4
	xor	$4,$4,$5
	xor	$4,$4,$fp
	addiu	$3,$3,-1
	sw	$3,8($2)
	sw	$0,72($18)
	srl	$3,$4,12
	xor	$4,$3,$4
	lw	$3,76($sp)
	lui	$2,%hi(path_list_inuse)
	addiu	$2,$2,%lo(path_list_inuse)
	addiu	$5,$3,-1
	and	$4,$4,$5
	lw	$3,4($2)
	li	$5,12			# 0xc
	mult	$4,$5
	addiu	$5,$18,72
	sw	$3,76($18)
	lw	$6,4($2)
	lui	$3,%hi(table_path)
	sw	$18,0($6)
	lw	$6,8($2)
	sw	$5,4($2)
	addiu	$5,$18,64
	addiu	$6,$6,1
	sw	$6,8($2)
	sw	$0,64($18)
	lw	$2,%lo(table_path)($3)
	#nop
	lw	$2,0($2)
	mflo	$4
	addu	$2,$2,$4
	lw	$2,4($2)
	#nop
	sw	$2,68($18)
	lw	$2,%lo(table_path)($3)
	#nop
	lw	$2,0($2)
	#nop
	addu	$2,$2,$4
	lw	$2,4($2)
	#nop
	sw	$18,0($2)
	lw	$2,%lo(table_path)($3)
	#nop
	lw	$2,0($2)
	#nop
	addu	$2,$2,$4
	sw	$5,4($2)
	lw	$2,%lo(table_path)($3)
	#nop
	lw	$2,0($2)
	#nop
	addu	$4,$2,$4
	lw	$2,8($4)
	#nop
	addiu	$2,$2,1
	sw	$2,8($4)
$L327:
	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	addiu	$4,$2,6
	addiu	$5,$sp,20
	.set	noreorder
	.set	nomacro
	jal	memcpy
	li	$6,6			# 0x6
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	jal	rtl_eth_hdr
	move	$4,$17
	.set	macro
	.set	reorder

	move	$4,$2
	li	$6,6			# 0x6
	.set	noreorder
	.set	nomacro
	jal	memcpy
	addiu	$5,$sp,28
	.set	macro
	.set	reorder

	lw	$5,80($sp)
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_mark
	move	$4,$17
	.set	macro
	.set	reorder

	lw	$2,96($sp)
	move	$4,$17
	sw	$2,12($21)
	lw	$3,88($sp)
	#nop
	sh	$3,0($22)
	lw	$5,92($sp)
	#nop
	sw	$5,16($21)
	lw	$6,84($sp)
	.set	noreorder
	.set	nomacro
	jal	rtl_set_skb_dst
	sh	$6,2($22)
	.set	macro
	.set	reorder

	beq	$20,$0,$L345
#APP
 # 114 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/atomic.h" 1
	raw_local_irq_save	$2
 # 0 "" 2
#NO_APP
	lw	$3,452($20)
	#nop
	addiu	$3,$3,-1
	sw	$3,452($20)
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$2
 # 0 "" 2
#NO_APP
$L345:
	beq	$19,$0,$L346
#APP
 # 114 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/atomic.h" 1
	raw_local_irq_save	$2
 # 0 "" 2
#NO_APP
	lw	$3,452($19)
	#nop
	addiu	$3,$3,-1
	sw	$3,452($19)
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$2
 # 0 "" 2
#NO_APP
$L346:
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$23
 # 0 "" 2
#NO_APP
	lw	$4,152($sp)
	move	$5,$fp
	.set	noreorder
	.set	nomacro
	jal	rtl_conntrack_drop_check_hook
	move	$6,$4
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	j	$L298
	move	$2,$0
	.set	macro
	.set	reorder

$L300:
#APP
 # 134 "/home/janice_yu/pure/branch-rtl819x-sdk-v3.4.6/linux-2.6.30/arch/rlx/include/asm/irqflags.h" 1
	raw_local_irq_restore	$23
 # 0 "" 2
#NO_APP
	.set	noreorder
	.set	nomacro
	j	$L298
	li	$2,-1			# 0xffffffff
	.set	macro
	.set	reorder

$L292:
	li	$2,-1			# 0xffffffff
$L298:
	lw	$31,140($sp)
	lw	$fp,136($sp)
	lw	$23,132($sp)
	lw	$22,128($sp)
	lw	$21,124($sp)
	lw	$20,120($sp)
	lw	$19,116($sp)
	lw	$18,112($sp)
	lw	$17,108($sp)
	lw	$16,104($sp)
	.set	noreorder
	.set	nomacro
	j	$31
	addiu	$sp,$sp,144
	.set	macro
	.set	reorder

	.end	rtk_addNaptConnection
	.size	rtk_addNaptConnection, .-rtk_addNaptConnection
	.section	.text.negative_fragCache_init,"ax",@progbits
	.align	2
	.globl	negative_fragCache_init
	.set	nomips16
	.ent	negative_fragCache_init
	.type	negative_fragCache_init, @function
negative_fragCache_init:
	.frame	$sp,48,$31		# vars= 8, regs= 6/0, args= 16, gp= 0
	.mask	0x801f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
$L359 = .
$L360 = .
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$20,40($sp)
	sw	$19,36($sp)
	sw	$18,32($sp)
	sw	$17,28($sp)
	sw	$16,24($sp)
	lui	$2,%hi(malloc_sizes+60)
	lw	$4,%lo(malloc_sizes+60)($2)
	jal	kmem_cache_alloc
	li	$5,32			# 0x20

	lui	$3,%hi(negative_cache_table)
	beq	$2,$0,$L361
	sw	$2,%lo(negative_cache_table)($3)

	lui	$4,%hi(negative_cache_list_free)
	addiu	$2,$4,%lo(negative_cache_list_free)
	sw	$0,%lo(negative_cache_list_free)($4)
	sw	$2,4($2)
	sw	$0,8($2)
	li	$5,12			# 0xc
	move	$2,$0
	li	$4,64			# 0x40
$L362:
	mult	$2,$5
	lw	$7,%lo(negative_cache_table)($3)
	addiu	$2,$2,1
	mflo	$6
	addu	$7,$7,$6
	sw	$0,8($7)
	lw	$7,%lo(negative_cache_table)($3)
	nop
	addu	$7,$7,$6
	sw	$0,0($7)
	lw	$7,%lo(negative_cache_table)($3)
	nop
	addu	$6,$7,$6
	bne	$2,$4,$L362
	sw	$6,4($6)

	lui	$20,%hi(malloc_sizes)
	lui	$19,%hi(negative_cache_timeout)
	lui	$16,%hi(negative_cache_list_free)
	addiu	$20,$20,%lo(malloc_sizes)
	addiu	$19,$19,%lo(negative_cache_timeout)
	addiu	$16,$16,%lo(negative_cache_list_free)
	move	$17,$0
	li	$18,64			# 0x40
$L363:
	lw	$4,12($20)
	jal	kmem_cache_alloc
	li	$5,32			# 0x20

	beq	$2,$0,$L361
	addiu	$4,$2,12

	move	$5,$0
	move	$6,$0
	jal	init_timer_key
	sw	$2,16($sp)

	lw	$2,16($sp)
	addiu	$17,$17,1
	sw	$2,28($2)
	sw	$19,24($2)
	sw	$0,44($2)
	lw	$4,4($16)
	addiu	$3,$2,44
	sw	$4,48($2)
	lw	$4,4($16)
	nop
	sw	$2,0($4)
	lw	$2,8($16)
	sw	$3,4($16)
	addiu	$2,$2,1
	bne	$17,$18,$L363
	sw	$2,8($16)

	j	$L364
	li	$2,1			# 0x1

$L361:
	move	$2,$0
$L364:
	lw	$31,44($sp)
	lw	$20,40($sp)
	lw	$19,36($sp)
	lw	$18,32($sp)
	lw	$17,28($sp)
	lw	$16,24($sp)
	j	$31
	addiu	$sp,$sp,48

	.set	macro
	.set	reorder
	.end	negative_fragCache_init
	.size	negative_fragCache_init, .-negative_fragCache_init
	.section	.text.udp_fragCache_init,"ax",@progbits
	.align	2
	.globl	udp_fragCache_init
	.set	nomips16
	.ent	udp_fragCache_init
	.type	udp_fragCache_init, @function
udp_fragCache_init:
	.frame	$sp,48,$31		# vars= 8, regs= 6/0, args= 16, gp= 0
	.mask	0x801f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
$L369 = .
$L370 = .
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$20,40($sp)
	sw	$19,36($sp)
	sw	$18,32($sp)
	sw	$17,28($sp)
	sw	$16,24($sp)
	lui	$2,%hi(malloc_sizes+4)
	move	$17,$4
	lw	$4,%lo(malloc_sizes+4)($2)
	li	$5,32			# 0x20
	jal	kmem_cache_alloc
	lui	$16,%hi(udp_cache_table)

	move	$18,$2
	beq	$2,$0,$L371
	sw	$2,%lo(udp_cache_table)($16)

$L372 = .
	li	$4,12			# 0xc
	mult	$17,$4
	lui	$3,%hi(udp_cache_list_free)
	addiu	$2,$3,%lo(udp_cache_list_free)
	sw	$0,%lo(udp_cache_list_free)($3)
	li	$5,32			# 0x20
	lui	$3,%hi(max_udp_frag_entry)
	sw	$2,4($2)
	sw	$0,8($2)
	sw	$17,%lo(max_udp_frag_entry)($3)
	jal	__kmalloc
	mflo	$4

	sw	$2,0($18)
	lw	$4,%lo(udp_cache_table)($16)
	move	$3,$0
	lw	$4,0($4)
	nop
	bne	$4,$0,$L382
	li	$2,-1			# 0xffffffff

	j	$L374
	nop

$L376:
	lw	$5,%lo(udp_cache_table)($16)
	addiu	$3,$3,1
	lw	$5,0($5)
	mflo	$4
	addu	$5,$5,$4
	sw	$0,8($5)
	lw	$5,%lo(udp_cache_table)($16)
	nop
	lw	$5,0($5)
	nop
	addu	$5,$5,$4
	sw	$0,0($5)
	lw	$5,%lo(udp_cache_table)($16)
	nop
	lw	$5,0($5)
	nop
	addu	$4,$5,$4
	j	$L381
	sw	$4,4($4)

$L382:
	li	$2,12			# 0xc
$L381:
	slt	$4,$3,$17
	bne	$4,$0,$L376
	mult	$3,$2

	lui	$20,%hi(malloc_sizes)
	lui	$19,%hi(cache_timeout)
	lui	$16,%hi(udp_cache_list_free)
	addiu	$20,$20,%lo(malloc_sizes)
	addiu	$19,$19,%lo(cache_timeout)
	addiu	$16,$16,%lo(udp_cache_list_free)
	j	$L377
	move	$18,$0

$L378:
$L379 = .
	lw	$4,12($20)
	jal	kmem_cache_alloc
	li	$5,32			# 0x20

	beq	$2,$0,$L371
	addiu	$4,$2,16

	move	$5,$0
	move	$6,$0
	jal	init_timer_key
	sw	$2,16($sp)

	lw	$2,16($sp)
	addiu	$18,$18,1
	sw	$2,32($2)
	sw	$19,28($2)
	sw	$0,48($2)
	lw	$4,4($16)
	addiu	$3,$2,48
	sw	$4,52($2)
	lw	$4,4($16)
	nop
	sw	$2,0($4)
	lw	$2,8($16)
	sw	$3,4($16)
	addiu	$2,$2,1
	sw	$2,8($16)
$L377:
	slt	$2,$18,$17
	bne	$2,$0,$L378
	li	$2,1			# 0x1

	j	$L374
	nop

$L371:
	move	$2,$0
$L374:
	lw	$31,44($sp)
	lw	$20,40($sp)
	lw	$19,36($sp)
	lw	$18,32($sp)
	lw	$17,28($sp)
	lw	$16,24($sp)
	j	$31
	addiu	$sp,$sp,48

	.set	macro
	.set	reorder
	.end	udp_fragCache_init
	.size	udp_fragCache_init, .-udp_fragCache_init
	.local	napt_table_list_max
	.comm	napt_table_list_max,4,4
	.local	path_table_list_max
	.comm	path_table_list_max,4,4
	.local	max_udp_frag_entry
	.comm	max_udp_frag_entry,4,4
	.globl	route_list_inuse
	.section	.bss,"aw",@nobits
	.align	2
	.type	route_list_inuse, @object
	.size	route_list_inuse, 12
route_list_inuse:
	.space	12
	.globl	route_list_free
	.align	2
	.type	route_list_free, @object
	.size	route_list_free, 12
route_list_free:
	.space	12
	.globl	napt_list_inuse
	.align	2
	.type	napt_list_inuse, @object
	.size	napt_list_inuse, 12
napt_list_inuse:
	.space	12
	.globl	napt_list_free
	.align	2
	.type	napt_list_free, @object
	.size	napt_list_free, 12
napt_list_free:
	.space	12
	.globl	table_napt
	.align	2
	.type	table_napt, @object
	.size	table_napt, 4
table_napt:
	.space	4
	.globl	path_list_inuse
	.align	2
	.type	path_list_inuse, @object
	.size	path_list_inuse, 12
path_list_inuse:
	.space	12
	.globl	path_list_free
	.align	2
	.type	path_list_free, @object
	.size	path_list_free, 12
path_list_free:
	.space	12
	.globl	table_path
	.align	2
	.type	table_path, @object
	.size	table_path, 4
table_path:
	.space	4
	.globl	udp_cache_list_free
	.align	2
	.type	udp_cache_list_free, @object
	.size	udp_cache_list_free, 12
udp_cache_list_free:
	.space	12
	.globl	udp_cache_table
	.align	2
	.type	udp_cache_table, @object
	.size	udp_cache_table, 4
udp_cache_table:
	.space	4
	.globl	negative_cache_list_free
	.align	2
	.type	negative_cache_list_free, @object
	.size	negative_cache_list_free, 12
negative_cache_list_free:
	.space	12
	.globl	negative_cache_table
	.align	2
	.type	negative_cache_table, @object
	.size	negative_cache_table, 4
negative_cache_table:
	.space	4
	.ident	"GCC: (GNU) 4.4.5-1.5.5p2"
