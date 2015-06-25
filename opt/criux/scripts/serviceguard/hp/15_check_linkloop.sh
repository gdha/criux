# 15_check_linkloop.sh
# use the linkloop command to test connectivity on Ethernet level (typically HP only)

Log "Starting the linkloop tests"
i=0
for lan in ${SOURCE_LAN[@]}
do
    # from SOURCE_PPA[] to TARGET_MAC[]
    /usr/sbin/linkloop -i ${SOURCE_PPA[$i]} -v ${TARGET_MAC[$i]} >&2
    if [[ $? -eq 0 ]]; then
        Ok "Linkloop test from $HOSTNAME (${SOURCE_LAN[$i]}) to remote ${TARGET_LAN[$i]} (mac ${TARGET_MAC[$i]})" 
    else
        Failed "Linkloop test from $HOSTNAME (${SOURCE_LAN[$i]}) to remote ${TARGET_LAN[$i]} (mac ${TARGET_MAC[$i]})" 
    fi
    i=$((i+1))
done
