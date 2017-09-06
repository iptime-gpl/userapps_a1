$(info include $(notdir $(lastword $(MAKEFILE_LIST))))

check_defined = $(strip $(foreach 1,$1, $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = $(if $(value $1),,$(error Undefined $1$(if $2, ($2))))

TARGET:=$(shell cat $(USERAPPS_ROOT)/.product_name)
BEFORE_MAKE:=

.PHONY : DUMMY
DUMMY:

include $(USERAPPS_ROOT)/misc_config
include $(USERAPPS_ROOT)/rootfs/kernel_info.mk
include $(USERAPPS_ROOT)/rootfs/clones/$(TARGET)/clone_info.mk

$(call check_defined,USERAPPS_ROOT TARGET KERNEL_PATH)

ifeq ($(.DEFAULT_GOAL),DUMMY)
.DEFAULT_GOAL:=kernel
endif

MAKE_KERNEL:=__kernel__ __install__
.PHONY : kernel $(MAKE_KERNEL)
kernel: $(MAKE_KERNEL)


BEFORE_MAKE+=rtl_config
rtl_config:
	@cp $(USERAPPS_ROOT)/rootfs/clones/$(TARGET)/rtl_config $(KERNEL_PATH)/../.config
	$(MAKE) oldconfig -C $(KERNEL_PATH)/..
	@cp $(USERAPPS_ROOT)/rootfs/clones/$(TARGET)/rtl_config $(KERNEL_PATH)/../.config
	@cp $(KERNEL_PATH)/configs/$(KCONFIG_FILE_NAME) $(KERNEL_PATH)/.config
	$(MAKE) oldconfig -C $(KERNEL_PATH)/..

__kernel__: $(BEFORE_MAKE)
	@echo "make $(TARGET) linux"
	$(MAKE) linux -C $(KERNEL_PATH)/..

install: __install__

__install__:
	@mkdir -p $(USERAPPS_ROOT)/rootfs/prebuilt/kernel/$(dir $(KERNEL_FILENAME))
	@echo -e "\tupdate prebuilt/$(KERNEL_FILENAME)"
	@cp $(KERNEL_PATH)/rtkload/linux.bin $(USERAPPS_ROOT)/rootfs/prebuilt/kernel/$(KERNEL_FILENAME)
	@echo -e "\tupdate prebuilt/$(subst linux.bin,System.map,$(KERNEL_FILENAME))"
	@cp $(KERNEL_PATH)/System.map $(USERAPPS_ROOT)/rootfs/prebuilt/kernel/$(subst linux.bin,System.map,$(KERNEL_FILENAME))


