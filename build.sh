# SET PACKAGE NAME
PKG="Juice"

## SOME OTHER VARIABLES(DON'T TOUCH PLEASE) ##
VERSION=$(grep "Version:" Build/DEBIAN/control | awk '{print $2}')

##################
## BEGIN SCRIPT ##
##################

echo "[] Please input a version number. The current version is "$VERSION"."
  read -p ">> " NEW_VERSION

echo "[] Setting new version number..."
  CONTROL=$(sed "s\Version.*\Version: `echo $NEW_VERSION`\g" Build/DEBIAN/control)
  echo "$CONTROL" > Build/DEBIAN/control
  
echo "[] Building "$PKG"..."
  dpkg -b Build

echo "Moving Build.deb to "$PKG"-"$NEW_VERSION".deb"
  mv Build.deb "$PKG"-"$NEW_VERSION".deb
  
echo "[] DONE"
