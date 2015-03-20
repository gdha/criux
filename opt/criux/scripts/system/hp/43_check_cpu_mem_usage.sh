# 43_check_cpu_mem_usage.sh

#
# Usage: ReportGlobalUsage.sh [extract parameters]
# original script is from Peter Mertens

[[ ! -x /opt/perf/bin/extract ]] && return  # no extract executable present

ExtractParameters=${*:--b FIRST}

EXTRREP=$TMP_DIR/ReportGblUsage.tmp1
EXTROUT=$TMP_DIR/ReportGblUsage.tmp2
RANGE=15 # report CPU usage in chuncks of RANGE

cat - <<-EOT > $EXTRREP
	FORMAT ASCII 
	HEADINGS OFF
	SEPARATOR="|"
	MISSING=0
	DATA TYPE GLOBAL
	DATE                                         
	TIME                                         
	GBL_CPU_TOTAL_UTIL
	GBL_MEM_UTIL
EOT

LogPrint "Extract the global CPU and Memory usage"

/opt/perf/bin/extract -r $EXTRREP -g -xp -f $EXTROUT,p $ExtractParameters

Log First Record $(head -n1 $EXTROUT)
Log  Last Record $(tail -n1 $EXTROUT)


# report CPU
sort -t\| -k3,3 $EXTROUT | awk -v width=$RANGE -F\| '
BEGIN {prevrange=-1; globalcount=0; rangecount=0; max=0; tot=0;
       printf "00 %3s %3s %11s (01=Global CPU Record)\n", "AVG", "MAX", "Count" ;
       printf "00 %-7s %-32s (09=CPU Range Record)\n", "Range", "Range-Count";
       }
{
range=int($3/width)*width;
if (range != prevrange) {
        if (prevrange != -1) { # not first time
                printf "09 %03d-%03d %11d\n", prevrange, prevrange+width, rangecount;
                rangecount=0;
                }
	prevrange=range;
        }
++globalcount;
++rangecount;
tot +=$3;
if (max < $3) max=$3;
}
END {
        printf "09 %03d-%03d %11d\n", prevrange, prevrange+width, rangecount;
        printf "01 %3d %3d %11d\n",   tot/globalcount, max, globalcount;
        print "total count - " NR}' | 
sort -k1,1n | awk '
BEGIN {
       print "<pre>--CPU----  ----Range-----------</pre>";
       print "<pre>AVG  PEAK  from-to    % of time</pre>"}
($1 == 0) { next }
($1 == 1) { total=$4; peak=$3; avg=$2}
($1 == 9) { pos=index($2, "-");
            from=substr($2, 0, pos-1);
            to=substr($2, pos+1);
            # make sure these are numbers !!!

            from+=0; to+=0;

            avg+=0; peak +=0;
            if (avg  >= from && avg  < to) pAvg=avg   "%"; else pAvg="";
            if (peak >= from && peak < to) pPeak=peak "%"; else pPeak="";
            printf "<pre>%4s %4s    %-7s   %6.2f%%</pre>\n", pAvg, pPeak, $2, $3/total*100 
            }' >> "$TMP_DIR/cpu_mem.usage"

# report MEMORY
sort -t\| -k4,4 $EXTROUT | awk -v width=$RANGE -F\| '
BEGIN {prevrange=-1; globalcount=0; rangecount=0; max=0; tot=0;
       printf "00 %3s %3s %11s (01=Global MEM Record)\n", "AVG", "MAX", "Count" ;
       printf "00 %-7s %-32s (09=MEM Range Record)\n", "Range", "Range-Count";
       }
{
range=int($4/width)*width;
if (range != prevrange) {
        if (prevrange != -1) { # not first time
                printf "09 %03d-%03d %11d\n", prevrange, prevrange+width, rangecount;
                rangecount=0;
                }
	prevrange=range;
        }
++globalcount;
++rangecount;
tot +=$4;
if (max < $4) max=$4;
}
END {
        printf "09 %03d-%03d %11d\n", prevrange, prevrange+width, rangecount;
        printf "01 %3d %3d %11d\n",   tot/globalcount, max, globalcount;
        print "total count - " NR}' | 
sort -k1,1n | awk '
BEGIN {
       print "<pre>-MEMORY--  ----Range-----------</pre>";
       print "<pre>AVG  PEAK  from-to    % of time</pre>"}
($1 == 0) { next }
($1 == 1) { total=$4; peak=$3; avg=$2}
($1 == 9) { pos=index($2, "-");
            from=substr($2, 0, pos-1);
            to=substr($2, pos+1);
            # make sure these are numbers !!!

            from+=0; to+=0;

            avg+=0; peak +=0;
            if (avg  >= from && avg  < to) pAvg=avg   "%"; else pAvg="";
            if (peak >= from && peak < to) pPeak=peak "%"; else pPeak="";
            printf "<pre>%4s %4s    %-7s   %6.2f%%</pre>\n", pAvg, pPeak, $2, $3/total*100 
            }' >> "$TMP_DIR/cpu_mem.usage"

Warn "The CPU and Memory usage - interprete it carefully:"
Comment "$(cat $TMP_DIR/cpu_mem.usage)"

