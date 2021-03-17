export ARHCS = arm64 arm64e
export TARGET = iphone:clang:latest:11.0
export DEBUG = 0
export FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = zArcSupport

zArcSupport_FILES = EVANArcSupport.xm
zArcSupport_PUBLIC_HEADERS = EVANArcSupport.h
zArcSupport_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries/
zArcSupport_EXTRA_FRAMEWORKS = CydiaSubstrate
zArcSupport_USE_SUBSTRATE = 1
zArcSupport_CFLAGS = -fobjc-arc -Wno-arc-performSelector-leaks

include $(THEOS_MAKE_PATH)/library.mk
