# 14_check_interface_heartbeat.sh
# in a SG cluster we should at least have 2 heartbeat networks per node
for node in ${NODES[@]}
do
    count=$(grep "^node:${node}|interface:" $TMP_DIR/cmviewcl.line | grep heartbeat=true | wc -l) # 2
    if (( count < 2 )); then
        Failed "Node ${node} has only $count heartbeat networks defined (min. 2)"
    else
        Ok "Node ${node} has $count heartbeat networks defined"
    fi
done
