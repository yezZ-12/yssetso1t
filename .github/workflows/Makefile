ARCHS = arm64
TARGET := iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SoftboxiOSMenu
SoftboxiOSMenu_FILES = Menu.mm
SoftboxiOSMenu_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
