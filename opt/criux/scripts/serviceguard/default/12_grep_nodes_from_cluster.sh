# 12_grep_nodes_from_cluster.sh
set -A NODES
i=0
grep ^node: $TMP_DIR/cmviewcl.line | grep -vE '(interface:|subnet:)' | grep name= | cut -d= -f2 | while read node
do
    NODES[$i]="$node" 
    i=$((i+1))
done
NCOUNT=${#NODES[@]}
if (( NCOUNT < 1 )); then
    Error "Serviceguard cluster $CL_NAME contains no nodes"
else
    nodes="${NODES[@]}"
    Ok "Serviceguard cluster $CL_NAME contains $count nodes ($nodes)"
fi
