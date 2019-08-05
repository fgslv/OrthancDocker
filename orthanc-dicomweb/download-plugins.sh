#!/bin/bash

set -e
cd

URL=http://lsb.orthanc-server.com/

VERSION_DICOM_WEB=mainline


# Download binaries compiled with Linux Standard Base
wget ${URL}/plugin-dicom-web/${VERSION_DICOM_WEB}/UnitTests -O - > UnitTests-DicomWeb
wget ${URL}/plugin-dicom-web/${VERSION_DICOM_WEB}/libOrthancDicomWeb.so

chmod +x ./UnitTests-DicomWeb


# Run the unit tests
mkdir ~/UnitTests
cd ~/UnitTests
../UnitTests-DicomWeb

# Recover space used by the unit tests
cd
rm -rf ./UnitTests
rm -rf ./UnitTests-DicomWeb

# Move the binaries to their final location
mv ./libOrthancDicomWeb.so             /usr/local/share/orthanc/plugins/