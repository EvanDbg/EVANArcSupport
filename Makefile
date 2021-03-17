export ARHCS = arm64 arm64e
export TARGET = iphone:clang:latest:11.0
export DEBUG = 0
export FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = EVANArcSupport

EVANArcSupport_FILES = EVANArcSupport.xm
EVANArcSupport_PUBLIC_HEADERS = EVANArcSupport.h
EVANArcSupport_INSTALL_PATH = /Library/Frameworks
EVANArcSupport_EXTRA_FRAMEWORKS = CydiaSubstrate
EVANArcSupport_USE_SUBSTRATE = 1
EVANArcSupport_CFLAGS = -fobjc-arc -Wno-arc-performSelector-leaks

include $(THEOS_MAKE_PATH)/framework.mk
