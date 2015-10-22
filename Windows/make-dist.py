#!/usr/bin/env python
#
#    Copyright (c) 2015 Oliver Lau <ola@ct.de>, Heise Medien GmbH & Co. KG
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import struct, hashlib, string, sys, shutil, os, array
from subprocess import *

SRCDIR="..\\..\\Qt-SESAM"
CHROME_EXT_NAME="SESAM2Chrome"
CHROME_EXT_DIR="D:\\Workspace\\Qt-SESAM\\SESAM2Chrome\\extension"
DESTDIR="QtSESAM-portable"
QTDIR="D:\\Qt\\5.5\\msvc2013\\bin"
BUILDDIR="..\\..\\Qt-SESAM-Desktop_Qt_5_5_0_MSVC2013_32bit-Release\\Qt-SESAM\\release"
PATH_TO_NSIS="D:\\Developer\NSIS\\nsis.exe"
PATH_TO_7ZIP="C:\\Program Files\\7-Zip\\7z.exe"
INSTALLER_GLOB="Qt-SESAM-*-setup.exe"


def get_pub_key_from_crx(crx_file):
    with open(crx_file, 'rb') as f:
        data = f.read()
    header = struct.unpack('<4sIII', data[:16])
    pubkey = struct.unpack('<%ds' % header[2], data[16:16+header[2]])[0]
    return pubkey

def get_extension_id(crx_file):
    pubkey = get_pub_key_from_crx(crx_file)
    digest = hashlib.sha256(pubkey).hexdigest()

    trans = string.maketrans('0123456789abcdef', string.ascii_lowercase[:16])
    return string.translate(digest[:32], trans)


def rm(fn):
    if os.access(fn, os.W_OK):
        os.remove(fn)

def main():
    shutil.rmtree(DESTDIR, ignore_errors=True)
    rm(DESTDIR + ".zip")
    rm(DESTDIR + ".zip.txt")
    rm(INSTALLER_GLOB)
    rm(INSTALLER_GLOB + ".txt")
    rm(CHROME_EXT_NAME + ".crx")
    rm(CHROME_EXT_NAME + ".zip")

    print "Packing Chrome extension ..."
    call([PATH_TO_7ZIP, "a", "-mx=9", "-mmt=on", CHROME_EXT_NAME + ".zip", CHROME_EXT_DIR + "\\*"])

    # https://grack.com/blog/2009/11/09/packing-chrome-extensions-in-python/
    # Sign the zip file with the private key in PEM format
    signature = Popen(["openssl", "sha1", "-sign", CHROME_EXT_NAME + ".pem", CHROME_EXT_NAME + ".zip"], stdout=PIPE).stdout.read();

    # Convert the PEM key to DER (and extract the public form) for inclusion in the CRX header
    derkey = Popen(["openssl", "rsa", "-pubout", "-inform", "PEM", "-outform", "DER", "-in", CHROME_EXT_NAME + ".pem"], stdout=PIPE).stdout.read();

    out = open(CHROME_EXT_NAME + ".crx", "wb");
    out.write("Cr24")  # Extension file magic number
    header = array.array("l");
    header.append(2); # Version 2
    header.append(len(derkey));
    header.append(len(signature));
    header.tofile(out);
    out.write(derkey)
    out.write(signature)
    out.write(open(CHROME_EXT_NAME + ".zip", "rb").read())

    ext_id = get_extension_id(CHROME_EXT_NAME + ".crx")
    print "  id = " + ext_id

    print "Making directories ..."
    if not os.path.exists(DESTDIR): os.mkdir(DESTDIR)
    if not os.path.exists(DESTDIR + "\\platforms"): os.mkdir(DESTDIR + "\\platforms")
    # if not os.path.exists(DESTDIR + "\\resources"): os.mkdir(DESTDIR + "\\resources")
    # if not os.path.exists(DESTDIR + "\\resources\\images"): os.mkdir(DESTDIR + "\\resources\\images")

    print "Copying files ..."
    shutil.copy(SRCDIR + "\\LICENSE", DESTDIR)
    shutil.copy(SRCDIR + "\\LIESMICH.txt", DESTDIR)
    shutil.copy("x86\\ssleay32.dll", DESTDIR)
    shutil.copy("x86\\libeay32.dll", DESTDIR)
    shutil.copy("x86\\msvcp120.dll", DESTDIR)
    shutil.copy("x86\\msvcr120.dll", DESTDIR)
    shutil.copy(QTDIR + "\\Qt5Core.dll", DESTDIR)
    shutil.copy(QTDIR + "\\Qt5Gui.dll", DESTDIR)
    shutil.copy(QTDIR + "\\Qt5Widgets.dll", DESTDIR)
    shutil.copy(QTDIR + "\\Qt5Network.dll", DESTDIR)
    shutil.copy(QTDIR + "\\Qt5Concurrent.dll", DESTDIR)
    shutil.copy(QTDIR + "\\icudt54.dll", DESTDIR)
    shutil.copy(QTDIR + "\\icuin54.dll", DESTDIR)
    shutil.copy(QTDIR + "\\icuuc54.dll", DESTDIR)
    shutil.copy(QTDIR + "\\..\\plugins\\platforms\\qminimal.dll", DESTDIR + "\\platforms")
    shutil.copy(QTDIR + "\\..\\plugins\\platforms\\qwindows.dll", DESTDIR + "\\platforms")
    shutil.copy(BUILDDIR + "\\Qt-SESAM.exe", DESTDIR)
    shutil.copytree(SRCDIR + "\\Qt-SESAM\\resources\\images", DESTDIR + "\\resources\\images")


if __name__ == '__main__':
    main()

