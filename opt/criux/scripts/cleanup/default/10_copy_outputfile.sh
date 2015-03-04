#10_copy_outputfile.sh
cp "$OUTPUTFILE" "$VAR_DIR/${PROGRAM%.*}-$(date '+%Y%m%d-%H%M').txt"
StopIfError "Could not copy the $OUTPUTFILE to $VAR_DIR/${PROGRAM%.*}-$(date '+%Y%m%d-%H%M').txt"

