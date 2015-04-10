# 10_save_cmviewcl.sh
$CMVIEWCL -v 2>/dev/null > "$TMP_DIR/cmviewcl.txt"
LogPrintIfError "Could not create $TMP_DIR/cmviewcl.txt"
$CMVIEWCL -f line -v 2>/dev/null > "$TMP_DIR/cmviewcl.line"
LogPrintIfError "Could not create $TMP_DIR/cmviewcl.line due to -f line option not being supported."
