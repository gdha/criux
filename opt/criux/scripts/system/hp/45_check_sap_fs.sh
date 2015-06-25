# 45_check_sap_fs.sh 

# internal variable MOUNT_OPTS_RC to indicate if we need to show a Failed line or Ok line
mount | grep -vi -E '(nfs|direct|vg00)' > "$TMP_DIR/mounted.fs"

LogPrint "Analyzing the file system mount options and block sizes"

cat "$TMP_DIR/mounted.fs" | while read mntpt junk device options junk
do
    # /oracle/BAC/sapdata6 on /dev/vgdbBAC1/lvsapdata6 ioerror=mwdisable,largefiles,delaylog,nodatainlog,dev=40150015 on Sun Oct
    # check all sapdata related FS first
    MOUNT_OPTS_RC=0
    # grep on 'sap' covers sapdata and other sap related FS
    echo "$mntpt" | grep -q  -E '(sap|ers)' && {
         # largefiles,delaylog,nodatainlog 
	 echo "$options" | grep -q "largefiles"
	 if [[ $? -eq 1 ]]; then
	     MOUNT_OPTS_RC=1
	     Warn "Filesystem $mntpt is missing \"largefiles\" option."
	 fi

	 echo "$options" | grep -q "delaylog"
	 if [[ $? -eq 1 ]]; then
	     MOUNT_OPTS_RC=1
	     Warn "Filesystem $mntpt is missing \"delaylog\" option."
	 fi

	 echo "$options" | grep -q "nodatainlog"
	 if [[ $? -eq 1 ]]; then
	     MOUNT_OPTS_RC=1
	     Warn "Filesystem $mntpt is missing \"nodatainlog\" option."
	 fi

	 echo "$options" | grep -q "convosync=direct"
	 if [[ $? -eq 0 ]]; then
             MOUNT_OPTS_RC=1
	     Warn "Filesystem $mntpt should not have \"convosync=direct\" option."
	 fi

         if [[ $MOUNT_OPTS_RC -eq 0 ]]; then
	     Ok "Filesystem $mntpt has the correct mount options."
         fi

         block_size=$(GrabBlockSize $device)
         case $block_size in
             8192) Ok "Device $device has the correct block size." ;;
             1024) Warn "Device $device should have a block size of 8192 instead of 1024." ;;
	     *) Failed "Device $device has a block size of $block_size (should be 8192)!" ;;
         esac
    }
done

mount | grep -vi -E '(nfs|vg00)' > "$TMP_DIR/mounted.fs"
# loop once again for mirror and archive log directories
cat "$TMP_DIR/mounted.fs" | while read mntpt junk device options junk
do
    # ioerror=mwdisable,largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct,dev=40150007
    MOUNT_OPTS_RC=0
    echo "$mntpt" | grep -q -E '(mirrlog|oraarch)' && {
        # largefiles,mincache=direct,delaylog,convosync=direct,nodatainlog
         echo "$options" | grep -q "largefiles"
	 if [[ $? -eq 1 ]]; then
	     MOUNT_OPTS_RC=1
	     Warn "Filesystem $mntpt is missing \"largefiles\" options."
         fi

	 echo "$options" | grep -q "mincache=direct"
	 if [[ $? -eq 1 ]]; then
             MOUNT_OPTS_RC=1
	     Warn "Filesystem $mntpt is missing \"mincache=direct\" options."
	 fi

	 echo "$options" | grep -q "delaylog"
	 if [[ $? -eq 1 ]]; then
             MOUNT_OPTS_RC=1
	     Warn "Filesystem $mntpt is missing \"delaylog\" options."
	 fi

	 echo "$options" | grep -q "convosync=direct"
	 if [[ $? -eq 1 ]]; then
             MOUNT_OPTS_RC=1
	     Warn "Filesystem $mntpt is missing \"convosync=direct\" options."
	 fi

	 echo "$options" | grep -q "nodatainlog"
	 if [[ $? -eq 1 ]]; then
             MOUNT_OPTS_RC=1
	      Warn "Filesystem $mntpt is missing \"nodatainlog\" options."
	 fi
         
	 if [[ $MOUNT_OPTS_RC -eq 0 ]]; then
             Ok "Filesystem $mntpt has the correct mount options."
         fi

         block_size=$(GrabBlockSize $device)
         case $block_size in
             8192) Ok "Device $device has the correct block size." ;;
             1024) Warn "Device $device should have a block size of 8192 instead of 1024." ;;
	     *) Failed "Device $device has a block size of $block_size (should be 8192)!" ;;
         esac
    }
done
