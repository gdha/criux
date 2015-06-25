# 14_check_interface_status.sh
# first do the SOURCE part or $HOSTNAME
i=0
for lan in ${SOURCE_LAN[@]}
do
    if [[ "${SOURCE_STAT[$i]}" = "up" ]]; then
	# $lan = ${SOURCE_LAN[$i]} with the correct $i
        Ok "Interface ${SOURCE_LAN[$i]} on node $HOSTNAME has status \"up\""
    else
        Failed "Interface ${SOURCE_LAN[$i]} on node $HOSTNAME has status \"${SOURCE_STAT[$i]}\""
    fi
    i=$((i+1))
done

for node in ${NODES[@]}
do
    i=0
    for lan in ${TARGET_LAN[@]}
    do
        # the $HOSTNAME is what call the SOURCE_, therefore, we skip it in this loop
        [[ "$node" = "$HOSTNAME" ]] && continue
        # this is the TARGET part
        if [[ "${TARGET_STAT[$i]}" = "up" ]]; then
            Ok "Interface ${TARGET_LAN[$i]} on node $node has status \"up\""
        else
            Failed "Interface ${TARGET_LAN[$i]} on node $node has status \"${TARGET_STAT[$i]}\""
        fi
        i=$((i+1))
    done
done
