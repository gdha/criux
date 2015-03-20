# 43_check_crashconf.sh

grep ^CRASHCONF_ENABLED /etc/rc.config.d/crashconf | grep -q 0
if (( $? == 0 )) ;then
    Failed "Crashconf seems to be disabled (/etc/rc.config.d/crashconf)."
else
    Ok "Crashconf is enabled."
fi

# how to interprete that the amount of dump pages is enough?
