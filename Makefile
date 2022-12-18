ARCHS = arm64 arm64e
THEOS_DEVICE_IP = localhost -p 2222
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang:15.5:14.4
PACKAGE_VERSION = 3.0.3


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Dodo

Dodo_LIBRARIES = gsutils gsweather
Dodo_PRIVATE_FRAMEWORKS = SpringBoard SpringBoardServices FrontBoard MediaRemote Weather
Dodo_FILES = $(shell find Sources/Dodo -name '*.swift') $(shell find Sources/DodoC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Dodo_SWIFTFLAGS = -ISources/DodoC/include
Dodo_CFLAGS = -fobjc-arc -ISources/DodoC/include

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dodo
include $(THEOS_MAKE_PATH)/aggregate.mk
