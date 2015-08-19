# 15_resolve_ip_addresses.sh
# purpose is to verify if all IP addresses can be resolved

Log "Doing the IP resolving tests"
i=0
for j in ${SOURCE_IP[@]}
do
    # SOURCE_IP or TARGET_IP could be empty if interface is in standby mode
    [[ "${SOURCE_LTYPE[$i]}" = "standby" ]] && continue

    # check if SOURCE_IP can be resolved to a hostname FQDN
    echo ${SOURCE_IP[$i]} | grep -q "."
    if [[ $? -eq 0 ]]; then
        myhost=$(GetHostnameFromIP ${SOURCE_IP[$i]})
	if [[ "$myhost" = "UNKNOWN" ]]; then
	    Failed "Cannot resolve IP address ${SOURCE_IP[$i]}"
        else
            Ok "IP address ${SOURCE_IP[$i]} resolved into $myhost"
	fi
    fi
    i=$((i+1))
done

i=0
for j in ${TARGET_IP[@]}
do
    [[ "${TARGET_LTYPE[$i]}" = "standby" ]] && continue

    # check if TARGET_IP can be resolved to a hostname FQDN
    echo ${TARGET_IP[$i]} | grep -q "."
    if [[ $? -eq 0 ]]; then
        myhost=$(GetHostnameFromIP ${TARGET_IP[$i]})
	if [[ "$myhost" = "UNKNOWN" ]]; then
	    Failed "Cannot resolve IP address ${TARGET_IP[$i]}"
        else
            Ok "IP address ${TARGET_IP[$i]} resolved into $myhost"
	fi
    fi

    i=$((i+1))
done
