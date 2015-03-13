# 44_check_install_dates_patches.sh

# verify if we find any patches from 2014 or later
$SWLIST -l patch -a install_date | grep -v \# | grep PH | grep -q -E '(2014|2015|2016|2017|2018|2019)'
if [[ $? -eq 0 ]]; then
    # yep patches found
    Ok "We found recent patches installed"
else
    Warn "We found no patches dating of 2014 or later"
fi
