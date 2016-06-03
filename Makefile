# The install path of the project is set in the Xcode project, so
# 'make install' will put the build product @ $(HOME)/bin/Dictionary

# Xcode project setting:
# INSTALL_PATH = $(HOME)/bin

install:
	xcodebuild install DSTROOT=/
