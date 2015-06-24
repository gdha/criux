# 10_serviceguard_present.sh

# This script verifies the version of HP ServiveGuard and defines SERVICEGUARD_CLUSTER=1 is sg is present
# SG_VERSION= (empty as defined in default.conf)

[[ ! -f "$TMP_DIR/rpm_qa.txt" ]] && return

# we could also use cmversion to achieve the same, but we are not sure the RPMs are installed yet :-)
SG_VERSION=$( grep -i serviceguard-A. "$TMP_DIR/rpm_qa.txt" | cut -d- -f2 )

if [[ ! -z "$SG_VERSION" ]]; then
    SERVICEGUARD_CLUSTER=1
    LogPrint "Found Serviceguard version $SG_VERSION"
    #Ok "HP Serviceguard version $SG_VERSION"  # Ok is a function
fi 

# we will not go any deeper in this workflow; we will kick off a sub-workflow serviceguard
# to investigate the cluster definitions and so on
