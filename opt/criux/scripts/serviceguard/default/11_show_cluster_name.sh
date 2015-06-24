#  11_show_cluster_name.sh
CL_NAME=$( grep ^name $TMP_DIR/cmviewcl.line | cut -d= -f2 )

if [[ -z "$CL_NAME" ]] ; then
    Error "Serviceguard cluster has no name!"
else
    Ok "Serviceguard cluster name is $CL_NAME"
fi
