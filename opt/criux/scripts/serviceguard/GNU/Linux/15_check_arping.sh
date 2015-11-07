# 15_check_arping.sh
# do the arping tests to the other side
if ! has_binary arping ; then
    return
fi

Log "Start arping tests"

i=0
for lan in ${SOURCE_LAN[@]}
do
    arping -c 2 -I ${SOURCE_LAN[$i]} -s ${SOURCE_IP[$i]} ${TARGET_IP[$i]} > $TMP_DIR/arping.result
    grep -q Unicast $TMP_DIR/arping.result
    if (( $? == 0 )) ; then
        Ok "Arping test from $HOSTNAME (${SOURCE_LAN[$i]}) to remote IP ${TARGET_IP[$i]}"
    else
        Failed "Arping test from $HOSTNAME (${SOURCE_LAN[$i]}) to remote IP ${TARGET_IP[$i]}"
    fi
    i=$((i+1))
done
