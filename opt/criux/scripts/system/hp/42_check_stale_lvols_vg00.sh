# 42_check_stale_lvols_vg00.sh
# when we detect stale extends in logical volumes of VG00 then exit with an error (in upgrade mode)

rc=0
for lv in $( ls -1 /dev/vg00 | grep -v "^r" | grep -v group )
do
    i=$( /usr/sbin/lvdisplay -v /dev/vg00/$lv | grep stale | wc -l )
    if (( i > 0 )) ; then
        rc=$(( rc + 1 ))
        Warn "Stale extends detected in /dev/vg00/$lv"
    fi
done

if (( rc != 0 )) ; then
    Comment "Please correct /dev/vg00 first (stale lvols found)"
else
    Ok "No stale logical volumes found"
fi

