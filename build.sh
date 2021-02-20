# SET PACKAGE NAME
PKG="Juice"

## SOME OTHER VARIABLES(DON'T TOUCH PLEASE) ##
VERSION_STABLE=$(grep "Version:" Build/DEBIAN/control-stable | awk '{print $2}')
VERSION_BETA=$(grep "Version:" Build/DEBIAN/control-beta | awk '{print $2}')

##################
## BEGIN SCRIPT ##
##################

echo "=== "$PKG" Package Builder ==="
echo "[] Preparing..."
  rm *.deb &> /dev/null
  
if [[ "${1}" == "" ]]
then
  echo "[] Please input a version number. The current versions are '"$VERSION_STABLE"' and '"$VERSION_BETA"'."
  read -p ">> " NEW_VERSION
else
  export NEW_VERSION=${1}
fi

echo "[] Setting new version number..."
echo "$NEW_VERSION" | grep -q beta
  if [ $? != 0 ]; then
    CONTROL_FILE="control-stable"
    CONTROL=$(sed "s\Version.*\Version: `echo $NEW_VERSION`\g" Build/DEBIAN/"$CONTROL_FILE")
    echo "$CONTROL" > Build/DEBIAN/"$CONTROL_FILE"
    cp Build/DEBIAN/"$CONTROL_FILE" Build/DEBIAN/control
  else
    CONTROL_FILE="control-beta"
    CONTROL=$(sed "s\Version.*\Version: `echo $NEW_VERSION`\g" Build/DEBIAN/"$CONTROL_FILE")
    echo "$CONTROL" > Build/DEBIAN/"$CONTROL_FILE"
    cp Build/DEBIAN/"$CONTROL_FILE" Build/DEBIAN/control
  fi
  
echo "[] Building "$PKG"-"$NEW_VERSION"..."
  dpkg -b Build

echo "[] Moving Build.deb to "$PKG"-"$NEW_VERSION".deb"
  mv Build.deb "$PKG"-"$NEW_VERSION".deb
 
echo "[] Cleaning up..."
rm Build/DEBIAN/control

echo "[] DONE"
