# 20_grab_SG_patch.sh

SG_PATCH=$( grep -i serviceguard $TMP_DIR/patches.output | grep PHSS | tail -1 | awk '{print $1}' )
[[ -z "$SG_PATCH" ]] && SG_PATCH="none"

