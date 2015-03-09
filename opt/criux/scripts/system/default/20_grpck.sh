#21_grpck.sh
grpck  2>&1 | sed -e '/^$/d' > "$TMP_DIR/grpck"
if [[ -s "$TMP_DIR/grpck" ]]; then
    Warn "grpck returned the following output:"
    sed -e 's/\[/\(/g' -e 's/\]/\)/g' < "$TMP_DIR/grpck" >> "$OUTFILE"
else
    Ok "grpck - group file check is clean"
fi
