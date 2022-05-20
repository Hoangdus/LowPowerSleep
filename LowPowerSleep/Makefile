ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard
export DEBUG = 1
export FINALPACKAGE = 0

include /var/theos/makefiles/common.mk

TWEAK_NAME = LowPowerSleep

LowPowerSleep_FILES = LowPowerSleep.x
LowPowerSleep_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
