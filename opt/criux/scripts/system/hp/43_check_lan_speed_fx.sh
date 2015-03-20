# 43_check_lan_speed_fx.sh

#echo "l\n
# $(for i in $(lanscan -q)
#  do
#	   echo "p\n$i\nd\n"
#  done)
#  q\n" | lanadmin 2> /dev/null | grep Desc | cut -f2 -d"="

for intf in $(netstat -i | grep ^lan | grep -v : | awk '{print $1}' | sed -e 's/lan//' -e 's/*$//')
do
    (( $intf >= 900 ))  && continue  # we will not check APA interfaces
    lanadmin -x $intf | grep -iq Full
    if (( $? == 0 )) ; then
        Ok "Interface lan${intf} is using $(lanadmin -x $intf | grep -i Speed | cut -d= -f2)"
    else
        Warn "Interface lan${intf} is using $(lanadmin -x $intf | grep -i Speed | cut -d= -f2)"
    fi
done
