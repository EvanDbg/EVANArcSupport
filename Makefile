TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

DEBUG = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 0arcfix zarcfix zarcactivator
ARCHS = arm64 arm64e

0arcfix_FILES = TweakLoadBeforeArc.x
0arcfix_CFLAGS = -fobjc-arc

zarcfix_FILES = TweakLoadAfterArc.x
zarcfix_CFLAGS = -fobjc-arc
zarcfix_FRAMEWORKS = ReplayKit

zarcactivator_FILES = TweakLoadAfterArcActSupport.x
zarcactivator_CFLAGS = -fobjc-arc
zarcactivator_LIBRARIES = activator

include $(THEOS_MAKE_PATH)/tweak.mk
