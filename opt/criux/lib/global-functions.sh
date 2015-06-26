function IsDigit {
    echo $(($1+0))          # returns 0 for non-numeric input, otherwise input=output
}

# ------------------------------------------------------------------------------
function LogToSyslog {
    # send a line to syslog or messages file with input string
    logger -t $PROGRAM -i "$*"
}

# ------------------------------------------------------------------------------
function MailTo {
    [ -s "$HTMLFILE" ] || HTMLFILE=/dev/null
    if [[ -n $mailusr ]]; then
        mailx -s "$*" $mailusr < $HTMLILE
    fi
}

# ------------------------------------------------------------------------------
function Revision {
    typeset rev
    rev=$(awk '/Revision/ { print $3 }' $PRGDIR/$PROGRAM | head -1)
    [ -n "$rev" ] || rev="\"Under Development\""
    printf "%s %s\n" $PROGRAM $rev
} # Acquire revision number of the script and plug it into the log file

# ------------------------------------------------------------------------------
function WhoAmI {
    if [ "$(id -u)" != "0" ]; then
        echo "$LOGNAME - You must be root to run script $PROGRAM" 
        echo 1 > $ERRfile
        exit 1
    fi
}

# ------------------------------------------------------------------------------
function is_var_empty {
    if [ -z "$1" ]; then
    Usage
        echo 1 > $ERRfile
    exit 1
    fi
}

# ------------------------------------------------------------------------------
function CreateLockDir {
    mkdir "${LOCKDIR}" >/dev/null 2>/dev/null
    if (( $? == 0 )) ; then
        # create the PIDFILE now
        if echo $PID > "$PIDFILE" ; then
            Log "lock succeeded: $PID - $PIDFILE"
        else
            Log "Cannot create $PIDFILE (rc=$?)"
            return 1
        fi
    else # else part of mkdir test
        # LOCKDIR already exists
        if [ -f "$PIDFILE" ]; then
            Log "Found $PIDFILE file - we could be locked..."
            OTHERPID=$(< "$PIDFILE" )
            # seen a case where OTHERPID was an old PID of criux, but now in use by another program
            # therefore, we should also test if OTHERPID belongs to criux or not
            if kill -s 0 ${OTHERPID} 2>/dev/null ; then
                if UNIX=95 ps -ef | grep ${OTHERPID} | grep -v grep | grep -q $PROGRAM ; then
                    Log "locked on ${OTHERPID} - try again"
                    return 1
                else
                    OTHERPROC=$(UNIX=95 ps -ef | grep ${OTHERPID} | grep -v grep | awk '{print $8}')
                    Log "PID (${OTHERPID}) belongs now to process ${OTHERPROC} - will continue"
                fi
            else
                Log "lock is stale (${OTHERPID}) - will continue"
            fi
        fi
        if echo $PID > "$PIDFILE" ; then
            Log "lock succeeded: $PID - $PIDFILE"
        else
            Log "lock failed: $LOCK with rc=$?"
            Log "stop processing"
            return 1
        fi
    fi  # end of mkdir test

    ## check if PIDFILE contains our PID
    CHECKPID=$(< "$PIDFILE" )
    [[ ${PID} != ${CHECKPID} ]] && return 1   # not successful; try again

    # our PID is effectivily written in the PIFDILE
    return 0
}

# ------------------------------------------------------------------------------
function AcquireLock {
    Log "Check if our PID ($PID) is locked"
    CANWEPROCEED=0
    LOCKTAKESTOOLONG=0
    while ( test $CANWEPROCEED -eq 0 )
    do
        LOCKTAKESTOOLONG=$(( LOCKTAKESTOOLONG + 1 ))
        if (( LOCKTAKESTOOLONG > 1000 )) ; then
            Error "Waiting on the lock to release takes too long (> $LOCKTAKESTOOLONG seconds)"
        fi
        CreateLockDir && CANWEPROCEED=1
        sleep 1
    done
    return 0
}

# ------------------------------------------------------------------------------
function ReleaseLock {
    # remove the lock only if PID is current one
    CHECKPID=$(< "$PIDFILE" )
    if (( PID == CHECKPID )); then
        # ok we are sure if is our lock
        rm -rf "${LOCKDIR}"
        if (( $? == 0 )) ; then
            Log "Successfully removed the lock directory (${LOCKDIR})"
        else
            Log "We could not remove the lock directory (${LOCKDIR}) due to rm error $?"
        fi
    else
        Log "The lock contains another PID ($CHECKPID) then our effective PID ($PID)"
        Log "We do not remove the lock directory ${LOCKDIR}"
    fi
    return 0
}

# ------------------------------------------------------------------------------
function GetHostnameFromIP {
    # input is IP address; output hostname
    case ${platform} in
        HP-UX)
             xxx=$(nslookup $1 | grep "^Name:" | awk '{print $2}' 2>/dev/null)
         ;;
        Linux)
             xxx=$(dig +short -x $1 | cut -d. -f1 2>/dev/null)
         ;;
    esac
    [[ -z "$xxx" ]] && xxx="UNKNOWN"
    echo $xxx
}

# ------------------------------------------------------------------------------
function IsVolumeGroupActive {
    # input arg: VG; output:0=VG active, or 1=VG not active)
    typeset VG=$1
    TMPVG=/tmp/vgdisplay-${VG}.${PID}
    vgdisplay ${VG} > ${TMPVG} 2>&1
    grep -q "Cannot display volume group" ${TMPVG}
    if (( $? == 0 )) ; then
        Log "VG $VG is \"not\" active."
        rc=1
    else
        Log "VG $VG is active."
    rc=0
    fi
    grep -q "is exported" ${TMPVG}
    if (( $? == 0 )) ; then
        Log "VG $VG is \"exported\"."
        rc=1
    fi
    rm -f ${TMPVG}
    return $rc
}

# ------------------------------------------------------------------------------
function Timeout {
    # function to timeout processes hanging on e.g. stale NFS mount points
    # usage: Timeout seconds commands
    # Timeout 10 ls $mount_point >/dev/null
    # rc=$?
    # [[ $rc -ne 0 ]] && echo "stale $mount_point" || echo "mount point $mount_point seems not to be stale"

    # argument 1: integer in seconds
    [ "$DEBUG" ] && set -x
    TIMEOUT=$1
    shift
    COMMAND="$@"
    RET=0
    # Launch command in backgroup
    [ ! "$DEBUG" ] && exec 6>&2 # Link file descriptor #6 with stderr.
    [ ! "$DEBUG" ] && exec 2> /dev/null # Send stderr to null (avoid the Terminated messages)
    $COMMAND 2>&1 >/dev/null &
    COMMAND_PID=$!
    [ "$DEBUG" ] && echo "Background command pid $COMMAND_PID, parent pid $$"
    # Timer that will kill the command if timesout
    sleep $TIMEOUT && UNIX95= ps -p $COMMAND_PID -o pid,ppid | awk -v parent=$$ '$2==parent {print $1}' | xargs kill &
    KILLER_PID=$!
    [ "$DEBUG" ] && echo "Killer command pid $KILLER_PID, parent pid $$"
    wait $COMMAND_PID
    RET=$?
    # Kill the killer timer
    [ "$DEBUG" ] && echo Listing proces that will be killed
    [ "$DEBUG" ] && UNIX95= ps -p $KILLER_PID -o pid,ppid | awk -v parent=$$ '$2==parent {print $1}' | xargs ps -fp
    UNIX95= ps -p $KILLER_PID -o pid,ppid | awk -v parent=$$ '$2==parent {print $1}' | xargs kill
    [ ! "$DEBUG" ] && exec 2>&6 6>&- # Restore stderr and close file descriptor #6.
    return $RET
}

# ------------------------------------------------------------------------------
function Cleanup {
    rm -f $ERRfile
    return 0
}

# ------------------------------------------------------------------------------
function SurroundingGrep {
    # grep string ($3) in file $4 and print #lines before ($1) and #lines after ($2) the matched string ($3)
    # usage: echo $(SurroundingGrep 0 3 'Quorum' /tmp/cmviewcl.txt)
    b=$1
    a=$2
    s="$3"
    fl=$4
    [[ ! -f $fl ]] && Error "Input file $fl not found"
    awk 'c-->0;$0~s{if(b)for(c=b+1;c>1;c--)print r[(NR-c+1)%b];print;c=a}b{r[NR%b]=$0}' b=$b a=$a s="$s" $fl
}

# ------------------------------------------------------------------------------
function KillProc {
    # input argument is "process name" (program) to be killed
    Log "Stopping $1"
    pid=$( ps -e | grep "$1" | sed -e 's/^[ \t]*//' -e 's/ .*//' )
    [[ ! -z "$pid" ]] && kill $pid
}

# ------------------------------------------------------------------------------
function PingSystem {
    case $OS in
        Linux|Darwin)
            i=$(ping -c 2 ${1} | grep "packet loss" | cut -d, -f3 | awk '{print $1}' | cut -d% -f1 | cut -d. -f1)
            ;;
        HP-UX|CYGWIN_NT-5.1)
            i=$(ping ${1} -n 2 | grep "packet loss" | cut -d, -f3 | awk '{print $1}' | cut -d% -f1 | cut -d. -f1)
            ;;
        *)
            i=$(ping ${1} >/dev/null 2>&2; echo $?)
            ;;
    esac
    [ -z "$i" ] && i=2      # when ping returns "host unknown error"
    # i=1 : not reachable
    # i=0 : reachable
    echo $i
}

# ------------------------------------------------------------------------------
function PingViaInterface {
    # HP-UX/Solaris: ping -i address
    # Linux: ping -I address
    # arg1: interface IP address; arg2: destination host to ping
    case $OS in
        Linux)
            i=$(ping -I ${1} -c 2 ${2} | grep "packet loss" | cut -d, -f3 | awk '{print $2}' | cut -d% -f1 | cut -d. -f1)
            ;;
        HP-UX)
            i=$(ping -i ${1} ${2} -n 2 | grep "packet loss" | cut -d, -f3 | awk '{print $2}' | cut -d% -f1 | cut -d. -f1)
            ;;
        SunOS)
            i=$(ping -i ${1} ${2} >/dev/null 2>&2; echo $?)
            ;;
            *) Error "Do not how to ping via interface ($1) host $2 (for OS $OS)"
            ;;
    esac
    [ -z "$i" ] && i=2      # when ping returns "host unknown error"
    # i=1 : not reachable
    # i=0 : reachable
    echo $i
}

# ------------------------------------------------------------------------------
function GenerateTempDirName {
    # the mktemp command differs between HP-UX, Linux, and other Unixes
    # so we generate a generic function for it
    # input args: $1 base directory to create temp dir in (e.g. /tmp
    #             $2 base name (we will append a RANDOM number to it)
    # output arg: directory name we generated
    DIR1="$1"
    DIR2="$2"
    [[ ! -d "$DIR1" ]] && DIR1=/tmp  # when not existing use /tmp as default
    [[ -z "$DIR2" ]] && DIR2="$PROGRAM"
    echo "${DIR1}/${DIR2}_${RANDOM}"
}

# ------------------------------------------------------------------------------
