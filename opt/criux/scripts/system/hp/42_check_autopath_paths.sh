# 42_check_autopath_paths.sh
[[ ! -x /sbin/autopath ]] && return  # executable not present (Secure Path software not present)
# HP-UX 11.31 does not have autopath, it is now built-in

/sbin/autopath display all | grep  -E '(WWN|dev)' | sed -e 's/^ //' > "$TMP_DIR/autopath.paths"
### output looks like the following - we gonna check if we have multiple paths (and if there are failed paths present)
# Lun WWN               : 50_1-7DC9-4F40
# /dev/dsk/c84t14d5              Active
# /dev/dsk/c85t14d5              Active
# /dev/dsk/c166t14d5             Active
# /dev/dsk/c87t14d5              Active

i=0      # amount of paths
Active=0 # active paths
Failed=0 # failed paths
j=0      # verification block

LogPrint "Analyzing number of storage paths per SAN disk"
cat "$TMP_DIR/autopath.paths" | while read LINE
do
    echo "$LINE" | grep -q "Lun WWN"
    if (( $? == 0 )) ; then
        if (( j == 1 )) ; then
            if (( i < 2 )) ; then
                Warn "Disk WWN $WWN has only 1 path!"
	    else
		if (( Failed > 0 )) ; then
                    Warn "Disk WWN $WWN has $Failed failed path(s), and $Active active paths."
		else
                    Ok "Disk WWN $WWN has $Active active paths." 
		fi
	    fi
	fi
	j=1    # only check active/failed paths after first cycle
        i=0
	Active=0
	Failed=0
	WWN=$(echo $LINE | cut -d: -f2)
	continue
    fi
    echo "$LINE" | grep -q "^/dev"
    if (( $? == 0 )) ; then
        i=$((i + 1))
	echo "$LINE" | grep -q "Active" && Active=$((Active + 1))
	echo "$LINE" | grep -q "Failed" && Failed=$((Failed + 1))
    fi
done
