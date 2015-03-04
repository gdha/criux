#05_check_hostname.sh
# check if our hostname is valid and recorded in /etc/hosts file

if [[ -z "$HOSTNAME" ]]; then
    PrintF 1 "==" "HOSTNAME variable has not been defined" ; NOK
else
    grep -q "$HOSTNAME" /etc/hosts
    if [[ $? -eq 0 ]]; then
        PrintF 1 "**" "HOSTNAME=$HOSTNAME defined in /etc/hosts" ; OK
    else
        PrintF 1 "==" "HOSTNAME=$HOSTNAME not found in /etc/hosts" ; NOK
    fi
fi

