# 20_generate_html.sh
# from the OUTPUTFILE we will now generate the html outputfile
GenerateHTMLFile
StopIfError "Could not generate the $HTMLFILE"

cp "$HTMLFILE" "$VAR_DIR/${PROGRAM%.*}-$(date '+%Y%m%d-%H%M').html"
StopIfError "Could not copy $HTMLFILE to $VAR_DIR/${PROGRAM%.*}-$(date '+%Y%m%d-%H%M').html"
