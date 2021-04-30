TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

DEBUG = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 0arcfix zarcfix
ARCHS = arm64 arm64e
0arcfix_FILES = TweakLoadBeforeArc.x
0arcfix_CFLAGS = -fobjc-arc
zarcfix_FILES = TweakLoadAfterArc.x
zarcfix_CFLAGS = -fobjc-arc
zarcfix_LIBRARIES = activator
zarcfix_FRAMEWORKS = ReplayKit

include $(THEOS_MAKE_PATH)/tweak.mk
