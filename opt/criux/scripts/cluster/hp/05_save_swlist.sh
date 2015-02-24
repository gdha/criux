# 05_save_swlist.sh
$SWLIST > "$TMP_DIR/swlist.output"
LogPrintIfError "Could not create the $TMP_DIR/swlist.output"
