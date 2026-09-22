# lin-diskenum.py

`lin-diskenum.py` enumerates raw disk images such as `.img`, `.dd`, and
`.raw` files on Linux. It creates a read-only loop device, detects
partitions/filesystems, and saves enumeration results separately under
the `enum/` directory.

## Requirements

Run the tool as root. Common utilities used include `losetup`, `lsblk`,
`blkid`, `fdisk`, `parted`, and Sleuth Kit tools such as `mmls`,
`fsstat`, `fls`, and `mactime`.

## Usage

### Enumerate a disk image

``` bash
sudo python3 lin-diskenum.py disk.img
```

Results are written by default to:

``` text
enum/disk/
```

Each detected partition receives its own directory, such as `p1/`,
`p2/`, and `p3/`.

### Enumerate and mount

``` bash
sudo python3 lin-diskenum.py disk.img --mount
```

The tool attempts to mount supported filesystems **read-only**. Mount
points are stored under:

``` text
enum/disk/mounts/
```

EXT filesystems use `ro,noload` to avoid journal replay.

### Check status

``` bash
sudo python3 lin-diskenum.py disk.img --status
```

Shows the loop device and mounts currently associated with the image.

### Unmount and detach

``` bash
sudo python3 lin-diskenum.py disk.img --unmount
```

`--dismount` is also accepted:

``` bash
sudo python3 lin-diskenum.py disk.img --dismount
```

The tool unmounts recorded filesystems and then cleanly detaches the
loop device.

### Skip hashing

For large images, SHA-256 calculation can be skipped:

``` bash
sudo python3 lin-diskenum.py disk.img --no-hash
```

### Custom output directory

``` bash
sudo python3 lin-diskenum.py disk.img -o ./case_enum
```
