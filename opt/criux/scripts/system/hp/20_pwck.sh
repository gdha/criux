# 20_pwck.sh
pwck  2>&1 | sed -e '/^$/d' > "$TMP_DIR/pwck"
if [[ -s "$TMP_DIR/pwck" ]]; then
    Warn "pwck returned the following output:"
    sed -e 's/\[/\(/g' -e 's/\]/\)/g' < "$TMP_DIR/pwck" >> "$OUTFILE"
else
    Ok "pwck - password file check is clean"
fi

