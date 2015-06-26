# 15_ping_interfaces_ip_addresses.sh
# verify that the interfaces defined are pingable
Log "Doing the ping tests"
i=0
for j in ${SOURCE_IP[@]}
do
    # SOURCE_IP could be empty if interface is in standby mode
    if [[ "${SOURCE_LTYPE[$i]}" = "standby" ]] ; then
	Ok "Interface ${SOURCE_LAN[$i]} (node $HOSTNAME) is in standby mode"
        continue
    fi

    # check if SOURCE_IP is an IP address and not a host name
    echo ${SOURCE_IP[$i]} | grep -q "." 
    if [[ $? -ne 0 ]]; then
        Warn "Cannot perform ping test from ${SOURCE_IP[$i]} (${SOURCE_LAN[$i]}) (no IP addr)"
    fi

    case $(PingViaInterface  ${SOURCE_IP[$i]} ${TARGET_IP[$i]}) in
       0) Ok "Ping test from ${SOURCE_IP[$i]} to ${TARGET_IP[$i]}" ;;
       1) Warn "Ping test from ${SOURCE_IP[$i]} to ${TARGET_IP[$i]}" ;;
       *) Failed "Ping test from ${SOURCE_IP[$i]} to ${TARGET_IP[$i]}" ;;
    esac
    i=$((i+1))
done
