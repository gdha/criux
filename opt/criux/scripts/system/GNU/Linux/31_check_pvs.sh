# 31_check_pvs.sh

if has_binary pvs ; then
    pvs > $TMP_DIR/pvs.out 2>&1
    grep -q -i error $TMP_DIR/pvs.out
    if (( $? == 0 )) ;then
        Failed "Physical Volumes overview:"
    else
        Ok "Physical Volumes overview:"
    fi
    cat $TMP_DIR/pvs.out >> "$OUTFILE"
fi
