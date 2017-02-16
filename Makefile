FW_DEVICE_IP=10.236.36.152
TARGET := iphone::7.1:7.0
ARCHS := armv7 armv7s arm64
_THEOS_PLATFORM_DPKG_DEB=dpkg-deb
_THEOS_PLATFORM_DPKG_DEB_COMPRESSION=gzip

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SimulateTouch
SimulateTouch_FILES = SimulateTouch.mm
SimulateTouch_PRIVATE_FRAMEWORKS = GraphicsServices
SimulateTouch_FRAMEWORKS = IOKit
SimulateTouch_LDFLAGS = -lsubstrate -lrocketbootstrap

LIBRARY_NAME = libsimulatetouch
libsimulatetouch_FILES = STLibrary.mm
libsimulatetouch_LDFLAGS = -lrocketbootstrap
libsimulatetouch_INSTALL_PATH = /usr/lib/
libsimulatetouch_FRAMEWORKS = UIKit CoreGraphics

TOOL_NAME = stouch
stouch_FILES = main.mm
stouch_FRAMEWORKS = UIKit
stouch_INSTALL_PATH = /usr/local/NETaskManager/
stouch_LDFLAGS = -lsimulatetouch

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/tool.mk

after-install::
	install.exec "killall -9 backboardd"