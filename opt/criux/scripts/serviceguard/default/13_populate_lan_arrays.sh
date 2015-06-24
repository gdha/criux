# 13_populate_lan_arrays.sh

# from the source system (this system or $HOSTNAME)
#          ~~~~~~
set -A SOURCE_LAN
i=0
grep "^node:${HOSTNAME}|interface" $TMP_DIR/cmviewcl.line | grep -v ip_address | grep name= | cut -d= -f2 | while read lan
do
    SOURCE_LAN[$i]="$lan"
    i=$((i+1))
done

set -A SOURCE_IP
set -A SOURCE_PPA
set -A SOURCE_STAT
set -A SOURCE_MAC
set -A SOURCE_LTYPE
i=0
for lan in ${SOURCE_LAN[@]}
do
    # we are still working for $HOSTNAME
    grep "^node:${HOSTNAME}|interface:${lan}" $TMP_DIR/cmviewcl.line | while read LINE
    do
        echo "$LINE" | grep -q status= && SOURCE_STAT[$i]=$(echo "$LINE" | grep status= | cut -d= -f2)
        echo "$LINE" | grep -q mac_address= && SOURCE_MAC[$i]="0x$(echo "$LINE" | grep mac_address | cut -d= -f2 | sed -e 's/://g')"
	echo "$LINE" | grep -q ppa= && SOURCE_PPA[$i]=$(echo "$LINE" | grep ppa= | cut -d= -f2 )
	echo "$LINE" | grep -q "|type=" && SOURCE_LTYPE[$i]=$(echo "$LINE" | grep "|type=" | cut -d= -f2 )
	echo "$LINE" | grep ip_address | grep -q name && SOURCE_IP[$i]=$(echo "$LINE" | grep ip_address | grep name | cut -d= -f2 )
    done
    i=$((i+1))
done

set -A TARGET_LAN
set -A TARGET_IP
set -A TARGET_PPA
set -A TARGET_STAT
set -A TARGET_LTYPE
set -A TARGET_MAC

for node in ${NODES[@]} 
do
    # we loop over the next NODES except this host ($HOSTNAME) => our target node to test (we only do 1)
    # because we have no other clue to deal with more then 2 nodes
    [[ "$node" = "$HOSTNAME" ]] && continue

    i=0
    grep "^node:${node}|interface" $TMP_DIR/cmviewcl.line | grep -v ip_address | grep name= | cut -d= -f2 | while read lan
    do
        TARGET_LAN[$i]="$lan"
	i=$((i+1))
    done
    i=0
    for lan in ${TARGET_LAN[@]}
    do
        grep "^node:${node}|interface:${lan}" $TMP_DIR/cmviewcl.line | while read LINE
	do
            echo "$LINE" | grep -q status= && TARGET_STAT[$i]=$(echo "$LINE" | grep status= | cut -d= -f2)
	    echo "$LINE" | grep -q mac_address= && TARGET_MAC[$i]="0x$(echo "$LINE" | grep mac_address | cut -d= -f2 | sed -e 's/://g')"
	    echo "$LINE" | grep -q ppa= && TARGET_PPA[$i]=$(echo "$LINE" | grep ppa= | cut -d= -f2 )
	    echo "$LINE" | grep -q "|type=" && TARGET_LTYPE[$i]=$(echo "$LINE" | grep "|type=" | cut -d= -f2 )
	    echo "$LINE" | grep ip_address | grep -q name && TARGET_IP[$i]=$(echo "$LINE" | grep ip_address | grep name | cut -d= -f2 )
	done
        i=$((i+1))
    done
    break   # FIXME: we check only 1 node
done

