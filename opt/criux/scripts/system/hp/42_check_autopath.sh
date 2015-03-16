# 42_check_autopath.sh
[[ ! -x /sbin/autopath ]] && return  # executable not present (Secure Path software not present)
# HP-UX 11.31 does not have autopath, it is now built-in

/sbin/autopath | grep "Auto Discover" | grep -q ON
if [[ $? -eq 0 ]]; then
    Ok "Secure Path Auto Discover is on."
else
    Warn "Secure Path Auto Discover is off!"
fi

count=$(/sbin/autopath | grep "Load Balancing Policy" | uniq | grep "Shortest Service Time" | wc -l)
if (( $count = 1 )); then
    Ok "Autopath load balacing policy is set to SST."
else
    Warn "Autopath load balacing policy is not everywhere defined as SST:"
    Comment "$(/sbin/autopath | grep "Load Balancing Policy" | uniq)"
fi
