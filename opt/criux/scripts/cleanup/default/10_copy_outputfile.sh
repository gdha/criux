# 10_copy_outputfile.sh
cp  "$OUTFILE" "$VAR_DIR/${PROGRAM%.*}-$(date '+%Y%m%d-%H%M').txt" >&2
StopIfError "Could not copy the $OUTFILE to $VAR_DIR/${PROGRAM%.*}-$(date '+%Y%m%d-%H%M').txt"

