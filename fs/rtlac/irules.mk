include $(USERAPPS_ROOT)/config
-include $(USERAPPS_ROOT)/reg_config
include $(USERAPPS_ROOT)/rootfs/kernel_info.mk

include $(USERAPPS_ROOT)/mkdefs
include $(USERAPPS_ROOT)/rootfs/clone_info.mk
ifeq ($(USE_CUSTOM_VERSION),y)
include $(USERAPPS_ROOT)/rootfs/clones/$(TARGET)/version.mk
else
include $(USERAPPS_ROOT)/rootfs/version.mk
endif
include $(USERAPPS_ROOT)/lang_profile

LINUX_KERNEL_DIR=../../linux
ROOT_DIR:= root

ifeq ($(USE_RTL8196E_RTL34),y)
PLUGIN_DIR:=./plugin.gcc4181
else
ifeq ($(USE_RTL_SDK_3411B),y)
PLUGIN_DIR:=./plugin.rtl3411b
else
PLUGIN_DIR:=./plugin
endif
endif

$(TARGET): target.fs image

mkdevs:
	@sudo mknod -m664 $(ROOT_DIR)/dev/console c 4 64
	@sudo mknod -m664 $(ROOT_DIR)/dev/mtd b 31 0
	@sudo mknod -m664 $(ROOT_DIR)/dev/mtdblock1 b 31 1
	@sudo mknod -m664 $(ROOT_DIR)/dev/null c 1 3
	@sudo mknod -m664 $(ROOT_DIR)/dev/ppp c 108 0

	@sudo mknod -m664 $(ROOT_DIR)/dev/ptyp0 c 2 0
	@sudo mknod -m664 $(ROOT_DIR)/dev/ptyp1 c 2 1
	@sudo mknod -m664 $(ROOT_DIR)/dev/ptyp2 c 2 2
	@sudo mknod -m664 $(ROOT_DIR)/dev/ptyp3 c 2 3
	@sudo mknod -m664 $(ROOT_DIR)/dev/ptyp4 c 2 4

	@sudo mknod -m664 $(ROOT_DIR)/dev/ptmx c 5 2

	@sudo mknod -m664 $(ROOT_DIR)/dev/ttyS0 c 4 64
	@sudo mknod -m664 $(ROOT_DIR)/dev/ttyS1 c 4 65

	@sudo mknod -m664 $(ROOT_DIR)/dev/ttyp0 c 3 0
	@sudo mknod -m664 $(ROOT_DIR)/dev/ttyp1 c 3 1
	@sudo mknod -m664 $(ROOT_DIR)/dev/ttyp2 c 3 2
	@sudo mknod -m664 $(ROOT_DIR)/dev/ttyp3 c 3 3
	@sudo mknod -m664 $(ROOT_DIR)/dev/ttyp4 c 3 4
	@sudo mknod -m664 $(ROOT_DIR)/dev/urandom c 1 9

	@sudo mknod -m664 $(ROOT_DIR)/dev/loop0 b 7 0

	@sudo mknod -m664 $(ROOT_DIR)/dev/ram b 1 1
	@sudo mknod -m664 $(ROOT_DIR)/dev/ram0 b 1 0
	@sudo mknod -m664 $(ROOT_DIR)/dev/ram1 b 1 1
	@sudo mknod -m664 $(ROOT_DIR)/dev/ram2 b 1 2
	@sudo mknod -m664 $(ROOT_DIR)/dev/ram3 b 1 3

ifeq ($(USE_ROUTER_NAS),y)
	@sudo mknod -m664 $(ROOT_DIR)/dev/fuse c 10 229
	@mkdir -p $(ROOT_DIR)/dev/misc
	@sudo mknod -m664 $(ROOT_DIR)/dev/misc/fuse c 10 229

	@sudo mknod -m664 $(ROOT_DIR)/dev/sda b 8 0
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda1 b 8 1
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda2 b 8 2
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda3 b 8 3
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda4 b 8 4
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda5 b 8 5
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda6 b 8 6
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda7 b 8 7
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda8 b 8 8
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda9 b 8 9
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda10 b 8 10
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda11 b 8 11
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda12 b 8 12
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda13 b 8 13
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda14 b 8 14
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda15 b 8 15
	@sudo mknod -m664 $(ROOT_DIR)/dev/sda16 b 8 16
ifeq ($(USE_CUPS),y)
	@mkdir $(ROOT_DIR)/dev/usb
	@chmod 777 $(ROOT_DIR)/dev/usb
	@sudo mknod -m666 $(ROOT_DIR)/dev/usb/lp0 c 180 0
endif
endif
	@sudo mknod -m664 $(ROOT_DIR)/dev/rtl865x c 59 16

install_lib_for_wireless:
ifeq ($(USE_WIRELESS_TOOLS),y)
ifeq ($(USE_RTL_SDK_3411B), y)
ifneq ($(WIRELESS_TOOLS_DIR),)
	@cp -rP $(USERAPPS_ROOT)/$(WIRELESS_TOOLS_DIR)/libiw.so.29 $(ROOT_DIR)/lib
else
	@cp -rP $(USERAPPS_ROOT)/wireless_tools/libiw.so.29 $(ROOT_DIR)/lib
endif
endif
endif
	@echo "Installed Wireless lib"

post_targetfs: mkdevs install_lib_for_wireless
	@echo -e "\t--->Post processing..."
	ln -sf /sbin/rc $(ROOT_DIR)/bin/flash
	@rm -rf `find ./$(ROOT_DIR) -name 'CVS'`


ROOTFS_IMG=rootfs.lzma
CHIPSET_APP_INSTALL_DIR:=rtl_app

ifeq ($(SDK_VER),2.5)
IPTABLES_BIN_PATH:=$(USERAPPS_ROOT)/iptables-1.4.4.rtlwl2
else
IPTABLES_BIN_PATH:=$(IPTABLES_PATH)
IPTABLES_BINS:=iptables
ifeq ($(findstring iptables-1.4.10, $(IPTABLES_BIN_PATH)), iptables-1.4.10)
IPTABLES_LIB_PATH:=$(IPTABLES_PATH)/.libs
IPTABLES_LIBS:=libxtables.so libxtables.so.5 libxtables.so.5.0.0
IPTABLES_LIB_PATH2:=$(IPTABLES_PATH)/libiptc/.libs
IPTABLES_LIBS2:=libip4tc.so.0
endif
endif
IPTABLES_BINS:=iptables

ifeq ($(SDK_VER),2.5)
IGMP_BINARY_PATH:=igmpproxy.rtl2.5/igmpproxy
else
ifeq ($(SDK_VER),3.4.11b)
ifneq ($(USE_RTL_8309M),y)
IGMP_BINARY_PATH:=igmpproxy.rtl3.4.11b/igmpproxy
endif
else
IGMP_BINARY_PATH:=igmpproxy.rtl3.4/igmpproxy
endif
endif

TNTFS_MODULE_PATH:=$(TNTFS_MODULE)
STRIP_OPTION:=
LDCONFIG_CMD:=

ifeq ($(CLIB_DIR),)
ifeq ($(USE_RTL8196E_RTL34),y)
CLIB_DIR:=fs/lib/rtl8196e
else
ifeq ($(USE_RTL_SDK_3465),y)
CLIB_DIR:=fs/lib/rtl8197d.3.4.6.5
else
CLIB_DIR:=fs/lib/rtl8197d
endif
endif
endif

ifeq ($(COMP),xz)
MAKE_FS_BIANRY_CMD:=./mksquashfs.4.3 $(ROOT_DIR) $(ROOTFS_IMG) -comp xz -all-root
else
MAKE_FS_BIANRY_CMD:=./mksquashfs $(ROOT_DIR) $(ROOTFS_IMG) -comp lzma -always-use-fragments -all-root
endif

include $(USERAPPS_ROOT)/mkscripts/target.mk



# Image Section 
ifeq ($(DRAM_SIZE_POSTFIX),)
BOOT_SRC_IMG:=clones/$(TARGET)/boot
else
BOOT_SRC_IMG:=clones/$(TARGET)/boot.$(DRAM_SIZE_POSTFIX)
endif
BOOT_OUT_IMG:=clones/$(TARGET)/xboot.bin

KERNEL:= $(KERNEL_FILENAME)

FIRMWARE_NAME:=a1_ml_10_022
PRE_FIRMWARE_NAME:=a1_kr_10_022

ifeq ($(MAX_BOOT_SIZE),)
MAX_BOOT_SIZE:=10000
endif
ifeq ($(START_FIRM_OFFSET),)
START_FIRM_OFFSET:=20000
endif


image:
	@cp $(BOOT_SRC_IMG) ./boot.tmp.bin
ifneq ($(USE_FACTORY_SECTION),y)
	@./addpad ./boot.tmp.bin 0x6000 0xff
	@cat clones/$(TARGET)/hwparam.bin >> ./boot.tmp.bin
endif
	@./makeboot -d 1 -p $(PRODUCT_ID) -u 0 -f $(MAX_BOOT_SIZE) -v 1.0 -b ./boot.tmp.bin -s $(SYSPARMS_MINUS_OFFSET) -i $(BOOT_DEFAULT_IP) -o $(BOOT_OUT_IMG) -j $(RANDOM_PROTECT_IV) -V

ifeq ($(USE_FACTORY_SECTION),y)
	@cat $(BOOT_OUT_IMG) clones/$(TARGET)/hwparam.bin > clones/$(TARGET)/xboot.bin.tmp
#	@mv clones/$(TARGET)/xboot.bin.tmp $(BOOT_OUT_IMG)
else
	@cp $(BOOT_OUT_IMG) clones/$(TARGET)/xboot.bin.tmp
endif
ifneq ($(FIRMWARE_PRODUCT_ID),)
	@./makefirm -a $(FIRMWARE_PRODUCT_ID) -z 0 -l $(LANGUAGE_POSTFIX) -k prebuilt/kernel/$(KERNEL) -c $(ROOTFS_IMG) -f $(MAX_SIZE) -b clones/$(TARGET)/xboot.bin.tmp  -s $(START_FIRM_OFFSET) -v $(MAJOR_VER)_$(MINOR_VER) -p 2 -j $(RANDOM_PROTECT_IV) -n
else
	@./makefirm -a $(PRODUCT_ID) -z 0 -l $(LANGUAGE_POSTFIX) -k prebuilt/kernel/$(KERNEL) -c $(ROOTFS_IMG) -f $(MAX_SIZE) -b clones/$(TARGET)/xboot.bin.tmp  -s $(START_FIRM_OFFSET) -v $(MAJOR_VER)_$(MINOR_VER) -p 2 -j $(RANDOM_PROTECT_IV) -n
endif


ifeq ($(STRICT_REGULATION),none)
ifeq ($(FIRMWARE_AUTOUP_WORKAROUND),y)
	./autoup_wa $(PRE_FIRMWARE_NAME).bin $(FIRMWARE_AUTOUP_SAVE_OFFSET) $(START_FIRM_OFFSET) $(RANDOM_PROTECT_IV)
endif
endif

	@rm -rf tmp.bin
	@./firmware_size_check.sh $(PRE_FIRMWARE_NAME).bin $(MAX_SIZE)
	@echo "-------------------------------------------------------------------------"
	@mv $(PRE_FIRMWARE_NAME).bin binary/$(FIRMWARE_NAME).bin
	@echo -e "\n"

#ifneq ($(FIRMWARE_PRODUCT_ID),)
#	@mv binary/$(FIRMWARE_NAME).bin binary/$(FIRMWARE_PRODUCT_ID).$(FIRMWARE_NAME).bin
#	@echo -e "\tFirmware Name : binary / $(FIRMWARE_PRODUCT_ID).$(FIRMWARE_NAME).bin"
#else
	@echo -e "\tFirmware Name : binary / $(FIRMWARE_NAME).bin"
#endif

	@echo -e "\n\n-------------------------------------------------------------------------"
	@rm -rf ./boot.tmp.bin

clean:
	rm -rf save.fs.gz initrd.gz
