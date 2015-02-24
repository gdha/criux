# 06_save_patches.sh
/usr/contrib/bin/show_patches > "$TMP_DIR/patches.output"
LogPrintIfError "Could not create $TMP_DIR/patches.output"
