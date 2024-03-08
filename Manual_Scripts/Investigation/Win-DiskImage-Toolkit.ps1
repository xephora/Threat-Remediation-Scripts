# Retrieves Disk Images
#Get-WmiObject -Class Win32_logicaldisk
##############################################################################
# Get-DiskImage is used to get information about the disk image              #
#Get-DiskImage -DevicePath \\.\CDROM1                                        #
##############################################################################
# Dismount-DiskImage is used to unmount a disk image                         #
#Dismount-DiskImage -DevicePath \\.\CDROM1                                   #
##############################################################################
# Dismount-diskimage is used to unmount a disk by using the path of the vhd/iso responsible
#dismount-diskimage -imagepath "file path"
