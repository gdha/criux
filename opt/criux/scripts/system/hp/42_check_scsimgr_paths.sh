# 42_check_scsimgr_paths.sh

[[ ! -x /usr/sbin/scsimgr ]] && return   # if executable is not available we might be HP-UX 11.11
[[ "$OS_VERSION" = "11.23" ]] && return  # executable exists on HP-UX 11.23

LogPrint "Analyzing number of storage paths per SAN disk"
count=0
/usr/sbin/scsimgr -p get_attr  all_lun -a device_file -a pid -a total_path_cnt | grep -v -E '(pt|tape|-CM|DG|DH|DV|EG)' | \
while read LINE
do
    # /dev/rdisk/disk64:"OPEN-V          ":2
    Dev=$(echo "$LINE"| cut -d: -f1)
    amount=$(echo "$LINE"| cut -d: -f3)
    if (( amount > 1 )) ; then
        count=$((count + 1))
    else
	Warn "SAN device $Dev has only 1 path!"
    fi
done
Ok "There are $count SAN disks with multiple paths."
