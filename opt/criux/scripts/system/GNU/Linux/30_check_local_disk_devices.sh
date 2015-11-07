# 30_check_local_disk_devices.sh

if has_binary lsblk ; then
    lsblk -io KNAME,TYPE,SIZE,MODEL > $TMP_DIR/lsblk.out
    if (( $? == 0 )) ; then
        Ok "Local disk devices active:"
    else
        Failed "Local disk devices active:"
    fi
    cat $TMP_DIR/lsblk.out >> "$OUTFILE"
fi
