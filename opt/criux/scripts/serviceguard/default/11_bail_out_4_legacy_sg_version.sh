# default/11_bail_out_4_legacy_sg_version.sh
# Currently we do not have the time to work only with cmgetconf -c cluster, and
# cmgetconf -c cluster -p package (and that for each package).
# SG 11.20 (and >) has the option to retrieve everything at once with cmviewcl -v -f line
# As a consequence this means we cannot go deeper in SG_VERSION < A.11.20*
case "$SG_VERSION" in
    A.11.18*|A.11.19*|A.11.20* ) : ;;  # we will continue
    A.12.*   ) : ;;  # we will continue
    * ) Error "Serviceguard $SG_VERSION is legacy and we cannot dig deeper [sponsering needed]"
esac
