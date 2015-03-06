#05_check_hostname.sh
# check if our hostname is valid and recorded in /etc/hosts file

if [[ -z "$HOSTNAME" ]]; then
    Failed "HOSTNAME variable has not been defined"
else
    grep -q "$HOSTNAME" /etc/hosts
    if [[ $? -eq 0 ]]; then
        Ok "Hostname $HOSTNAME is defined in /etc/hosts"
    else
        Failed "Hostname $HOSTNAME is not found in /etc/hosts"
    fi
fi

