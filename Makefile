ROOTLESS ?= 0

ARCHS = arm64 arm64e
THEOS_DEVICE_IP = localhost -p 2222
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang:16.4:14.5
PACKAGE_VERSION = 4.0.7-b1

Dodo_SWIFTFLAGS = -ISources/DodoC/include

# Rootless / Rootful settings
ifeq ($(ROOTLESS),1)
	THEOS_PACKAGE_SCHEME = rootless
	# Control
	PKG_NAME_SUFFIX = (Rootless)
	Dodo_SWIFTFLAGS += -DROOTLESS
else
	WEATHER_DEPENDENCY = , com.peterdev.libpddokdo
	Dodo_LIBRARIES = pddokdo
	Dodo_SWIFTFLAGS += -DROOTFUL
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Dodo

Dodo_PRIVATE_FRAMEWORKS = SpringBoard SpringBoardServices SpringBoardFoundation MediaRemote MobileTimer SpringBoardUI CoverSheet
Dodo_FILES = $(shell find Sources/Dodo -name '*.swift') $(shell find Sources/DodoC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Dodo_CFLAGS = -fobjc-arc -ISources/DodoC/include

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dodo
include $(THEOS_MAKE_PATH)/aggregate.mk

before-package::
	# Append values to control file
	$(ECHO_NOTHING)sed -i '' \
		-e 's/\$${PKG_NAME_SUFFIX}/$(PKG_NAME_SUFFIX)/g' \
		-e 's/\$${WEATHER_DEPENDENCY}/$(WEATHER_DEPENDENCY)/g' \
		$(THEOS_STAGING_DIR)/DEBIAN/control$(ECHO_END)
