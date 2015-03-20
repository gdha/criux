# 42_check_ext_bus.sh

[[ "$OS_VERSION" = "11.31" ]] && return  # external bus check is not required for 11.31

count=0
ioscan -kfnC ext_bus | grep -v -E '(NO_HW|UNCLAIMED)' | grep FCP | while read junk nr hwpath junk
do
    # ext_bus 168  0/0/2/1/0.3.160.128.0    fcparray CLAIMED     INTERFACE    FCP Array Interface
    # ext_bus   2  0/0/2/1/0.3.160.255.8    fcpdev   CLAIMED     INTERFACE    FCP Device Interface
    if (( nr > 254 )) ; then
        count=$((count + 1))
	Warn "External Bus on HW path $hwpath is higher then 254 ($nr)."
    fi
done
if (( count == 0 )) ; then
    Ok "Storage can be expanded as the external buses are within 254 limit."
else
    Warn "We found $count external buses that crossed the 254 limit!"
fi
