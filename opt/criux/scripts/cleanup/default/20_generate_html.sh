# 20_generate_html.sh
# from the OUTFILE we will now generate the html outputfile
# we will scan if there are FAILED's  in the OUTFILE to decide which subject line we want to generate
grep -q FAILED "$OUTFILE"
if [[ $? -eq 0 ]]; then
    MAILSUBJECT="Workflow $WORKFLOW report - status FAILED"
else
    MAILSUBJECT="Workflow $WORKFLOW report - status GOOD"
fi

LogPrint "Generating the HTML file"

GenerateHTMLFile "$MAILSUBJECT"
StopIfError "Could not generate the $HTMLFILE"

# now the HTMLFILE has been created - save a copy as reference in $VAR_DIR
cp  "$HTMLFILE" "$VAR_DIR/${PROGRAM%.*}-${TIME_STAMP}.html" >&2
StopIfError "Could not copy $HTMLFILE to $VAR_DIR/${PROGRAM%.*}-${TIME_STAMP}.html"
