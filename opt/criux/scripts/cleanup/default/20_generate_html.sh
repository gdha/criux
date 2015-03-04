# 20_generate_html.sh
# from the OUTFILE we will now generate the html outputfile
GenerateHTMLFile
StopIfError "Could not generate the $HTMLFILE"

cp $v "$HTMLFILE" "$VAR_DIR/${PROGRAM%.*}-$(date '+%Y%m%d-%H%M').html" >&2
StopIfError "Could not copy $HTMLFILE to $VAR_DIR/${PROGRAM%.*}-$(date '+%Y%m%d-%H%M').html"
