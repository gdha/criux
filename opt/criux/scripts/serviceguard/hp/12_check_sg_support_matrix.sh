# 25_check_sg_support_matrix.sh

LogPrint "Serviceguard version $SG_VERSION with patch $SG_PATCH"

case "$SG_VERSION" in
    A.11.14*|A.11.15*) Warn "Serviceguard $SG_VERSION support ended very long time ago!"
	       ;;
    A.11.16* ) if [[ "$OS_VERSION" = "11.11" ]] ; then
                   Ok "Serviceguard $SG_VERSION supported until 31-Dec-2015"
               else
                   Warn "Serviceguard $SG_VERSION support ended at 30-Jun-2009"
	       fi
	       # 11.31 did not have a A.11.16 version
	       ;;
    A.11.17* ) # A.11.17 existed for 11.23 and 11.31
	       if [[ "$OS_VERSION" = "11.23" ]] ; then
                   Warn "Serviceguard $SG_VERSION support ended at 31-Dec-2010"
	       else
                   Warn "Serviceguard $SG_VERSION support ended at 29-Feb-2012"
	       fi
	       ;;
    A.11.18* ) # A.11.18 existed for 11.23 and 11.31
	       if [[ "$OS_VERSION" = "11.23" ]] ; then
                   Warn "Serviceguard $SG_VERSION support ended at 30-Jun-2012"
	       else
                   Warn "Serviceguard $SG_VERSION support ended at 30-Sep-2012"
	       fi
	       ;;
    A.11.19* ) # A.11.18 existed for 11.23 and 11.31
	       if [[ "$OS_VERSION" = "11.23" ]] ; then
                   Warn "Serviceguard $SG_VERSION supported until 31-Dec-2015"
	       else
                   Warn "Serviceguard $SG_VERSION support ended at 31-Mar-2014"
	       fi
	       ;;
    A.11.20* ) # 11.31 only
	       Ok "Serviceguard $SG_VERSION supported until 30-Sep-2017"
               ;;
esac
