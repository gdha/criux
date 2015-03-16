# 40_check_prim_alt_boot_disk.sh
# verify that we have 2 boot disks available
if [[ $(/usr/sbin/lvlnboot -v 2>/dev/null | grep "Boot Disk" | awk '{print $1}' | wc -l) -lt 2 ]]; then
    Warn "Only 1 boot disk present!" 
else
    Ok "Two boot disks present."
fi
