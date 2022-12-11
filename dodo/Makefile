ARCHS = arm64 arm64e
TARGET := iphone:clang:15.5:14.4

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = dodo

dodo_LIBRARIES = gscommon gsutils
dodo_EXTRA_FRAMEWORKS = AltList
dodo_FILES = $(shell find Sources/dodo -name '*.swift') $(shell find Sources/dodoC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
dodo_SWIFTFLAGS = -ISources/dodoC/include
dodo_INSTALL_PATH = /Library/PreferenceBundles
dodo_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
