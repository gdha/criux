# 42_check_autopath.sh
[[ ! -x /sbin/autopath ]] && return  # executable not present (Secure Path software not present)
# HP-UX 11.31 does not have autopath, it is now built-in

/sbin/autopath | grep "Auto Discover" | grep -q ON
if (( $? = 0 )); then
    Ok "Secure Path Auto Discover is on."
else
    Warn "Secure Path Auto Discover is off!"
fi

/sbin/autopath display | grep "Load Balancing Policy" | uniq | cut -d: -f2- | \
    sed -e 's/^ //' > "$TMP_DIR/autopath.lbp"

count=$(wc -l "$TMP_DIR/autopath.lbp" | awk '{ print $1 }')

case $count in
    1) grep -q "Shortest Service Time" "$TMP_DIR/autopath.lbp"
       if (( $? = 0 )) ; then
           Ok "Multipath LB Policy \"Shortest Service Time\" is in use."
       else
           Failed "Multipath LB Policy setting is not set to \"Shortest Service Time\"."
	   Comment "Run: /sbin/autopath virtualdsf"
	   Comment "     /sbin/autopath virtualdsf clean"
	   Comment "     /sbin/autopath discover"
	   Comment "     /sbin/autopath display | grep -e /dev/dsk | awk '{print $1}' | while read ; do"
	   Comment "     /sbin/autopath set_lbpolicy SST $device"
	   Comment "     done"
       fi
       ;;
    *)  Warn "Multipath LB Policy settings should only have \"Shortest Service Time\"."
	Comment "We found the following settings:"
	Comment "$(cat $TMP_DIR/autopath.lbp)"
	;;
esac

