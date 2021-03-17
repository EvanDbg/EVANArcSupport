TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 0arcfix
ARCHS = arm64 arm64e
0arcfix_FILES = Tweak.x
0arcfix_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
