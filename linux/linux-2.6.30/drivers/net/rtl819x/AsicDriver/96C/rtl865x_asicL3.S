	.file	1 "rtl865x_asicL3.c"
	.section .mdebug.abi32
	.previous
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
	.section	.text.rtl8651_setAsicExtIntIpTable,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicExtIntIpTable
	.ent	rtl8651_setAsicExtIntIpTable
	.type	rtl8651_setAsicExtIntIpTable, @function
rtl8651_setAsicExtIntIpTable:
	.set	nomips16
	.frame	$sp,64,$31		# vars= 32, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-64
	sw	$31,56($sp)
	sw	$17,52($sp)
	sw	$16,48($sp)
	move	$17,$4
	sltu	$2,$4,16
	beq	$2,$0,$L3
	move	$16,$5

	beq	$5,$0,$L3
	li	$3,-1073741824			# 0xffffffffc0000000

	lw	$2,12($5)
	nop
	and	$2,$2,$3
	bne	$2,$3,$L2
	addiu	$4,$sp,16

$L3:
	j	$L1
	li	$2,-1			# 0xffffffffffffffff

$L2:
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lw	$2,0($16)
	nop
	sw	$2,20($sp)
	lw	$2,4($16)
	nop
	sw	$2,16($sp)
	lw	$5,12($16)
	nop
	srl	$4,$5,31
	sll	$4,$4,2
	lw	$2,24($sp)
	li	$3,-5			# 0xfffffffffffffffb
	and	$2,$2,$3
	or	$2,$2,$4
	srl	$5,$5,29
	andi	$5,$5,0x2
	li	$3,-3			# 0xfffffffffffffffd
	and	$2,$2,$3
	or	$2,$2,$5
	lw	$3,8($16)
	nop
	andi	$3,$3,0x1f
	sll	$3,$3,3
	li	$4,-249			# 0xffffffffffffff07
	and	$2,$2,$4
	or	$2,$2,$3
	ori	$2,$2,0x1
	sw	$2,24($sp)
	li	$4,5			# 0x5
	move	$5,$17
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

$L1:
	lw	$31,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,64

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicExtIntIpTable
	.section	.text.rtl8651_delAsicExtIntIpTable,"ax",@progbits
	.align	2
	.globl	rtl8651_delAsicExtIntIpTable
	.ent	rtl8651_delAsicExtIntIpTable
	.type	rtl8651_delAsicExtIntIpTable, @function
rtl8651_delAsicExtIntIpTable:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$16,$4
	sltu	$2,$4,16
	beq	$2,$0,$L4
	li	$3,-1			# 0xffffffffffffffff

	addiu	$4,$sp,16
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lw	$2,24($sp)
	li	$3,-2			# 0xfffffffffffffffe
	and	$2,$2,$3
	sw	$2,24($sp)
	li	$4,5			# 0x5
	move	$5,$16
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

	move	$3,$2
$L4:
	move	$2,$3
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_delAsicExtIntIpTable
	.section	.text.rtl8651_getAsicExtIntIpTable,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicExtIntIpTable
	.ent	rtl8651_getAsicExtIntIpTable
	.type	rtl8651_getAsicExtIntIpTable, @function
rtl8651_getAsicExtIntIpTable:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$3,$4
	sltu	$2,$4,16
	beq	$2,$0,$L8
	move	$16,$5

	bne	$5,$0,$L7
	li	$4,5			# 0x5

$L8:
	j	$L6
	li	$3,-1			# 0xffffffffffffffff

$L7:
	move	$5,$3
	jal	_rtl8651_readAsicEntry
	addiu	$6,$sp,16

	lw	$2,24($sp)
	nop
	andi	$2,$2,0x1
	beq	$2,$0,$L6
	li	$3,-1			# 0xffffffffffffffff

	lw	$2,20($sp)
	nop
	sw	$2,0($16)
	lw	$2,16($sp)
	nop
	sw	$2,4($16)
	lw	$5,24($sp)
	nop
	srl	$4,$5,2
	sll	$4,$4,31
	lw	$3,12($16)
	li	$2,2147418112			# 0x7fff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	srl	$4,$5,1
	andi	$4,$4,0x1
	sll	$4,$4,30
	li	$2,-1073807360			# 0xffffffffbfff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	sw	$3,12($16)
	srl	$5,$5,3
	andi	$5,$5,0x1f
	sw	$5,8($16)
	move	$3,$0
$L6:
	move	$2,$3
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicExtIntIpTable
	.section	.text.rtl8651_setAsicPppoe,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicPppoe
	.ent	rtl8651_setAsicPppoe
	.type	rtl8651_setAsicPppoe, @function
rtl8651_setAsicPppoe:
	.set	nomips16
	.frame	$sp,64,$31		# vars= 32, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-64
	sw	$31,56($sp)
	sw	$17,52($sp)
	sw	$16,48($sp)
	move	$17,$4
	sltu	$2,$4,8
	beq	$2,$0,$L12
	move	$16,$5

	beq	$5,$0,$L13
	li	$2,-1			# 0xffffffffffffffff

	lhu	$3,0($5)
	li	$2,65535			# 0xffff
	bne	$3,$2,$L11
	addiu	$4,$sp,16

$L12:
	j	$L10
	li	$2,-1			# 0xffffffffffffffff

$L11:
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lhu	$2,0($16)
	nop
	sh	$2,18($sp)
	lhu	$4,2($16)
	nop
	andi	$4,$4,0x7
	sll	$4,$4,16
	lw	$3,16($sp)
	li	$2,-524288			# 0xfffffffffff80000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	sw	$3,16($sp)
	li	$4,11			# 0xb
	move	$5,$17
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

$L10:
$L13:
	lw	$31,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,64

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicPppoe
	.section	.text.rtl8651_getAsicPppoe,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicPppoe
	.ent	rtl8651_getAsicPppoe
	.type	rtl8651_getAsicPppoe, @function
rtl8651_getAsicPppoe:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$3,$4
	sltu	$2,$4,8
	beq	$2,$0,$L16
	move	$16,$5

	bne	$5,$0,$L15
	li	$4,11			# 0xb

$L16:
	j	$L14
	li	$2,-1			# 0xffffffffffffffff

$L15:
	move	$5,$3
	jal	_rtl8651_readAsicEntry
	addiu	$6,$sp,16

	lhu	$2,18($sp)
	nop
	sh	$2,0($16)
	lhu	$2,16($sp)
	nop
	andi	$2,$2,0x7
	sh	$2,2($16)
	move	$2,$0
$L14:
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicPppoe
	.section	.text.rtl8651_setAsicNextHopTable,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicNextHopTable
	.ent	rtl8651_setAsicNextHopTable
	.type	rtl8651_setAsicNextHopTable, @function
rtl8651_setAsicNextHopTable:
	.set	nomips16
	.frame	$sp,64,$31		# vars= 32, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-64
	sw	$31,56($sp)
	sw	$17,52($sp)
	sw	$16,48($sp)
	move	$17,$4
	sltu	$2,$4,32
	beq	$2,$0,$L19
	move	$16,$5

	bne	$5,$0,$L18
	addiu	$4,$sp,16

$L19:
	j	$L17
	li	$2,-1			# 0xffffffffffffffff

$L18:
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lw	$4,0($16)
	nop
	sll	$4,$4,2
	lw	$2,4($16)
	nop
	or	$4,$4,$2
	andi	$4,$4,0x3ff
	sll	$4,$4,11
	lw	$3,16($sp)
	li	$2,-2097152			# 0xffffffffffe00000
	ori	$2,$2,0x7ff
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$2,8($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,8
	li	$4,-1793			# 0xfffffffffffff8ff
	and	$3,$3,$4
	or	$3,$3,$2
	lw	$2,12($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,5
	li	$4,-225			# 0xffffffffffffff1f
	and	$3,$3,$4
	or	$3,$3,$2
	lw	$2,16($16)
	nop
	andi	$2,$2,0xf
	sll	$2,$2,1
	li	$4,-31			# 0xffffffffffffffe1
	and	$3,$3,$4
	or	$3,$3,$2
	lw	$2,20($16)
	nop
	srl	$2,$2,31
	li	$4,-2			# 0xfffffffffffffffe
	and	$3,$3,$4
	or	$3,$3,$2
	sw	$3,16($sp)
	li	$4,13			# 0xd
	move	$5,$17
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

$L17:
	lw	$31,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,64

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicNextHopTable
	.section	.text.rtl8651_getAsicNextHopTable,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicNextHopTable
	.ent	rtl8651_getAsicNextHopTable
	.type	rtl8651_getAsicNextHopTable, @function
rtl8651_getAsicNextHopTable:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$3,$4
	sltu	$2,$4,32
	beq	$2,$0,$L22
	move	$16,$5

	bne	$5,$0,$L21
	li	$4,13			# 0xd

$L22:
	j	$L20
	li	$2,-1			# 0xffffffffffffffff

$L21:
	move	$5,$3
	jal	_rtl8651_readAsicEntry
	addiu	$6,$sp,16

	lw	$4,16($sp)
	nop
	srl	$3,$4,11
	andi	$2,$3,0x3ff
	sra	$2,$2,2
	sw	$2,0($16)
	andi	$3,$3,0x3
	sw	$3,4($16)
	srl	$2,$4,8
	andi	$2,$2,0x7
	sw	$2,8($16)
	srl	$2,$4,5
	andi	$2,$2,0x7
	sw	$2,12($16)
	srl	$2,$4,1
	andi	$2,$2,0xf
	sw	$2,16($16)
	sll	$4,$4,31
	lw	$3,20($16)
	li	$2,2147418112			# 0x7fff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	sw	$3,20($16)
	move	$2,$0
$L20:
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicNextHopTable
	.section	.text.rtl8651_setAsicRouting,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicRouting
	.ent	rtl8651_setAsicRouting
	.type	rtl8651_setAsicRouting, @function
rtl8651_setAsicRouting:
	.set	nomips16
	.frame	$sp,64,$31		# vars= 32, regs= 4/0, args= 16, gp= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-64
	sw	$31,60($sp)
	sw	$18,56($sp)
	sw	$17,52($sp)
	sw	$16,48($sp)
	move	$18,$4
	sltu	$2,$4,8
	beq	$2,$0,$L25
	move	$16,$5

	bne	$5,$0,$L24
	nop

$L25:
	j	$L23
	li	$2,-1			# 0xffffffffffffffff

$L24:
	lw	$2,4($5)
	nop
	beq	$2,$0,$L32
	move	$17,$0

	move	$4,$0
	li	$5,1			# 0x1
	move	$3,$2
	sll	$2,$5,$4
$L52:
	and	$2,$2,$3
	bne	$2,$0,$L51
	li	$2,31			# 0x1f

	addiu	$4,$4,1
	sltu	$2,$4,32
	bne	$2,$0,$L52
	sll	$2,$5,$4

	li	$2,31			# 0x1f
$L51:
	subu	$17,$2,$4
$L32:
	addiu	$4,$sp,16
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lw	$2,0($16)
	nop
	sw	$2,16($sp)
	lw	$3,8($16)
	nop
	sltu	$2,$3,7
	beq	$2,$0,$L53
	li	$2,-1			# 0xffffffffffffffff

	sll	$2,$3,2
	lui	$3,%hi($L49)
	addiu	$3,$3,%lo($L49)
	addu	$2,$2,$3
	lw	$2,0($2)
	nop
	j	$2
	nop

	.rdata
	.align	2
$L49:
	.word	$L34
	.word	$L35
	.word	$L36
	.word	$L48
	.word	$L38
	.word	$L39
	.word	$L38
	.section	.text.rtl8651_setAsicRouting
$L34:
	lw	$4,36($16)
	nop
	andi	$4,$4,0x7
	sll	$4,$4,24
	lw	$3,20($sp)
	li	$2,-117506048			# 0xfffffffff8ff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$4,28($16)
	nop
	sll	$4,$4,2
	lw	$2,32($16)
	nop
	or	$4,$4,$2
	andi	$4,$4,0x3ff
	sll	$4,$4,14
	li	$2,-16777216			# 0xffffffffff000000
	ori	$2,$2,0x3fff
	and	$3,$3,$2
	or	$3,$3,$4
	andi	$4,$17,0x1f
	li	$2,-32			# 0xffffffffffffffe0
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$2,12($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,11
	li	$4,-14337			# 0xffffffffffffc7ff
	and	$3,$3,$4
	or	$3,$3,$2
	lw	$5,60($16)
	nop
	slt	$2,$5,0
	sll	$2,$2,9
	li	$4,-513			# 0xfffffffffffffdff
	and	$3,$3,$4
	or	$3,$3,$2
	srl	$5,$5,20
	andi	$5,$5,0x400
	li	$2,-1025			# 0xfffffffffffffbff
	and	$3,$3,$2
	or	$3,$3,$5
	lw	$2,8($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,6
	li	$4,-449			# 0xfffffffffffffe3f
	and	$3,$3,$4
	or	$3,$3,$2
	ori	$3,$3,0x20
	j	$L33
	sw	$3,20($sp)

$L35:
	lw	$4,28($16)
	nop
	sll	$4,$4,2
	lw	$2,32($16)
	nop
	or	$4,$4,$2
	andi	$4,$4,0x3ff
	sll	$4,$4,14
	lw	$3,20($sp)
	li	$2,-16777216			# 0xffffffffff000000
	ori	$2,$2,0x3fff
	and	$3,$3,$2
	or	$3,$3,$4
	andi	$4,$17,0x1f
	li	$2,-32			# 0xffffffffffffffe0
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$2,12($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,11
	li	$4,-14337			# 0xffffffffffffc7ff
	and	$3,$3,$4
	or	$3,$3,$2
	lw	$5,60($16)
	nop
	slt	$2,$5,0
	sll	$2,$2,9
	li	$4,-513			# 0xfffffffffffffdff
	and	$3,$3,$4
	or	$3,$3,$2
	srl	$5,$5,20
	andi	$5,$5,0x400
	li	$2,-1025			# 0xfffffffffffffbff
	and	$3,$3,$2
	or	$3,$3,$5
	lw	$2,8($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,6
	li	$4,-449			# 0xfffffffffffffe3f
	and	$3,$3,$4
	or	$3,$3,$2
	ori	$3,$3,0x20
	j	$L33
	sw	$3,20($sp)

$L36:
	lw	$4,20($16)
	nop
	srl	$4,$4,3
	andi	$4,$4,0x3f
	sll	$4,$4,20
	lw	$3,20($sp)
	li	$2,-66125824			# 0xfffffffffc0f0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$4,16($16)
	nop
	srl	$4,$4,3
	andi	$4,$4,0x3f
	sll	$4,$4,14
	li	$2,-1048576			# 0xfffffffffff00000
	ori	$2,$2,0x3fff
	and	$3,$3,$2
	or	$3,$3,$4
	andi	$4,$17,0x1f
	li	$2,-32			# 0xffffffffffffffe0
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$2,12($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,11
	li	$4,-14337			# 0xffffffffffffc7ff
	and	$3,$3,$4
	or	$3,$3,$2
	lw	$5,60($16)
	nop
	slt	$2,$5,0
	sll	$2,$2,9
	li	$4,-513			# 0xfffffffffffffdff
	and	$3,$3,$4
	or	$3,$3,$2
	srl	$5,$5,20
	andi	$5,$5,0x400
	li	$2,-1025			# 0xfffffffffffffbff
	and	$3,$3,$2
	or	$3,$3,$5
	lw	$2,8($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,6
	li	$4,-449			# 0xfffffffffffffe3f
	and	$3,$3,$4
	or	$3,$3,$2
	ori	$3,$3,0x20
	lw	$4,24($16)
	nop
	andi	$4,$4,0x7
	sll	$4,$4,26
	li	$2,-469827584			# 0xffffffffe3ff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	j	$L33
	sw	$3,20($sp)

$L38:
	lw	$3,12($16)
	nop
	andi	$3,$3,0x7
	sll	$3,$3,11
	lw	$2,20($sp)
	li	$4,-14337			# 0xffffffffffffc7ff
	and	$2,$2,$4
	or	$2,$2,$3
	andi	$4,$17,0x1f
	li	$3,-32			# 0xffffffffffffffe0
	and	$2,$2,$3
	or	$2,$2,$4
	lw	$3,8($16)
	nop
	andi	$3,$3,0x7
	sll	$3,$3,6
	li	$4,-449			# 0xfffffffffffffe3f
	and	$2,$2,$4
	or	$2,$2,$3
	ori	$2,$2,0x20
	lw	$3,60($16)
	nop
	slt	$3,$3,0
	sll	$3,$3,9
	li	$4,-513			# 0xfffffffffffffdff
	and	$2,$2,$4
	or	$2,$2,$3
	j	$L33
	sw	$2,20($sp)

$L39:
	lw	$3,40($16)
	nop
	srl	$3,$3,1
	andi	$3,$3,0xf
	sll	$3,$3,14
	lw	$4,20($sp)
	li	$2,-262144			# 0xfffffffffffc0000
	ori	$2,$2,0x3fff
	and	$4,$4,$2
	or	$4,$4,$3
	sw	$4,20($sp)
	lw	$3,44($16)
	nop
	sltu	$2,$3,33
	beq	$2,$0,$L53
	li	$2,-1			# 0xffffffffffffffff

	sll	$2,$3,2
	lui	$3,%hi($L47)
	addiu	$3,$3,%lo($L47)
	addu	$2,$2,$3
	lw	$2,0($2)
	nop
	j	$2
	nop

	.rdata
	.align	2
$L47:
	.word	$L46
	.word	$L46
	.word	$L41
	.word	$L46
	.word	$L42
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L43
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L44
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L45
	.section	.text.rtl8651_setAsicRouting
$L41:
	lw	$2,20($sp)
	li	$3,-14337			# 0xffffffffffffc7ff
	and	$2,$2,$3
	j	$L40
	sw	$2,20($sp)

$L42:
	lw	$2,20($sp)
	li	$3,-14337			# 0xffffffffffffc7ff
	and	$2,$2,$3
	ori	$2,$2,0x800
	j	$L40
	sw	$2,20($sp)

$L43:
	lw	$2,20($sp)
	li	$3,-14337			# 0xffffffffffffc7ff
	and	$2,$2,$3
	ori	$2,$2,0x1000
	j	$L40
	sw	$2,20($sp)

$L44:
	lw	$2,20($sp)
	li	$3,-14337			# 0xffffffffffffc7ff
	and	$2,$2,$3
	ori	$2,$2,0x1800
	j	$L40
	sw	$2,20($sp)

$L45:
	lw	$2,20($sp)
	li	$3,-14337			# 0xffffffffffffc7ff
	and	$2,$2,$3
	ori	$2,$2,0x2000
	j	$L40
	sw	$2,20($sp)

$L46:
	j	$L23
	li	$2,-1			# 0xffffffffffffffff

$L40:
	lw	$4,48($16)
	nop
	andi	$4,$4,0x1f
	sll	$4,$4,18
	lw	$3,20($sp)
	li	$2,-8192000			# 0xffffffffff830000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$4,52($16)
	nop
	andi	$4,$4,0x3
	sll	$4,$4,23
	li	$2,-25231360			# 0xfffffffffe7f0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	andi	$4,$17,0x1f
	li	$2,-32			# 0xffffffffffffffe0
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$2,8($16)
	nop
	andi	$2,$2,0x7
	sll	$2,$2,6
	li	$4,-449			# 0xfffffffffffffe3f
	and	$3,$3,$4
	or	$3,$3,$2
	ori	$3,$3,0x20
	lw	$4,56($16)
	nop
	andi	$4,$4,0x7
	sll	$4,$4,25
	li	$2,-234946560			# 0xfffffffff1ff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	lw	$5,60($16)
	nop
	slt	$2,$5,0
	sll	$2,$2,9
	li	$4,-513			# 0xfffffffffffffdff
	and	$3,$3,$4
	or	$3,$3,$2
	srl	$5,$5,20
	andi	$5,$5,0x400
	li	$2,-1025			# 0xfffffffffffffbff
	and	$3,$3,$2
	or	$3,$3,$5
	j	$L33
	sw	$3,20($sp)

$L48:
	j	$L23
	li	$2,-1			# 0xffffffffffffffff

$L33:
	li	$4,2			# 0x2
	move	$5,$18
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

$L23:
$L53:
	lw	$31,60($sp)
	lw	$18,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,64

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicRouting
	.section	.text.rtl8651_delAsicRouting,"ax",@progbits
	.align	2
	.globl	rtl8651_delAsicRouting
	.ent	rtl8651_delAsicRouting
	.type	rtl8651_delAsicRouting, @function
rtl8651_delAsicRouting:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$16,$4
	sltu	$2,$4,8
	beq	$2,$0,$L54
	li	$3,-1			# 0xffffffffffffffff

	addiu	$4,$sp,16
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lw	$2,20($sp)
	li	$3,-33			# 0xffffffffffffffdf
	and	$2,$2,$3
	sw	$2,20($sp)
	li	$4,2			# 0x2
	move	$5,$16
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

	move	$3,$2
$L54:
	move	$2,$3
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_delAsicRouting
	.section	.text.rtl8651_getAsicRouting,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicRouting
	.ent	rtl8651_getAsicRouting
	.type	rtl8651_getAsicRouting, @function
rtl8651_getAsicRouting:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$3,$4
	sltu	$2,$4,8
	beq	$2,$0,$L58
	move	$16,$5

	bne	$5,$0,$L57
	move	$5,$3

$L58:
	j	$L56
	li	$4,-1			# 0xffffffffffffffff

$L57:
	li	$4,2			# 0x2
	jal	_rtl8651_readAsicEntry
	addiu	$6,$sp,16

	lw	$2,20($sp)
	nop
	srl	$2,$2,5
	andi	$2,$2,0x1
	beq	$2,$0,$L56
	li	$4,-1			# 0xffffffffffffffff

	lw	$2,16($sp)
	nop
	sw	$2,0($16)
	lw	$2,20($sp)
	nop
	srl	$2,$2,6
	andi	$2,$2,0x7
	sw	$2,8($16)
	move	$3,$0
	sw	$0,4($16)
	li	$7,31			# 0x1f
	li	$6,1			# 0x1
	lw	$2,20($sp)
	nop
	andi	$5,$2,0x1f
	move	$4,$0
	subu	$2,$7,$3
$L84:
	sll	$2,$6,$2
	or	$4,$2,$4
	addiu	$3,$3,1
	sltu	$2,$5,$3
	beq	$2,$0,$L84
	subu	$2,$7,$3

	sw	$4,4($16)
	lw	$4,20($sp)
	nop
	srl	$2,$4,11
	andi	$2,$2,0x7
	sw	$2,12($16)
	srl	$4,$4,9
	sll	$4,$4,31
	lw	$3,60($16)
	li	$2,2147418112			# 0x7fff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	sw	$3,60($16)
	lw	$3,8($16)
	nop
	sltu	$2,$3,7
	beq	$2,$0,$L79
	sll	$2,$3,2

	lui	$3,%hi($L80)
	addiu	$3,$3,%lo($L80)
	addu	$2,$2,$3
	lw	$2,0($2)
	nop
	j	$2
	nop

	.rdata
	.align	2
$L80:
	.word	$L65
	.word	$L66
	.word	$L67
	.word	$L79
	.word	$L69
	.word	$L70
	.word	$L69
	.section	.text.rtl8651_getAsicRouting
$L65:
	sw	$0,16($16)
	sw	$0,20($16)
	lw	$4,20($sp)
	nop
	srl	$2,$4,24
	andi	$2,$2,0x7
	sw	$2,36($16)
	srl	$3,$4,14
	andi	$2,$3,0x3ff
	sra	$2,$2,2
	sw	$2,28($16)
	andi	$3,$3,0x3
	sw	$3,32($16)
	srl	$4,$4,10
	andi	$4,$4,0x1
	sll	$4,$4,30
	lw	$3,60($16)
	li	$2,-1073807360			# 0xffffffffbfff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	j	$L64
	sw	$3,60($16)

$L66:
	sw	$0,16($16)
	sw	$0,20($16)
	sw	$0,36($16)
	lw	$4,20($sp)
	nop
	srl	$3,$4,14
	andi	$2,$3,0x3ff
	sra	$2,$2,2
	sw	$2,28($16)
	andi	$3,$3,0x3
	sw	$3,32($16)
	srl	$4,$4,10
	andi	$4,$4,0x1
	sll	$4,$4,30
	lw	$3,60($16)
	li	$2,-1073807360			# 0xffffffffbfff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	j	$L64
	sw	$3,60($16)

$L67:
	lw	$4,20($sp)
	nop
	srl	$2,$4,20
	andi	$2,$2,0x3f
	sw	$2,20($16)
	srl	$2,$4,14
	andi	$2,$2,0x3f
	sw	$2,16($16)
	sw	$0,36($16)
	sw	$0,28($16)
	sw	$0,32($16)
	srl	$2,$4,26
	andi	$2,$2,0x7
	sw	$2,24($16)
	srl	$4,$4,10
	andi	$4,$4,0x1
	sll	$4,$4,30
	lw	$3,60($16)
	li	$2,-1073807360			# 0xffffffffbfff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	j	$L64
	sw	$3,60($16)

$L69:
	sw	$0,16($16)
	sw	$0,20($16)
	sw	$0,36($16)
	sw	$0,28($16)
	sw	$0,32($16)
	lw	$2,20($sp)
	nop
	srl	$2,$2,10
	andi	$2,$2,0x1
	sll	$2,$2,30
	lw	$4,60($16)
	li	$3,-1073807360			# 0xffffffffbfff0000
	ori	$3,$3,0xffff
	and	$4,$4,$3
	or	$4,$4,$2
	j	$L64
	sw	$4,60($16)

$L70:
	lw	$2,20($sp)
	nop
	srl	$3,$2,13
	andi	$3,$3,0x1e
	sw	$3,40($16)
	srl	$2,$2,11
	andi	$3,$2,0x7
	sltu	$2,$3,5
	beq	$2,$0,$L56
	li	$4,-1			# 0xffffffffffffffff

	sll	$2,$3,2
	lui	$3,%hi($L78)
	addiu	$3,$3,%lo($L78)
	addu	$2,$2,$3
	lw	$2,0($2)
	nop
	j	$2
	nop

	.rdata
	.align	2
$L78:
	.word	$L72
	.word	$L73
	.word	$L74
	.word	$L75
	.word	$L76
	.section	.text.rtl8651_getAsicRouting
$L72:
	li	$2,2			# 0x2
	j	$L71
	sw	$2,44($16)

$L73:
	li	$2,4			# 0x4
	j	$L71
	sw	$2,44($16)

$L74:
	li	$2,8			# 0x8
	j	$L71
	sw	$2,44($16)

$L75:
	li	$2,16			# 0x10
	j	$L71
	sw	$2,44($16)

$L76:
	li	$2,32			# 0x20
	sw	$2,44($16)
$L71:
	lw	$4,20($sp)
	nop
	srl	$2,$4,18
	andi	$2,$2,0x1f
	sw	$2,48($16)
	srl	$2,$4,23
	andi	$2,$2,0x3
	sw	$2,52($16)
	srl	$2,$4,25
	andi	$2,$2,0x7
	sw	$2,56($16)
	srl	$5,$4,9
	sll	$5,$5,31
	lw	$3,60($16)
	li	$2,2147418112			# 0x7fff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$5
	srl	$4,$4,10
	andi	$4,$4,0x1
	sll	$4,$4,30
	li	$2,-1073807360			# 0xffffffffbfff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	or	$3,$3,$4
	j	$L64
	sw	$3,60($16)

$L79:
	j	$L56
	li	$4,-1			# 0xffffffffffffffff

$L64:
	move	$4,$0
$L56:
	move	$2,$4
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicRouting
	.section	.text.rtl8651_setAsicArp,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicArp
	.ent	rtl8651_setAsicArp
	.type	rtl8651_setAsicArp, @function
rtl8651_setAsicArp:
	.set	nomips16
	.frame	$sp,64,$31		# vars= 32, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-64
	sw	$31,56($sp)
	sw	$17,52($sp)
	sw	$16,48($sp)
	move	$17,$4
	sltu	$2,$4,512
	beq	$2,$0,$L87
	move	$16,$5

	bne	$5,$0,$L86
	addiu	$4,$sp,16

$L87:
	j	$L85
	li	$2,-1			# 0xffffffffffffffff

$L86:
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lw	$3,0($16)
	nop
	sll	$3,$3,2
	lw	$2,4($16)
	nop
	andi	$2,$2,0x3
	or	$3,$3,$2
	andi	$3,$3,0x3ff
	sll	$3,$3,1
	lw	$4,16($sp)
	li	$2,-2047			# 0xfffffffffffff801
	and	$4,$4,$2
	or	$4,$4,$3
	ori	$4,$4,0x1
	lw	$3,8($16)
	nop
	andi	$3,$3,0x1f
	sll	$3,$3,11
	li	$2,-65536			# 0xffffffffffff0000
	ori	$2,$2,0x7ff
	and	$4,$4,$2
	or	$4,$4,$3
	sw	$4,16($sp)
	li	$4,1			# 0x1
	move	$5,$17
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

$L85:
	lw	$31,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,64

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicArp
	.section	.text.rtl8651_delAsicArp,"ax",@progbits
	.align	2
	.globl	rtl8651_delAsicArp
	.ent	rtl8651_delAsicArp
	.type	rtl8651_delAsicArp, @function
rtl8651_delAsicArp:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$16,$4
	sltu	$2,$4,512
	beq	$2,$0,$L88
	li	$3,-1			# 0xffffffffffffffff

	addiu	$4,$sp,16
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lw	$2,16($sp)
	li	$3,-2			# 0xfffffffffffffffe
	and	$2,$2,$3
	sw	$2,16($sp)
	li	$4,1			# 0x1
	move	$5,$16
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

	move	$3,$2
$L88:
	move	$2,$3
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_delAsicArp
	.section	.text.rtl8651_getAsicArp,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicArp
	.ent	rtl8651_getAsicArp
	.type	rtl8651_getAsicArp, @function
rtl8651_getAsicArp:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$3,$4
	sltu	$2,$4,512
	beq	$2,$0,$L92
	move	$16,$5

	bne	$5,$0,$L91
	li	$4,1			# 0x1

$L92:
	j	$L90
	li	$3,-1			# 0xffffffffffffffff

$L91:
	move	$5,$3
	jal	_rtl8651_readAsicEntryStopTLU
	addiu	$6,$sp,16

	lw	$2,16($sp)
	nop
	andi	$2,$2,0x1
	beq	$2,$0,$L90
	li	$3,-1			# 0xffffffffffffffff

	lw	$4,16($sp)
	nop
	srl	$3,$4,1
	andi	$2,$3,0x3ff
	sra	$2,$2,2
	sw	$2,0($16)
	andi	$3,$3,0x3
	sw	$3,4($16)
	srl	$4,$4,11
	andi	$4,$4,0x1f
	sw	$4,8($16)
	move	$3,$0
$L90:
	move	$2,$3
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicArp
	.section	.text.bitReverse,"ax",@progbits
	.align	2
	.globl	bitReverse
	.ent	bitReverse
	.type	bitReverse, @function
bitReverse:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	li	$2,1431633920			# 0x55550000
	ori	$2,$2,0x5555
	srl	$3,$4,1
	and	$3,$3,$2
	and	$2,$4,$2
	sll	$2,$2,1
	or	$4,$3,$2
	li	$2,858980352			# 0x33330000
	ori	$2,$2,0x3333
	srl	$3,$4,2
	and	$3,$3,$2
	and	$2,$4,$2
	sll	$2,$2,2
	or	$4,$3,$2
	li	$2,252641280			# 0xf0f0000
	ori	$2,$2,0xf0f
	srl	$3,$4,4
	and	$3,$3,$2
	and	$2,$4,$2
	sll	$2,$2,4
	or	$4,$3,$2
	li	$2,16711680			# 0xff0000
	ori	$2,$2,0xff
	srl	$3,$4,8
	and	$3,$3,$2
	and	$2,$4,$2
	sll	$2,$2,8
	or	$4,$3,$2
	sll	$3,$4,16
	srl	$2,$4,16
	j	$31
	or	$2,$3,$2

	.set	macro
	.set	reorder
	.end	bitReverse
	.data
	.align	2
	.type	currHashMethod, @object
	.size	currHashMethod, 4
currHashMethod:
	.word	0
	.section	.text.rtl8651_ipMulticastTableIndex,"ax",@progbits
	.align	2
	.globl	rtl8651_ipMulticastTableIndex
	.ent	rtl8651_ipMulticastTableIndex
	.type	rtl8651_ipMulticastTableIndex, @function
rtl8651_ipMulticastTableIndex:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	move	$6,$4
	li	$2,-1149239296			# 0xffffffffbb800000
	ori	$2,$2,0x4428
	lw	$2,0($2)
	nop
	andi	$2,$2,0x60
	srl	$2,$2,5
	lui	$3,%hi(currHashMethod)
	sw	$2,%lo(currHashMethod)($3)
	li	$3,2			# 0x2
	beq	$2,$3,$L97
	andi	$4,$4,0x7f

	lui	$2,%hi(currHashMethod)
	lw	$3,%lo(currHashMethod)($2)
	li	$2,3			# 0x3
	beq	$3,$2,$L97
	andi	$4,$5,0x7f

	srl	$4,$6,7
	xor	$4,$4,$6
	srl	$2,$6,14
	xor	$4,$4,$2
	srl	$2,$6,21
	xor	$4,$4,$2
	srl	$2,$6,28
	xor	$4,$4,$2
	srl	$3,$5,1
	srl	$2,$5,8
	xor	$3,$3,$2
	srl	$2,$5,15
	xor	$3,$3,$2
	srl	$2,$5,22
	xor	$3,$3,$2
	srl	$2,$5,29
	xor	$3,$3,$2
	andi	$2,$5,0x1
	sll	$2,$2,6
	xor	$3,$3,$2
	xor	$4,$4,$3
	andi	$4,$4,0x7f
$L97:
	j	$31
	move	$2,$4

	.set	macro
	.set	reorder
	.end	rtl8651_ipMulticastTableIndex
	.section	.text.rtl8651_setAsicIpMulticastTable,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicIpMulticastTable
	.ent	rtl8651_setAsicIpMulticastTable
	.type	rtl8651_setAsicIpMulticastTable, @function
rtl8651_setAsicIpMulticastTable:
	.set	nomips16
	.frame	$sp,64,$31		# vars= 32, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-64
	sw	$31,56($sp)
	sw	$17,52($sp)
	sw	$16,48($sp)
	lw	$2,4($4)
	nop
	srl	$2,$2,28
	li	$3,14			# 0xe
	bne	$2,$3,$L102
	move	$17,$4

	lhu	$3,10($4)
	lui	$2,%hi(rtl8651_totalExtPortNum)
	lw	$2,%lo(rtl8651_totalExtPortNum)($2)
	nop
	addiu	$2,$2,6
	slt	$3,$3,$2
	bne	$3,$0,$L101
	addiu	$4,$sp,16

$L102:
	j	$L100
	li	$2,-1			# 0xffffffffffffffff

$L101:
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	lw	$4,0($17)
	nop
	sw	$4,16($sp)
	lw	$5,4($17)
	li	$16,268369920			# 0xfff0000
	ori	$16,$16,0xffff
	and	$6,$5,$16
	lw	$2,20($sp)
	li	$3,-268435456			# 0xfffffffff0000000
	and	$2,$2,$3
	or	$2,$2,$6
	jal	rtl8651_ipMulticastTableIndex
	sw	$2,20($sp)

	lhu	$4,10($17)
	nop
	sll	$4,$4,28
	lw	$3,20($sp)
	nop
	and	$3,$3,$16
	or	$3,$3,$4
	sw	$3,20($sp)
	lw	$5,12($17)
	nop
	andi	$5,$5,0x1ff
	lw	$4,24($sp)
	li	$3,-512			# 0xfffffffffffffe00
	and	$4,$4,$3
	or	$4,$4,$5
	li	$3,-16385			# 0xffffffffffffbfff
	and	$4,$4,$3
	ori	$4,$4,0x2000
	lhu	$3,20($17)
	nop
	andi	$3,$3,0xf
	sll	$3,$3,9
	li	$5,-7681			# 0xffffffffffffe1ff
	and	$4,$4,$5
	or	$4,$4,$3
	li	$3,-262144			# 0xfffffffffffc0000
	ori	$3,$3,0x7fff
	and	$4,$4,$3
	li	$3,196608			# 0x30000
	ori	$3,$3,0x8000
	or	$4,$4,$3
	sw	$4,24($sp)
	li	$4,3			# 0x3
	move	$5,$2
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

$L100:
	lw	$31,56($sp)
	lw	$17,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,64

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicIpMulticastTable
	.section	.text.rtl8651_delAsicIpMulticastTable,"ax",@progbits
	.align	2
	.globl	rtl8651_delAsicIpMulticastTable
	.ent	rtl8651_delAsicIpMulticastTable
	.type	rtl8651_delAsicIpMulticastTable, @function
rtl8651_delAsicIpMulticastTable:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$16,$4
	addiu	$4,$sp,16
	move	$5,$0
	jal	memset
	li	$6,32			# 0x20

	li	$4,3			# 0x3
	move	$5,$16
	jal	_rtl8651_forceAddAsicEntry
	addiu	$6,$sp,16

	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_delAsicIpMulticastTable
	.section	.text.rtl8651_getAsicIpMulticastTable,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicIpMulticastTable
	.ent	rtl8651_getAsicIpMulticastTable
	.type	rtl8651_getAsicIpMulticastTable, @function
rtl8651_getAsicIpMulticastTable:
	.set	nomips16
	.frame	$sp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$16,48($sp)
	move	$3,$4
	move	$16,$5
	beq	$5,$0,$L104
	li	$2,-1			# 0xffffffffffffffff

	li	$4,3			# 0x3
	move	$5,$3
	jal	_rtl8651_readAsicEntryStopTLU
	addiu	$6,$sp,16

	lw	$2,16($sp)
	nop
	sw	$2,0($16)
	lw	$2,24($sp)
	nop
	srl	$2,$2,13
	andi	$2,$2,0x1
	beq	$2,$0,$L106
	li	$2,268369920			# 0xfff0000

	lw	$2,20($sp)
	li	$3,268369920			# 0xfff0000
	ori	$3,$3,0xffff
	and	$2,$2,$3
	li	$3,-536870912			# 0xffffffffe0000000
	or	$2,$2,$3
	j	$L107
	sw	$2,4($16)

$L106:
	lw	$3,20($sp)
	ori	$2,$2,0xffff
	and	$3,$3,$2
	bne	$3,$0,$L108
	li	$3,268369920			# 0xfff0000

	j	$L107
	sw	$0,4($16)

$L108:
	lw	$2,20($sp)
	ori	$3,$3,0xffff
	and	$2,$2,$3
	li	$3,-536870912			# 0xffffffffe0000000
	or	$2,$2,$3
	sw	$2,4($16)
$L107:
	sh	$0,8($16)
	lw	$2,20($sp)
	nop
	srl	$2,$2,28
	sh	$2,10($16)
	lw	$4,24($sp)
	nop
	andi	$2,$4,0x1ff
	sw	$2,12($16)
	srl	$2,$4,9
	andi	$2,$2,0xf
	sh	$2,20($16)
	srl	$3,$4,15
	andi	$3,$3,0x7
	sll	$2,$3,2
	addu	$2,$2,$3
	sh	$2,16($16)
	srl	$2,$4,14
	andi	$2,$2,0x1
	sh	$2,18($16)
	srl	$4,$4,13
	andi	$4,$4,0x1
	li	$2,-1			# 0xffffffffffffffff
	movn	$2,$0,$4		#RLX4181/RLX4281:conditional move  
$L104:
	lw	$31,52($sp)
	lw	$16,48($sp)
	j	$31
	addiu	$sp,$sp,56

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicIpMulticastTable
	.section	.text.rtl8651_setAsicMulticastEnable,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicMulticastEnable
	.ent	rtl8651_setAsicMulticastEnable
	.type	rtl8651_setAsicMulticastEnable, @function
rtl8651_setAsicMulticastEnable:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	li	$2,1			# 0x1
	bne	$4,$2,$L112
	li	$3,-1149239296			# 0xffffffffbb800000

	ori	$3,$3,0x4428
	lw	$2,0($3)
	nop
	ori	$2,$2,0x8
	sw	$2,0($3)
	j	$31
	move	$2,$0

$L112:
	li	$2,-1149239296			# 0xffffffffbb800000
	ori	$2,$2,0x4428
	lw	$3,0($2)
	li	$4,-9			# 0xfffffffffffffff7
	and	$3,$3,$4
	sw	$3,0($2)
	move	$2,$0
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicMulticastEnable
	.section	.text.rtl8651_getAsicMulticastEnable,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicMulticastEnable
	.ent	rtl8651_getAsicMulticastEnable
	.type	rtl8651_getAsicMulticastEnable, @function
rtl8651_getAsicMulticastEnable:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	beq	$4,$0,$L117
	li	$2,-1			# 0xffffffffffffffff

	li	$2,-1149239296			# 0xffffffffbb800000
	ori	$2,$2,0x4428
	lw	$2,0($2)
	nop
	srl	$2,$2,3
	andi	$2,$2,0x1
	sw	$2,0($4)
	move	$2,$0
$L117:
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicMulticastEnable
	.section	.text.rtl8651_setAsicMulticastPortInternal,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicMulticastPortInternal
	.ent	rtl8651_setAsicMulticastPortInternal
	.type	rtl8651_setAsicMulticastPortInternal, @function
rtl8651_setAsicMulticastPortInternal:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	sll	$3,$5,24
	sra	$3,$3,24
	lui	$2,%hi(rtl8651_totalExtPortNum)
	lw	$2,%lo(rtl8651_totalExtPortNum)($2)
	nop
	addiu	$2,$2,6
	sltu	$2,$4,$2
	beq	$2,$0,$L118
	li	$6,-1			# 0xffffffffffffffff

	li	$2,1			# 0x1
	bne	$3,$2,$L120
	sll	$3,$3,$4

	li	$2,-1149239296			# 0xffffffffbb800000
	ori	$2,$2,0x4418
	andi	$3,$3,0x1ff
	sll	$3,$3,5
	lw	$4,0($2)
	nop
	or	$3,$3,$4
	sw	$3,0($2)
	j	$L118
	move	$6,$0

$L120:
	li	$2,-1149239296			# 0xffffffffbb800000
	ori	$2,$2,0x4418
	li	$3,1			# 0x1
	sll	$3,$3,$4
	andi	$3,$3,0x1ff
	sll	$3,$3,5
	nor	$3,$0,$3
	lw	$4,0($2)
	nop
	and	$3,$3,$4
	sw	$3,0($2)
	move	$6,$0
$L118:
	j	$31
	move	$2,$6

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicMulticastPortInternal
	.section	.text.rtl8651_getAsicMulticastPortInternal,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicMulticastPortInternal
	.ent	rtl8651_getAsicMulticastPortInternal
	.type	rtl8651_getAsicMulticastPortInternal, @function
rtl8651_getAsicMulticastPortInternal:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	beq	$5,$0,$L122
	li	$3,-1			# 0xffffffffffffffff

	lui	$2,%hi(rtl8651_totalExtPortNum)
	lw	$2,%lo(rtl8651_totalExtPortNum)($2)
	nop
	addiu	$2,$2,6
	sltu	$2,$4,$2
	beq	$2,$0,$L122
	li	$6,1			# 0x1

	sll	$2,$6,$4
	andi	$2,$2,0x1ff
	sll	$2,$2,5
	li	$3,-1149239296			# 0xffffffffbb800000
	ori	$3,$3,0x4418
	lw	$3,0($3)
	nop
	and	$2,$2,$3
	beq	$2,$0,$L125
	nop

	j	$L126
	sb	$6,0($5)

$L125:
	sb	$0,0($5)
$L126:
	move	$3,$0
$L122:
	j	$31
	move	$2,$3

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicMulticastPortInternal
	.section	.text.rtl8651_setAsicMulticastMTU,"ax",@progbits
	.align	2
	.globl	rtl8651_setAsicMulticastMTU
	.ent	rtl8651_setAsicMulticastMTU
	.type	rtl8651_setAsicMulticastMTU, @function
rtl8651_setAsicMulticastMTU:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	move	$5,$4
	li	$2,-16384			# 0xffffffffffffc000
	and	$2,$4,$2
	bne	$2,$0,$L127
	li	$3,-1			# 0xffffffffffffffff

	li	$4,-1149239296			# 0xffffffffbb800000
	ori	$4,$4,0x440c
	lw	$2,0($4)
	li	$3,-16384			# 0xffffffffffffc000
	and	$2,$2,$3
	andi	$3,$5,0x3fff
	or	$2,$2,$3
	sw	$2,0($4)
	move	$3,$0
$L127:
	j	$31
	move	$2,$3

	.set	macro
	.set	reorder
	.end	rtl8651_setAsicMulticastMTU
	.section	.text.rtl8651_getAsicMulticastMTU,"ax",@progbits
	.align	2
	.globl	rtl8651_getAsicMulticastMTU
	.ent	rtl8651_getAsicMulticastMTU
	.type	rtl8651_getAsicMulticastMTU, @function
rtl8651_getAsicMulticastMTU:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	beq	$4,$0,$L132
	li	$2,-1			# 0xffffffffffffffff

	li	$2,-1149239296			# 0xffffffffbb800000
	ori	$2,$2,0x440c
	lw	$2,0($2)
	nop
	andi	$2,$2,0x3fff
	sw	$2,0($4)
	move	$2,$0
$L132:
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	rtl8651_getAsicMulticastMTU
	.section	.text.rtl865x_setAsicMulticastAging,"ax",@progbits
	.align	2
	.globl	rtl865x_setAsicMulticastAging
	.ent	rtl865x_setAsicMulticastAging
	.type	rtl865x_setAsicMulticastAging, @function
rtl865x_setAsicMulticastAging:
	.set	nomips16
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	li	$2,1			# 0x1
	bne	$4,$2,$L134
	li	$3,-1149239296			# 0xffffffffbb800000

	li	$2,-1149239296			# 0xffffffffbb800000
	ori	$2,$2,0x4400
	lw	$3,0($2)
	li	$4,-9			# 0xfffffffffffffff7
	and	$3,$3,$4
	sw	$3,0($2)
	j	$31
	move	$2,$0

$L134:
	ori	$3,$3,0x4400
	lw	$2,0($3)
	nop
	ori	$2,$2,0x8
	sw	$2,0($3)
	move	$2,$0
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	rtl865x_setAsicMulticastAging
	.section	.text.rtl865x_initAsicL3,"ax",@progbits
	.align	2
	.globl	rtl865x_initAsicL3
	.ent	rtl865x_initAsicL3
	.type	rtl865x_initAsicL3, @function
rtl865x_initAsicL3:
	.set	nomips16
	.frame	$sp,112,$31		# vars= 80, regs= 3/0, args= 16, gp= 0
	.mask	0x80030000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-112
	sw	$31,104($sp)
	sw	$17,100($sp)
	sw	$16,96($sp)
	jal	rtl865x_getAsicFun
	addiu	$4,$sp,88

	lw	$2,88($sp)
	nop
	andi	$2,$2,0x2
	beq	$2,$0,$L137
	li	$3,-1			# 0xffffffffffffffff

	j	$L138
	li	$4,5			# 0x5

$L146:
	j	$L137
	li	$3,-1			# 0xffffffffffffffff

$L138:
	jal	rtl8651_clearSpecifiedAsicTable
	li	$5,16			# 0x10

	li	$4,1			# 0x1
	jal	rtl8651_clearSpecifiedAsicTable
	li	$5,512			# 0x200

	li	$4,11			# 0xb
	jal	rtl8651_clearSpecifiedAsicTable
	li	$5,8			# 0x8

	li	$4,13			# 0xd
	jal	rtl8651_clearSpecifiedAsicTable
	li	$5,32			# 0x20

	li	$4,2			# 0x2
	jal	rtl8651_clearSpecifiedAsicTable
	li	$5,8			# 0x8

	li	$4,3			# 0x3
	jal	rtl8651_clearSpecifiedAsicTable
	li	$5,128			# 0x80

	jal	rtl8651_setAsicMulticastEnable
	li	$4,1			# 0x1

	li	$16,-1149239296			# 0xffffffffbb800000
	ori	$16,$16,0x440c
	lw	$2,0($16)
	li	$3,262144			# 0x40000
	or	$2,$2,$3
	sw	$2,0($16)
	jal	rtl8651_setAsicMulticastMTU
	li	$4,1522			# 0x5f2

	lw	$2,0($16)
	li	$3,65536			# 0x10000
	or	$2,$2,$3
	sw	$2,0($16)
	lui	$2,%hi(rtl8651_totalExtPortNum)
	lw	$2,%lo(rtl8651_totalExtPortNum)($2)
	nop
	addiu	$2,$2,6
	blez	$2,$L145
	move	$16,$0

	lui	$17,%hi(rtl8651_totalExtPortNum)
	move	$4,$16
$L147:
	jal	rtl8651_setAsicMulticastPortInternal
	li	$5,1			# 0x1

	bne	$2,$0,$L146
	addiu	$16,$16,1

	lw	$2,%lo(rtl8651_totalExtPortNum)($17)
	nop
	addiu	$2,$2,6
	slt	$2,$16,$2
	bne	$2,$0,$L147
	move	$4,$16

$L145:
	addiu	$4,$sp,16
	move	$5,$0
	jal	memset
	li	$6,68			# 0x44

	li	$2,4			# 0x4
	sw	$2,24($sp)
	sw	$0,16($sp)
	sw	$0,20($sp)
	sw	$0,28($sp)
	lw	$3,76($sp)
	li	$2,2147418112			# 0x7fff0000
	ori	$2,$2,0xffff
	and	$3,$3,$2
	sw	$3,76($sp)
	li	$4,7			# 0x7
	jal	rtl8651_setAsicRouting
	addiu	$5,$sp,16

	move	$3,$0
$L137:
	move	$2,$3
	lw	$31,104($sp)
	lw	$17,100($sp)
	lw	$16,96($sp)
	j	$31
	addiu	$sp,$sp,112

	.set	macro
	.set	reorder
	.end	rtl865x_initAsicL3
	.ident	"GCC: (GNU) 3.4.6-1.3.6"
