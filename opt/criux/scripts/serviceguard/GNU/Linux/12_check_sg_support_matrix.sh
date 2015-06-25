# GNU/Linux/12_check_sg_support_matrix.sh

LogPrint "Serviceguard version $SG_VERSION with patch $SG_PATCH"

case "$SG_VERSION" in
    A.11.18*|A.11.19* ) 
               Warn "Serviceguard $SG_VERSION supported ended at 30-Apr-2014"
	       ;;
    A.11.20* ) 
	       Ok "Serviceguard $SG_VERSION supported until 30-Apr-2016"
               ;;
    A.12.00* )
	       Ok "Serviceguard $SG_VERSION supported until 30-Apr-2019"
	       ;;
    *        )
	       Failed "Serviceguard $SG_VERSION is long overdue!"
	       ;;
esac
