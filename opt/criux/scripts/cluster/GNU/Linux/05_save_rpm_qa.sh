# 05_save_rpm_qa.sh
rpm -qa > $TMP_DIR/rpm_qa.txt"
LogPrintIfError "Could not create the $TMP_DIR/rpm_qa.txt"
