# 40_check_autoboot.sh
# setboot | grep Autoboot
# Autoboot is ON (enabled)
setboot | grep Autoboot | grep -q ON
if (( $? > 0 )) ; then
    a=$(setboot | grep Primary | awk '{ print $4 }' | sed -e 's#/#\\/#g')
    LogPrint "Autoboot is not configured properly"
    Failed "Autoboot is not configured properly"
    Comment "Use 'setboot -p $a -b on'"
else
    Ok "Autoboot is configured properly"
fi

