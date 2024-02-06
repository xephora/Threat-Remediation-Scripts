rule Detect_tsurtokiobinder {
    meta:
        description = "Detects tsurtokiobinder malware"
        author = "x3ph_"
        date = "2024-02-03"

    strings:
        $path1 = "G:\\RUST_DROPPER_EXE_PAYLOAD\\DROPPER_MAIN\\pe-tools\\src\\shared" nocase
        $path2 = "G:\\RUST_DROPPER_EXE_PAYLOAD\\DROPPER_MAIN\\pe-tools\\src\\x64.rs" nocase

    condition:
        filesize > 2MB and
        $path1 and
        $path2
}
