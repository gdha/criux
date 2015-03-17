# 42_check_scsimgr_lbp.sh
# check the load balancing policy (on HP-UX 11.31)

[[ ! -x /usr/sbin/scsimgr ]] && return   # if executable is not available we might be HP-UX 11.11
[[ "$OS_VERSION" = "11.23" ]] && return  # executable exists on HP-UX 11.23

/usr/sbin/scsimgr -p get_attr all_lun -a device_file -a load_bal_policy | grep disk |  cut -d: -f2 | \
    uniq > "$TMP_DIR/multipath.lbp"

count=$(wc -l "$TMP_DIR/multipath.lbp" | awk '{print $1}')

case $count in
    1) grep -q least_cmd_load "$TMP_DIR/multipath.lbp"
       if (( $? == 0 )) ; then
           Ok "Multipath LB Policy \"least_cmd_load\" is in use."
       else
           Failed "Multipath LB Policy setting is not set to \"least_cmd_load\"."
	   Comment "Run: scsimgr save_attr -N \"/escsi/esdisk\" -a load_bal_policy=least_cmd_load;"
       fi
       ;;
    *) Warn "Multipath LB Policy settings should only have \"least_cmd_load\"."
       Comment "We found the following settings:"
       Comment "$(cat $TMP_DIR/multipath.lbp)"
       ;;
esac

