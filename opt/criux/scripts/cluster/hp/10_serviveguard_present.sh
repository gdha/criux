# 10_sg_version_matrix.sh
# This script verifies the version of HP ServiveGuard and defines SERVICEGUARD_CLUSTER=1 is sg is present
# SG_VERSION= (empty as defined in default.conf)

case "$OS_VERSION" in
    11.11)         SG_VERSION=$( grep B3935DA $TMP_DIR/swlist.output| awk '{print $2}' ) ;;
    11.23|11.31)   SG_VERSION=$( grep T1905CA $TMP_DIR/swlist.output| awk '{print $2}' ) ;;
esac

if [[ ! -z "$SG_VERSION" ]]; then
    SERVICEGUARD_CLUSTER=1
    LogPrint "Found Serviceguard version $SG_VERSION"
    #Ok "HP Serviceguard version $SG_VERSION"  # Ok is a function
fi 

# we will not go any deeper in this workflow; we will kick off a sub-workflow serviceguard
# to investigate the cluster definitions and so on
