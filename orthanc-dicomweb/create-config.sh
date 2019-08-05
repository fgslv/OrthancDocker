#!/bin/bash

set -e
cd

# Create the various directories as in the official Debian package
mkdir /etc/orthanc
mkdir -p /var/lib/orthanc/db

# Auto-generate, then patch the main configuration file
CONFIG=/etc/orthanc/orthanc.json
Orthanc --config=$CONFIG

sed 's/\("Name" : \)".*"/\1"Orthanc inside Docker"/' -i $CONFIG
sed 's/\("IndexDirectory" : \)".*"/\1"\/var\/lib\/orthanc\/db"/' -i $CONFIG
sed 's/\("StorageDirectory" : \)".*"/\1"\/var\/lib\/orthanc\/db"/' -i $CONFIG
sed 's/\("Plugins" : \[\)/\1 \n    "\/usr\/share\/orthanc\/plugins", "\/usr\/local\/share\/orthanc\/plugins"/' -i $CONFIG
sed 's/"RemoteAccessAllowed" : false/"RemoteAccessAllowed" : true/' -i $CONFIG
sed 's/"AuthenticationEnabled" : false/"AuthenticationEnabled" : true/' -i $CONFIG
sed 's/\("RegisteredUsers" : {\)/\1\n    "orthanc" : "orthanc"/' -i $CONFIG

TEMP_FILE=/etc/orthanc/temp.json
head -n -2 $CONFIG > $TEMP_FILE
echo '  "MetricsEnabled" : true,' >> $TEMP_FILE
echo '' >> $TEMP_FILE
echo '  // The DicomWeb Configuration' >> $TEMP_FILE
echo '  "DicomWeb" : {' >> $TEMP_FILE
echo '    "Enable" : true,            // Whether DICOMweb support is enabled' >> $TEMP_FILE
echo '    "Root" : "/dicom-web/",     // Root URI of the DICOMweb API (for QIDO-RS, STOW-RS and WADO-RS)' >> $TEMP_FILE
echo '    "EnableWado" : true,        // Whether WADO-URI (previously known as WADO) support is enabled' >> $TEMP_FILE
echo '    "WadoRoot" : "/wado",       // Root URI of the WADO-URI (aka. WADO) API' >> $TEMP_FILE
echo '    "Ssl" : false,              // Whether HTTPS should be used for subsequent WADO-RS requests' >> $TEMP_FILE
echo '    "QidoCaseSensitive" : true, // For QIDO-RS server, whether search is case sensitive (since release 0.5)' >> $TEMP_FILE
# echo '    "Host" : "localhost"        // Hard-codes the name of the host for subsequent WADO-RS requests (deprecated)' >> $TEMP_FILE
echo '    "Servers" : {' >> $TEMP_FILE
echo '      "sample" : [ "http://192.168.99.100:8042/dicom-web/", "orthanc", "orthanc" ]' >> $TEMP_FILE
echo '    }' >> $TEMP_FILE
echo '  }' >> $TEMP_FILE
echo '}' >> $TEMP_FILE
mv $TEMP_FILE $CONFIG

sed 's/"\/usr\/share\/orthanc\/plugins", "\/usr\/local\/share\/orthanc\/plugins"/"\/usr\/local\/share\/orthanc\/plugins\/libOrthancDicomWeb.so"/' -i $CONFIG
