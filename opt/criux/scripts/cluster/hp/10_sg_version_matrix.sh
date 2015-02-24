# 10_sg_version_matrix.sh
# This script verifies the version of HP ServiveGuard and warn us if it is outdated
SG_VERSION=

case "$OS_VERSION" in
    11.11)         SG_VERSION=$( grep B3935DA $TMP_DIR/swlist.output| awk '{print $2}' ) ;;
    11.23|11.31)   SG_VERSION=$( grep T1905CA $TMP_DIR/swlist.output| awk '{print $2}' ) ;;
esac

[[ -z "$SG_VERSION" ]] && Error "HP Serviceguard seems not be installed"
