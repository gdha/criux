# 20_grab_SG_patch.sh
# we will verify the SG patch level on this node; later on we will check if this comply with other nodes
SG_PATCH=$( grep ^node $TMP_DIR/cmviewcl.line | grep $HOSTNAME | grep sg_patch | cut -d= -f2 )

[[ -z "$SG_PATCH" ]] && SG_PATCH="none"
