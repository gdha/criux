# input-output-functions.sh
#
# NOTE: This is the first file to be sourced which is why
#   it contains some special stuff like EXIT_TASKS that I want to be available everywhere

LF="
"
# collect exit tasks in this array


#
# Log: send arg to LOGFILE
# LogPrint: send arg to LOGFILE and STDOUT
# Print: send arg to STDOUT
# PrintF: send args to OUTFILE
# Error: send arg to LOGFILE/STDOUT and bail out

# add $* as a task to be done at the end
function AddExitTask {
    # NOTE: we add the task at the beginning to make sure that they are executed in reverse order
    #EXIT_TASKS=( "$*" "${EXIT_TASKS[@]}" ) # I use $* on purpose because I want to get one string from all args!
    set -A EXIT_TASKS "$*" "${EXIT_TASKS[@]}"
    Debug "Added '$*' as an exit task"
}

function QuietAddExitTask {
    #EXIT_TASKS=( "$*" "${EXIT_TASKS[@]}" ) # I use $* on purpose because I want to get one string from all args!
    set -A EXIT_TASKS "$*" "${EXIT_TASKS[@]}"
}

# remove $* from the task list
function RemoveExitTask {
    removed=""
    c=0
    while (( c < ${#EXIT_TASKS[@]} ))
    do
        if test "${EXIT_TASKS[c]}" == "$*" ; then
            unset 'EXIT_TASKS[c]' # the ' ' protect from bash expansion, however unlikely to have a file named EXIT_TASKS in pwd...
            removed=yes
            Debug "Removed '$*' from the list of exit tasks"
        fi
        c=$((c+1))
    done
    [ "$removed" == "yes" ]
    LogIfError "Could not remove exit task '$*' (not found). Exit Tasks:
$(
    for task in "${EXIT_TASKS[@]}" ; do
        echo "$task"
    done
)"
}

# do all exit tasks
function DoExitTasks {
    Log "Running exit tasks."
    # kill all running jobs
    #JOBS=( $(jobs -p) )
    set -A JOBS $(jobs -p)
    if test "$JOBS" ; then
                Log "The following jobs are still active:"
                jobs -l >&2
        kill -9 "${JOBS[@]}" >&2
        sleep 1 # allow system to clean up after killed jobs
    fi
    for task in "${EXIT_TASKS[@]}" ; do
        Debug "Exit task '$task'"
        eval "$task"
    done
}


# activate the trap function
trap "DoExitTasks" 0
# keep PID of main process
MASTER_PID=$$
# duplication STDOUT to fd7 to use for Print
exec 7>&1
QuietAddExitTask "exec 7>&-"
# USR1 is used to abort on errors, not using Print to always print to the original STDOUT, even if quiet
trap "echo 'Aborting due to an error, check $LOGFILE for details' >&7 ; kill $MASTER_PID" USR1


# Check if any of the binaries/aliases exist
function has_binary {
    for bin in $@; do
        if type $bin >&8 2>&1; then
            return 0
        fi
    done
    return 1
}

function get_path {
    type -p $1 2>&8
}

function Error {
    # If first argument is numerical, use it as exit code
    if [ $1 -eq $1 ] 2>&8; then
        EXIT_CODE=$1
        shift
    else
        EXIT_CODE=1
    fi
    VERBOSE=1
    LogPrint "ERROR: $*"
    if has_binary caller; then
        # Print stack strace on errors in reverse order
        (
            echo "=== Stack trace ==="
            c=0;
            while caller $((c++)); do :; done | awk '
                { l[NR]=$3":"$1" "$2 }
                END { for (i=NR; i>0;) print "Trace "NR-i": "l[i--] }
            '
            echo "Message: $*"
            echo "==================="
        ) >&2
    fi
    kill -USR1 $MASTER_PID # make sure that Error exits the master process, even if called from child processes :-)
}

function StopIfError {
    # If return code is non-zero, bail out
    if (( $? != 0 )); then
        Error "$@"
    fi
}

function BugError {
    # If first argument is numerical, use it as exit code
    if [ $1 -eq $1 ] 2>&8; then
        EXIT_CODE=$1
        shift
    else
        EXIT_CODE=1
    fi
    Error "BUG BUG BUG! " "$@" "
=== Issue report ===
Please report this unexpected issue
Also include the relevant bits from $LOGFILE

HINT: If you can reproduce the issue, try using the -d or -D option !
===================="
}

function BugIfError {
    # If return code is non-zero, bail out
    if (( $? != 0 )); then
        BugError "$@"
    fi
}

function Debug {
    test "$DEBUG" && Log "$@"
}

function Echo {
    # echo is not the same on HP-UX/Linux
    case $platform in
        Linux|Darwin) arg="-e " ;;
        *) arg="" ;;
    esac
    echo $arg "$*"
}

function PrintF {
    # send input string to OUTFILE
    # arg1: counter (integer), arg2: "left string", arg3: "right string"
    # e.g. PrintF 22 "Host:" "$HOSTNAME"
    # Be careful: no newline added automatically (is called by Ok/Failed/Skip/Warn)

    typeset -i i
    # count input args
    if [[ $# -eq 2 ]]; then
	i=1
	str1="$1"
	shift
	str2="$@"
    else
        i=$(IsDigit $1)
        [[ $i -eq 0 ]] && i=1
	shift   # remove the integer
	str1="$1"
	shift
	str2="$@"  # to have all the rest of the input
    fi

    printf "%${i}s %-80s " "$str1" "$str2" >> "$OUTFILE"
}

function Print {
    # to STDOUT
    test "$VERBOSE" && echo "$*" >&7
}

# print if there is an error
function PrintIfError {
    # If return code is non-zero, bail out
    if (( $? != 0 )); then
        Print "$@"
    fi
}

if [[ ! -z "$DEBUG" ]]  || [[ ! -z "$DEBUG_SCRIPTS" ]]; then
    function Stamp {
        date +"%Y-%m-%d %H:%M:%S.%N "
    }
else
    function Stamp {
        date +"%Y-%m-%d %H:%M:%S "
    }
fi

function Log {
    if test $# -gt 0 ; then
        echo "$(Stamp)$*"
    else
        echo "$(Stamp)$(cat)"
    fi >&2
}

# log if there is an error
function LogIfError {
    # If return code is non-zero, bail out
    if (( $? != 0 )); then
        Log "$@"
    fi
}

function LogPrint {
    Log "$@"
    Print "$@"
}

# log/print if there is an error
function LogPrintIfError {
    # If return code is non-zero, bail out
    if (( $? != 0 )); then
        LogPrint "$@"
    fi
}

function Failed {
    # 
    ERRCOUNT=$((ERRCOUNT + 1))
    PrintF 3 "==" "$@"
    echo "[FAILED]" >> "$OUTFILE"
}

function Ok {
    PrintF 3 "**" "$@"
    echo "[ OK ]" >> "$OUTFILE"
}

function Skip {
    PrintF 3 "**" "$@"
    echo "[SKIP]" >> "$OUTFILE"
}

function Warn {
    PrintF 3 "**" "$@"
    echo "[WARN]" >> "$OUTFILE"
}

function Comment {
    PrintF 3 " " "$@"
    Newl
}

function Newl {
    printf "\n" >> "$OUTFILE"
}

function LINE {
    str="------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

    typeset -i i j
    i=$(IsDigit $1)
    [[ $i -eq 0 ]] && i=80
    echo "${str}" | cut -c1-${i} >> "$OUTFILE"
}

function ShowBanner {
     $(LINE 95)
     $(PrintF 22 "Script:" "$PROGRAM") ; Newl
     $(PrintF 22 "Workflow:" "$WORKFLOW") ; Newl
     $(PrintF 22 "OS Release:" "$OS_VENDOR_VERSION") ; Newl
     $(PrintF 22 "Model:" "$(ShowHardwareModel)") ; Newl
     $(PrintF 22 "Host:" "$HOSTNAME") ; Newl
     $(PrintF 22 "User:" "$(whoami)") ; Newl
     $(PrintF 22 "Date:" "$(date +'%Y-%m-%d @ %H:%M:%S')") ; Newl
     $(LINE 95)
}

# setup dummy progress subsystem as a default
# not VERBOSE, Progress stuff replaced by dummy/noop
exec 8>/dev/null # start ProgressPipe listening at fd 8
QuietAddExitTask "exec 8>&-" # new method, close fd 8 at exit

