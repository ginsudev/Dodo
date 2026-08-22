export THEOS_PLATFORM_SDK_ROOT=/Applications/Xcode-15.4.0.app/Contents/Developer
export PREFIX=$(THEOS_PLATFORM_SDK_ROOT)/Toolchains/XcodeDefault.xctoolchain/usr/bin/
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:16.5:14.5

ROOTLESS ?= 0
INSTALL_TARGET_PROCESSES = SpringBoard
export PACKAGE_VERSION = 5.0.1

ifeq ($(ROOTLESS),1)
	export THEOS_PACKAGE_SCHEME = rootless
endif

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Dodo
SUBPROJECTS += DodoPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
