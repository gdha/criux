# 15_verify_lan_port_mapping.sh
# for the moment we will only do this for blades systems on HP-UX
# Model	        BL860ci2	BL870ci2	BL890ci2
# PxE/mgt	lan0    	lan0	        lan0
# ProdA	        lan1    	lan1    	lan17
# FO/ProdB	lan8	        lan16	        lan32
# HB    	lan2	        lan8    	lan48

# HWMODEL has been defined in HP-UX.conf
case "$HWMODEL" in
    BL860c*|BL870c*|BL890c* ) Log "Investigate the LAN port mapping on hardware type $HWMODEL" ;;
    *) return ;;
esac

case "$HWMODEL" in
    BL860c*) set -A LANPORTMAP lan0 lan1 lan8 lan2  ;;
    BL870c*) set -A LANPORTMAP lan0 lan1 lan16 lan8 ;;
    BL890c*) set -A LANPORTMAP lan0 lan17 lan32 lan48 ;;
esac

# we will only investigate the SOURCE_LAN[] according the model - not really a hard brainer
# but a quick and dirty check
i=0
count=${#SOURCE_LAN[@]}
while (( i < count ))
do
#    if [[ "${SOURCE_LAN[$i]}" = "${LANPORTMAP[$i]}" ]]; then
    echo "${LANPORTMAP[@]}" | grep -q "${SOURCE_LAN[$i]}"
    if [[ $? -eq 0 ]]; then
        Ok "Interface ${SOURCE_LAN[$i]} has the correct port mapping on hw model $HWMODEL"
    else
        Failed "Interface ${SOURCE_LAN[$i]} should be mapped on port ${LANPORTMAP[$i]} on hw model $HWMODEL"
    fi
    i=$((i+1))
done
