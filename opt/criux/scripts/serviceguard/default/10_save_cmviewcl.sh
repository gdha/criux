# 10_save_cmviewcl.sh
$CMVIEWCL -v 2>/dev/null > "$TMP_DIR/cmviewcl.txt"
LogPrintIfError "Could not create $TMP_DIR/cmviewcl.txt"
