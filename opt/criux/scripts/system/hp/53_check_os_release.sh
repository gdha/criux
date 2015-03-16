# 43_check_os_release.sh
count=$( $SWLIST -l bundle -a os_release | grep HPUX11i | wc -l )
os_release=$( $SWLIST -l bundle -a os_release | grep HPUX11i | head -1 | awk '{print $1}' )
os_version=$( $SWLIST -l bundle -a os_release | grep HPUX11i | head -1 | awk '{print $2}' )
if (( $count > 1 )) ; then
    Warn "More then 1 os_release has been found with swlist"
    Comment  "Use 'swlist -l bundle -a os_release | grep HPUX11i' to review"
    Comment  "The fix is described in https://github.com/gdha/upgrade-ux/issues/32"
else
    Ok "The os_release $os_release $os_version is valid"
fi

