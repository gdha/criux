# 21_check_authorizedkeys.sh
# since we are root $HOME points to the home dir of root

if [[ ! -d $HOME/.ssh ]] ; then
    Warn "Secure Shell directory $HOME/.ssh not found"
    return
fi

if [[ ! -f "$HOME/.ssh/authorized_keys" ]] && [[ ! -f "$HOME/.ssh/authorized_keys2" ]]; then
    Warn "User $(whoami) has no .ssh/authorized_keys(2) in use"
    return
fi

grep -v -E '(sgsadm|root)' $HOME/.ssh/authorized_keys* > "$TMP_DIR/non-root-authorized_keys"
if [[ -s "$TMP_DIR/non-root-authorized_keys" ]]; then
    Warn "Found non-root keys in $HOME/.ssh/authorized_keys(2)"
    cat "$TMP_DIR/non-root-authorized_keys" >> "$OUTFILE"
else
    Ok "No non-root keys present in $HOME/.ssh/authorized_keys(2)"
fi
