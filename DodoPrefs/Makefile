include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DodoPrefs

# Inherited from the root Makefile via `export PACKAGE_VERSION`.
PACKAGE_VERSION ?= 0.0.0

DodoPrefs_FRAMEWORKS = SwiftUI
DodoPrefs_FILES = $(shell find Sources/DodoPrefs -name '*.swift') $(shell find Sources/DodoPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
DodoPrefs_SWIFTFLAGS = -ISources/DodoPrefsC/include
DodoPrefs_INSTALL_PATH = /Library/PreferenceBundles
DodoPrefs_CFLAGS = -fobjc-arc -ISources/DodoPrefsC/include

include $(THEOS_MAKE_PATH)/bundle.mk

# Inject the package version into the staged bundle's Info.plist.
after-DodoPrefs-stage::
	@plutil -replace CFBundleShortVersionString -string "$(PACKAGE_VERSION)" \
		"$(THEOS_STAGING_DIR)/Library/PreferenceBundles/DodoPrefs.bundle/Info.plist"
	@plutil -replace CFBundleVersion -string "$(PACKAGE_VERSION)" \
		"$(THEOS_STAGING_DIR)/Library/PreferenceBundles/DodoPrefs.bundle/Info.plist"
