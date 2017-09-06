cmd_drivers/net/rtl819x/rtl865x/../common/smi.o := rsdk-linux-gcc -Wp,-MD,drivers/net/rtl819x/rtl865x/../common/.smi.o.d  -nostdinc -isystem /home/rtlac/RTL3.4/rtl819x_3.4.6.5/toolchain/rsdk-1.5.10-5281-EB-2.6.30-0.9.30-m32ub-130429/bin/../lib/gcc/mips-linux-uclibc/4.4.7/include -Iinclude  -I/home/rtlac/RTL3.4/rtl819x_3.4.6.5/linux-2.6.30/arch/rlx/include -include include/linux/autoconf.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -fno-delete-null-pointer-checks -Os -ffunction-sections -mno-check-zero-division -mabi=32 -G 0 -mno-abicalls -fno-pic -pipe -msoft-float -ffreestanding -EB -UMIPSEB -U_MIPSEB -U__MIPSEB -U__MIPSEB__ -UMIPSEL -U_MIPSEL -U__MIPSEL -U__MIPSEL__ -DMIPSEB -D_MIPSEB -D__MIPSEB -D__MIPSEB__ -Iinclude/asm-rlx -Iarch/rlx/bsp/ -I/home/rtlac/RTL3.4/rtl819x_3.4.6.5/linux-2.6.30/arch/rlx/include/asm/mach-generic -D"VMLINUX_LOAD_ADDRESS=0x80000000" -Wframe-larger-than=1024 -fno-stack-protector -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm -O1 -DRTL_TBLDRV -D__linux__ -mno-memcpy -DRTL865X_OVER_KERNEL -DRTL865X_OVER_LINUX -Werror -I/home/rtlac/RTL3.4/rtl819x_3.4.6.5/linux-2.6.30/drivers/net/rtl819x/   -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(smi)"  -D"KBUILD_MODNAME=KBUILD_STR(smi)"  -c -o drivers/net/rtl819x/rtl865x/../common/smi.o drivers/net/rtl819x/rtl865x/../common/smi.c

deps_drivers/net/rtl819x/rtl865x/../common/smi.o := \
  drivers/net/rtl819x/rtl865x/../common/smi.c \
    $(wildcard include/config/rtl/8370/support.h) \
  drivers/net/rtl819x/rtl865x/../common/smi.h \
  drivers/net/rtl819x/rtl865x/../common/gpio.h \

drivers/net/rtl819x/rtl865x/../common/smi.o: $(deps_drivers/net/rtl819x/rtl865x/../common/smi.o)

$(deps_drivers/net/rtl819x/rtl865x/../common/smi.o):
