# 15_verify_hostnames_in_hosts_file.sh
# It is prefered to define the IP addresses of teh SG interfaces in the local /etc/hosts file
i=0
for j in ${SOURCE_IP[@]}
do
    echo ${SOURCE_IP[$i]} | grep -q "." || continue   # no IP just try the next in the list
    grep -v ^\# /etc/hosts | grep -q ${SOURCE_IP[$i]}
    if [[ $? -eq 0 ]]; then
        Ok "IP address ${SOURCE_IP[$i]} is defined in /etc/hosts"
    else
        Warn "IP address ${SOURCE_IP[$i]} is not found in /etc/hosts"  
    fi
    i=$((i+1))
done
i=0
for j in ${TARGET_IP[@]}
do
    echo ${TARGET_IP[$i]} | grep -q "." || continue   # no IP just try the next in the list
    grep -v ^\# /etc/hosts | grep -q ${TARGET_IP[$i]}
    if [[ $? -eq 0 ]]; then
	Ok "IP address ${TARGET_IP[$i]} is defined in /etc/hosts"
    else
        Warn "IP address ${TARGET_IP[$i]} is not found in /etc/hosts"
    fi
    i=$((i+1))
done
