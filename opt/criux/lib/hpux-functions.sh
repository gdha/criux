function ShowErrorsSwagentLog {
    # /var/adm/sw/swagent.log contains verify output
    [[ ! -f /var/adm/sw/swagent.log ]] && return  # no file; return
    # grab the latest jobid nr
    jobid=$( FindJobId /var/adm/sw/swagent.log )
    # with the jobid we can trim the swagent.log file to the latest run
    awk '/'$jobid'/ {flag=1;next}  /'$jobid'/ {flag=0} flag {print}' /var/adm/sw/swagent.log > $TMP_DIR/swagent.$jobid
    grep -i error: $TMP_DIR/swagent.$jobid
}
# ------------------------------------------------------------------------------

function FindJobId {
    # return the jobid nr from log file ($1); output is string containing jobid or empty
    if [[ ! -f "$1" ]]; then
        echo ""
    else
	tail -5 "$1" | grep jobid | cut -d= -f2 | sed -e 's/)//'
    fi
}
# ------------------------------------------------------------------------------

function SwJob {
    # input argument is SWINSTALL or SWREMOVE variable; according cmd we will select
    # the proper log file to investigate with swjob
    [[ -z "$1" ]] && return   # no argument - no output
    # $1=/usr/sbin/swinstall => /var/adm/sw/swinstall.log
    swlogfile=/var/adm/sw/${1##*/}.log
    swjob_cmd="$( tail -10 $swlogfile | grep swjob | sed -e 's/command//' -e 's/\.$//' -e 's/\"//g' -e 's/^[ \t]*//' )"
    Log "Output: $swjob_cmd"
    echo $swjob_cmd | sh -
}

function ShowHardwareModel {
    # echo the hardware model (this function should be repeated for each architecture
    # for HP it is quite simple
    echo $(uname -m)
}
