TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = BattiBarPrefs

BattiBarPrefs_FILES = BABRootListController.m BABLabeledSliderCell.m BABAnimatedTitleView.m
BattiBarPrefs_FRAMEWORKS = UIKit
BattiBarPrefs_PRIVATE_FRAMEWORKS = Preferences
BattiBarPrefs_INSTALL_PATH = /Library/PreferenceBundles
BattiBarPrefs_CFLAGS = -fobjc-arc
BattiBarPrefs_LIBRARIES = colorpicker
BattiBarPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
include $(THEOS_MAKE_PATH)/bundle.mk
