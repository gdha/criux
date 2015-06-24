# 10_copy_outputfile.sh
cp  "$OUTFILE" "$VAR_DIR/${PROGRAM%.*}-${TIME_STAMP}.txt" >&2
StopIfError "Could not copy the $OUTFILE to $VAR_DIR/${PROGRAM%.*}-${TIME_STAMP}.txt"

