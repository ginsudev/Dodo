ARCHS = arm64 arm64e
THEOS_DEVICE_IP = localhost -p 2222
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang:16.4:14.5
PACKAGE_VERSION = 4.0.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Dodo

Dodo_LIBRARIES = pddokdo
Dodo_PRIVATE_FRAMEWORKS = SpringBoard SpringBoardServices SpringBoardFoundation MediaRemote MobileTimer SpringBoardUI
Dodo_FILES = $(shell find Sources/Dodo -name '*.swift') $(shell find Sources/DodoC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Dodo_SWIFTFLAGS = -ISources/DodoC/include
Dodo_CFLAGS = -fobjc-arc -ISources/DodoC/include

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dodo
include $(THEOS_MAKE_PATH)/aggregate.mk
