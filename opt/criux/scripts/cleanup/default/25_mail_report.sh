# 25_mail_report.sh
#
[[ -z "$MAILREPORT" ]] && return   # no -m option defined

type -p $MAILPROGRAM >/dev/null 2>&1 || return  # no mail program found

# MAILDESTINATION is by default "root" 
cat "$HTMLFILE" | $MAILPROGRAM -t "$MAILDESTINATION"
LogPrintIfError "Could not mail the HTML report to $MAILDESTINATION"

