#  15_show_cluster_name.sh
CL_NAME=$( head -3 $TMP_DIR/cmviewcl.txt | tail -1 | awk '{print $1}' )

if [[ -z "$CL_NAME" ]] ; then
    Error "Serviceguard cluster has no name!"
else
    Ok "Serviceguard cluster name is $CL_NAME"
fi