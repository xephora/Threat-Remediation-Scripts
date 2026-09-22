### lin-jextract — Linux EXT Journal Extraction Tool

lin-jextract automatically identifies EXT filesystems within a Linux disk image and extracts their filesystem journals for forensic analysis.

```
$ sudo python3 extractfs_journal.py sample_disk.img

[+] Image: /path/to/sample_disk.img
[+] losetup --find --show --read-only --partscan /path/to/sample_disk.img
[+] Read-only loop device: /dev/loopX
[+] lsblk -ln -o PATH,TYPE /dev/loopX

[*] Examining /dev/loopXp1
[+] blkid -o value -s TYPE /dev/loopXp1
    Filesystem: ext4
[+] dumpe2fs -h /dev/loopXp1
    [+] Journal inode: 8
    [+] Dumping journal inode <8>...
[+] debugfs -R dump <8> /path/to/output/loopXp1_journal.bin /dev/loopXp1
    [+] Journal dumped successfully
    [+] Output: /path/to/output/loopXp1_journal.bin
    [+] Size: 8,388,608 bytes
    [+] Creating journal transaction log...
[+] debugfs -R logdump /dev/loopXp1
    [+] Log: /path/to/output/loopXp1_journal_log.txt

[*] Examining /dev/loopXp2
[+] blkid -o value -s TYPE /dev/loopXp2
    Filesystem: swap
    [-] Not a journaled EXT filesystem

[*] Examining /dev/loopXp3
[+] blkid -o value -s TYPE /dev/loopXp3
    Filesystem: ext4
[+] dumpe2fs -h /dev/loopXp3
    [+] Journal inode: 8
    [+] Dumping journal inode <8>...
[+] debugfs -R dump <8> /path/to/output/loopXp3_journal.bin /dev/loopXp3
    [+] Journal dumped successfully
    [+] Output: /path/to/output/loopXp3_journal.bin
    [+] Size: 8,388,608 bytes
    [+] Creating journal transaction log...
[+] debugfs -R logdump /dev/loopXp3
    [+] Log: /path/to/output/loopXp3_journal_log.txt

[+] Finished: extracted 2 EXT journal(s)
[+] Detaching /dev/loopX

The extracted journal files and corresponding transaction logs are written to the configured output directory:

$ ls -lh /path/to/output/

total 17M
-rw-r--r-- 1 root root 8.0M Sep 21 22:51 loopXp1_journal.bin
-rw-r--r-- 1 root root   71 Sep 21 22:51 loopXp1_journal_log.txt
-rw-r--r-- 1 root root 8.0M Sep 21 22:51 loopXp3_journal.bin
-rw-r--r-- 1 root root 5.0K Sep 21 22:51 loopXp3_journal_log.txt

The .bin files contain the raw EXT journal data, while the _journal_log.txt files contain the transaction information produced by debugfs logdump.
```

### jgrep — Journal Keyword Search and Context Extraction

jgrep searches an extracted filesystem journal for a user-supplied keyword and identifies matching content within the journal. For each match, it reports the byte offset, journal block, matching string, and surrounding hexadecimal/ASCII context to assist with forensic analysis and recovery of historical filesystem data.

```
$ python3 jgrep.py journal_output/loopXp3_journal.bin "example-script.sh"

[+] Search mode: single keyword
[+] Search terms loaded: 1
    - example-script.sh

[+] Journal: /path/to/journal_output/loopXp3_journal.bin
[+] Journal size: 8,388,608 bytes
[+] Block size: 1,024 bytes

[+] Extracting printable strings...
[+] Printable strings: 13,619
[+] Matching strings: 14

==============================================================================
MATCHES
==============================================================================

[+] Offset: 2051104 / 0x1f4c20
    Block: 2003
    Block offset: +0x020
    Matched: example-script.sh
    String: example-script.sh

[+] Offset: 2066464 / 0x1f8820
    Block: 2018
    Block offset: +0x020
    Matched: example-script.sh
    String: example-script.sh

[+] Offset: 2079776 / 0x1fbc20
    Block: 2031
    Block offset: +0x020
    Matched: example-script.sh
    String: example-script.sh

[+] Offset: 2087968 / 0x1fdc20
    Block: 2039
    Block offset: +0x020
    Matched: example-script.sh
    String: example-script.sh

[+] Offset: 2094112 / 0x1ff420
    Block: 2045
    Block offset: +0x020
    Matched: example-script.sh
    String: example-script.sh

[+] Additional matches omitted for brevity...

[+] Reports:
    /path/to/output/matches.txt
    /path/to/output/match_context.txt
    /path/to/output/matching_blocks.txt
    /path/to/output/all_strings.txt
    /path/to/output/search_terms.txt

For each match, jgrep also displays the surrounding journal data as a hexadecimal and ASCII dump:

==============================================================================
HIT @ 2087968 / 0x1fdc20
Matched: example-script.sh
String: 'example-script.sh'
------------------------------------------------------------------------------
001fdbe0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  |................|
001fdbf0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  |................|
001fdc00  32 07 00 00 0c 00 01 02 2e 00 00 00 cc 00 00 00  |2...............|
001fdc10  0c 00 02 02 2e 2e 00 00 33 07 00 00 18 00 0d 01  |........3.......|
001fdc20  65 78 61 6d 70 6c 65 2d 73 63 72 69 70 74 2e 73  |example-script.s|
001fdc30  68 00 00 00 34 07 00 00 38 00 12 01 73 61 6d 70  |h...4...8...samp|
001fdc40  6c 65 2d 66 69 6c 65 2e 74 78 74 00 00 00 00 00  |le-file.txt.....|
001fdc50  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  |................|
001fdc60  00 00 00 00 00 00 00 00 35 07 00 00 8c 03 03 01  |........5.......|
001fdc70  64 61 74 61 00 00 00 00 00 00 00 00 00 00 00 00  |data............|
001fdc80  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  |................|
001fdc90  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  |................|

This makes it easier to identify potentially relevant journal entries and inspect the raw bytes surrounding a match without manually locating each occurrence with tools such as grep and xxd.

The generated reports provide several views of the results:

matches.txt — summary of identified keyword matches and their offsets.
match_context.txt — hexadecimal and ASCII context surrounding each match.
matching_blocks.txt — journal blocks associated with the matches.
all_strings.txt — printable strings extracted from the journal.
search_terms.txt — search terms used during the analysis.

This can be useful during filesystem forensics when searching journal data for filenames, commands, usernames, indicators, configuration names, or other artifacts of interest.
```
