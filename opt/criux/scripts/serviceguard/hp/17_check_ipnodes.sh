# 17_check_ipnodes.sh
# To support IPv6 the gethostbyname API was replaced by the getaddrinfo API.
# On some platforms, the name services switch database that determines gethostbyname
# behavior (hosts) is different from that of getaddrinfo (ipnodes).
# On HP-UX modify /etc/nsswitch.conf so it now has both the following lines:
#  hosts: files [notfound=CONTINUE] dns
#  ipnodes: files [notfound=CONTINUE] dns

if [[ ! -f /etc/nsswitch.conf ]]; then
    error "Missing required /etc/nsswitch.conf file"
fi

grep -q "^ipnodes:" /etc/nsswitch.conf
if [[ $? -eq 0 ]]; then
    Ok "The /etc/nsswitch.conf contains ipnodes entry"
else
    Fail "The /etc/nsswitch.conf contains ipnodes entry"
fi
