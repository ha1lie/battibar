TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e
PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
# THEOS_DEVICE_IP = 192.168.1.28

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BattiBar

BattiBar_FILES = Tweak.xm UIColor+BattiBar.m
BattiBar_CFLAGS = -fobjc-arc
BattiBar_LIBRARIES = colorpicker
BattiBar_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += battibarprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
