# 16_check_sgautostart.sh
# Use SGAUTOSTART variable to check AUTOSTART_CMCLD setting
AUTOSTART_CMCLD=$( grep ^AUTOSTART_CMCLD $SGAUTOSTART | cut -d= -f2 )
if (( $AUTOSTART_CMCLD == 0 )) ; then
    Warn "Variable AUTOSTART_CMCLD is 0 instead of 1 in $SGAUTOSTART"
else
    Ok "Variable AUTOSTART_CMCLD is 1 in $SGAUTOSTART"
fi
