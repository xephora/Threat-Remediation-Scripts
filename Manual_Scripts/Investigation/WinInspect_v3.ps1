# investigate the following account below.  Please replace username with the target account.
$username = "USERNAME"

# File System - Startups
"[+]  Checking Startup Locations"
"C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
gci "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -fi "*.lnk" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
gci "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" -fi "*.lnk" -force -ErrorAction SilentlyContinue | % { $_.FullName }

# File System
"`n`n [+]  Checking Root Dir"
"C:\"
gci C:\ -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking ProgramData"
"C:\ProgramData"
gci "C:\ProgramData" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking Common Files"
"C:\program files\Common Files"
gci "C:\program files\Common Files" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking 32bit Common Files"
"C:\program files\Common Files (x86)"
gci "C:\program files (x86)\Common Files" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking Defender Antivirus Logs"
"C:\ProgramData\Microsoft\Windows Defender\Support"
$result = test-path -Path "C:\ProgramData\Microsoft\Windows Defender\Support"
if ($result -eq "True") {
	gci "C:\ProgramData\Microsoft\Windows Defender\Support" -fi "*.log" -force -ErrorAction SilentlyContinue | % { $_.FullName, "Size: $($_.length)"}
} else {
    "Failed to discover Defender.."
}

# Public profile
"`n`n [+]  Checking Public Profile"
"C:\Users\public"
gci "C:\Users\public\" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking Public Desktop"
"C:\Users\public\Desktop"
gci "C:\Users\public\Desktop" -force -ErrorAction SilentlyContinue | % { $_.FullName }

# User profile
"`n`n [+]  Checking User Profile"
"C:\Users\$username\"
gci "C:\Users\$username\" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  downloaded executables, msi packages and zip, rar, 7z compressed folders"
"C:\Users\$username\Downloads\"
gci C:\users\$username\Downloads -r -force -fi "*.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.msi" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.rar" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.7z" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.zip" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.iso" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Downloads -r -force -fi "*.vhd" -ErrorAction SilentlyContinue | % { $_.FullName }

"C:\Users\$username\Desktop\"
gci C:\users\$username\Desktop -r -force -fi "*.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.msi" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.rar" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.7z" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.zip" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.iso" -ErrorAction SilentlyContinue | % { $_.FullName }
gci C:\users\$username\Desktop -r -force -fi "*.vhd" -ErrorAction SilentlyContinue | % { $_.FullName }

"C:\Users\$username\Documents\"
gci "C:\users\$username\Documents" -r -force -fi "*.exe" -ErrorAction SilentlyContinue | % { $_.FullName }
gci "C:\users\$username\Documents" -r -force -fi "*.msi" -ErrorAction SilentlyContinue | % { $_.FullName }
gci "C:\users\$username\Documents" -r -force -fi "*.rar" -ErrorAction SilentlyContinue | % { $_.FullName }
gci "C:\users\$username\Documents" -r -force -fi "*.7z" -ErrorAction SilentlyContinue | % { $_.FullName }
gci "C:\users\$username\Documents" -r -force -fi "*.zip" -ErrorAction SilentlyContinue | % { $_.FullName }
gci "C:\users\$username\Documents" -r -force -fi "*.iso" -ErrorAction SilentlyContinue | % { $_.FullName }
gci "C:\users\$username\Documents" -r -force -fi "*.vhd" -ErrorAction SilentlyContinue | % { $_.FullName }

# User profile application folders
"`n`n [+]  Checking User's local application data"
"C:\Users\$username\appdata\local"
gci "C:\Users\$username\appdata\local" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Checking User's roaming application data"
"C:\Users\$username\appdata\roaming"
gci "C:\Users\$username\appdata\roaming" -force -ErrorAction SilentlyContinue | % { $_.FullName }

"`n`n [+]  Local Microsoft directory (Solarmarker Backdoor Drop path)"
"C:\users\$username\AppData\Local\Microsoft"
gci "C:\users\$username\AppData\Local\Microsoft" -force -ErrorAction SilentlyContinue | % { $_.FullName}

"`n`n [+]  Roaming Microsoft directory (Solarmarker Backdoor Common Drop path)"
"C:\users\$username\AppData\Roaming\Microsoft"
gci "C:\users\$username\AppData\Roaming\Microsoft" -force -ErrorAction SilentlyContinue | % { $_.FullName }

$exists = test-path "C:\Users\$username\appdata\local\programs"
if ($exists) {
    "`n`n Checking User's local Program directory"
    "C:\Users\$username\appdata\local\programs"
    gci "C:\users\$username\AppData\Local\programs" -force -ErrorAction SilentlyContinue | % { $_.FullName}
}

# FileSystem Scheduled Tasks
"`n`n [+]  Checking Scheduled Tasks"
"C:\windows\system32\tasks\"
gci "C:\windows\system32\tasks\" -force -ErrorAction SilentlyContinue | % { $_.FullName }

# System Registry Scheduled tasks
"`n`n [+]  Checking System Registries - Scheduled Tasks"
"Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE"
(get-item -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\TREE").GetSubKeyNames()

# System Registries
"`n`n [+]  Checking System Registries SOFTWARE"
Get-Item -Path HKLM:\Software\* | % { $_.Name }

"`n`n [+]  Checking System Registries Startup"
"HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
(get-item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Run).GetValueNames()

$sid_list = Get-Item -Path "Registry::HKU\*" | Select-String -Pattern "S-\d-(?:\d+-){5,14}\d+"
foreach ($j in $sid_list) {
    if ($j -notlike "*_Classes*") {
        "`n`n [+]  Checking User Registries SID"
        "$j\Software"
        (Get-Item -Path Registry::$j\Software).GetSubKeyNames()
        "`n`n [+]  Checking User Startup Registries SID"
        "$j\Software\Microsoft\Windows\CurrentVersion\Run"
        (Get-Item -Path Registry::$j\Software\Microsoft\Windows\CurrentVersion\Run).GetValueNames()
    }
}

# Chrome History File
"`n`n [+]  Checking for Chrome History Files"
$historylist = @(gci "C:\users\$username\AppData\Local\google\Chrome\User Data" -r -fi "history" | % { $_.FullName }); 
foreach ($hfile in $historylist) {
    $exists = test-path $hfile
    if ($exists) { 
        $hfile 
    } 
}

# Edge and IE History File
"`n`n [+]  Checking for Internet Explorer / Edge History File"
$result = test-path -Path "C:\Users\$username\AppData\Local\Microsoft\Windows\WebCache\WebCacheV01.dat"
if ($result -eq "True") {
    "Internet Explorer/Microsoft Edge History file in C:\Users\$username\AppData\Local\Microsoft\Windows\WebCache\WebCacheV01.dat"
}

# Check for profile processes
"`n`n [+] Checking Profile-based processes"
Get-Process | select Name, Id, Path | where {($_.Path -like "*appdata\local*") -or ($_.Path -like "*appdata\roaming*") -or ($_.Path -like "ProgramData")}

# Detect Browser Activity
"`n`n [+]  Browsers Detected"
Get-Process chrome -ErrorAction SilentlyContinue | % { $_.ProcessName,"PID: $($_.Id)",$_.Description,$_.Company,$_.Path }
Get-Process iexplore -ErrorAction SilentlyContinue | % { $_.ProcessName,"PID: $($_.Id)",$_.Description,$_.Company,$_.Path }
Get-Process msedge -ErrorAction SilentlyContinue | % { $_.ProcessName,"PID: $($_.Id)",$_.Description,$_.Company,$_.Path }
Get-Process firefox -ErrorAction SilentlyContinue | % { $_.ProcessName,"PID: $($_.Id)",$_.Description,$_.Company,$_.Path }

# Running Services
"`n`n [+] Checking for running services"
get-service | select ServiceName,DisplayName,Status,CanStop | where { $_.Status -eq "Running" }

# Enumerate Virtual Disk Images
"`n`n [+] Checking for Virtual Disk Images"
Get-WmiObject -Class Win32_logicaldisk -ErrorAction SilentlyContinue

# Enumerating Chrome Extensions
"`n`n [+] Checking for Chrome Extensions"
$extensionlist = @{
    "nmmhkkegccagdldgiimedpiccmgmieda" = "Google Wallet"
    "efaidnbmnnnibpcajpcglclefindmkaj" = "Adobe Acrobat: PDF edit, convert, sign tools"
    "ghbmnnjooekpmoecnnnilnnbdlolhkhi" = "Google Docs Offline"
    "aapbdbdomjkkjkaonfhkkikfgjllcleb" = "Google Translate"
    "jfbnmfgkohlfclfnplnlenbalpppohkm" = "Roblox+"
    "bmnlcjabgnpnenekpadlanbbkooimhnj" = "Honey"
    "cfhdojbkjhnklbpkdaibdccddilifddb" = "Adblock Plus - free ad blocker"
    "lpcaedmchfhocbbapmcbpinfpgnhiddi" = "Google Keep"
    "hdokiejnpimakedhajhdlcegeplioahd" = "LastPass: Free Password Manager"
    "ifbmcpbgkhlpfcodhjhdbllhiaomkdej" = "Office - Enable Copy and Paste"
    "mkaakpdehdafacodkgkpghoibnmamcme" = "Google Drawings"
    "ecnphlgnajanjnkcmbpancdjoidceilk" = "Kami for Google Chrome"
    "ndjpnladcallmjemlbaebfadecfhkepb" = "Microsoft 365"
    "gpaiobkfhnonedkhhfjpmhdalgeoebfa" = "Microsoft Editor: Spelling & Grammar Checker"
    "pbjikboenpfhbbejgkoklgkhjpfogcam" = "Amazon Assistant for Chrome"
    "jkompbllimaoekaogchhkmkdogpkhojg" = "DS Amazon Quick View"
    "lkpbokpjdbhikkdfjopoaiekpigepfjl" = "Minecraft Skins Search"
    "nbkbaafmiooegfmjglgknmjipoijejmb" = "Minecraft New Tab"
    "adbacgifemdbhdkfppmeilbgppmhaobf" = "RoPro - Enhance Your Roblox Experience"
    "hbkpclpemjeibhioopcebchdmohaieln" = "BTRoblox - Making Roblox Better"
    "lajchlhgfdaopdpingpkefbggcegkgla" = "Roblox Pro"
    "kbfnbcaeplbcioakkpcpgfkobkghlhen" = "Grammarly: Grammar Checker and Writing App"
    "jlhmfgmfgeifomenelglieieghnjghma" = "Cisco Webex"
    "ifbdadgbpalmagalacllfaflfakmfkac" = "Cisco Webex Content Sharing"
    "llllflgakifpdcmoanonghipldcpaggn" = "Webex Calling for Chrome"
    "inomeogfingihgjfjlpeplalcfajhgai" = "Chrome Remote Desktop"
    "dilkdnaihnkfembidikggnigimnbjcjn" = "NetSupport Manager Client"
    "ahmpjcflkgiildlgicmcieglgoilbfdp" = "Free Download Manager"
    "klmiibolojjndggdnjnjggmgimlcalch" = "Image Downloader - Bulk download images"
    "gddbgllpilhpnjpkdbopahnpealaklle" = "video downloader - CocoCut"
    "jmfikkaogpplgnfjmbjdpalkhclendgd" = "Save to Facebook"
    "fdgfkebogiimcoedlicjlajpkdmockpc" = "Meta Pixel Helper"
    "elicpjhcidhpjomhibiffojpinpmmpil" = "Video Downloader Professional"
    "ohfgljdgelakfkefopgklcohadegdpjf" = "Smallpdf - Edit, Compress and Convert PDF"
    "cifnddnffldieaamihfkhkdgnbhfmaci" = "Foxit PDF Creator"
    "cmedhionkhpnakcndndgjdbohmhepckk" = "Adblock for Youtube"
    "gebbhagfogifgggkldgodflihgfeippi" = "Return YouTube Dislike"
    "lgjdgmdbfhobkdbcjnpnlmhnplnidkkp" = "Autoskip for Youtube"
    "annfbnbieaamhaimclajlajpijgkdblo" = "Dark Theme for Google Chrome"
    "bpconcjcammlapcogcnnelfmaeghhagj" = "Nimbus Screenshot & Screen Video Recorder"
    "ejfmffkmeigkphomnpabpdabfddeadcb" = "Vimeo Record - Screen & Webcam Recorder"
    "flmihfcdcgigpfcfjpdcniidbfnffdcf" = "Screence screen recorder"
    "edlifbnjlicfpckhgjhflgkeeibhhcii" = "Screenshot Tool - capture & editor"
    "gkojfkhlekighikafcpjkiklfbnlmeio" = "Hola VPN - The Website Unblocker"
    "fcfhplploccackoneaefokcmbjfbkenj" = "Free VPN for Chrome by 1clickVPN"
    "bihmplhobchoageeokmgbdihknkjbknd" = "Touch VPN - Secure and unlimited VPN proxy"
    "hkampnclnabbnaeoeiipmmnimgfagpop" = "Speed VPN for PC"
    "aefkjchbonkicckpiebkmalmccogopoc" = "Global VPN Theme"
    "kgjfgplpablkjnlkjmjdecgdpfankdle" = "Zoom Scheduler"
    "ajneghihjbebmnljfhlpdmjjpifeaokc" = "Zoom Plus"
    "lajondecmobodlejlcjllhojikagldgd" = "Zoom for Google Chrome"
    "bkdgflcldnnnapblkhphbgpggdiikppg" = "DuckDuckGo Privacy Essentials"
    "keodbianoliadkoelloecbhllnpiocoi" = "Hide My IP VPN"
    "bgnkhhnnamicmpeenaelnjfhikgbkllg" = "AdGuard AdBlocker"
    "lklmhefoneonjalpjcnhaidnodopinib" = "Crystal Ad block"
    "bkkbcggnhapdmkeljlodobbkopceiche" = "Pop up blocker for Chrome"
    "jfhbealifiddpdbakoaogajmffjdonie" = "Ultimate Ad Blocker"
    "nngceckbapebfimnlniiiahkandclblb" = "Bitwarden - Free Password Manager"
    "caljgklbbfbcjjanaijlacgncafpegll" = "Avira Password Manager"
    "fdpohaocaechififmbbbbbknoalclacl" = "GoFullPage - Full Page Screen Capture"
    "liecbddmkiiihnedobmlmillhodjkdmb" = "Loom – Screen Recorder & Screen Capture"
    "nlipoenfbbikpbjkfpfillcgkoblgpmj" = "Awesome Screenshot and Screen Recorder"
    "cmfijaapnnkcglahdngmjnhkfnkihkbg" = "Affirm: Buy Now, Pay Later"
    "liindccgkpdcafeceonflfdmkjhijapj" = "Zip buy now, pay later"
    "mfidniedemcgceagapgdekdbmanojomk" = "Coupert - Automatic Coupon Finder & Cashback"
    "eofcbnmajmjmplflapaojjnihcjkigck" = "Avast SafePrice | Comparison, deals, coupons"
    "pnedebpjhiaidlbbhmogocmffpdolnek" = "CouponBirds - SmartCoupon Coupon Finder"
    "npknlajilknlnfgeihkpdaaeonbdcnia" = "VK video saver - загрузчик видео из вконтакте"
    "cnojnbdhbhnkbcieeekonklommdnndci" = "Search by Image"
    "eekbbmglbfldjpgbmajenafphnfjonnc" = "TinySketch"
    "jghecgabfgfdldnmbfkhmffcabddioke" = "Volume Master"
    "gcoekeoenehjmndhkdnoomdjeaclkhbe" = "Nearpod for Classroom"
    "oaobmlmjmhedmlphfdmdjpppjmcljnkp" = "Add to Google Classroom"
    "ifkgpacemihiplnocjocpgmoiefcojik" = "Alice Keeler Classroom Split"
    "mclkkofklkfljcocdinagocijmpgbhab" = "Google Input Tools"
    "ipikiaejjblmdopojhpejjmbedhlibno" = "SwiftRead - read faster, learn more"
    "mgijmajocgfcbeboacabfgobmjgjcoja" = "Google Dictionary (by Google)"
    "pfinjbgedbminlmlocobhemokhjobhbi" = "FivData - Freelancer Assistant"
    "njmehopjdpcckochcggncklnlmikcbnb" = "Helium 10"
    "bcjindcccaagfpapjjmafapmmgkkhgoa" = "JSON Formatter"
    "lmhkpmbekcpmknklioeibfkpmmfibljd" = "Redux DevTools"
    "blipmdconlkpinefehnmjammfjpmpbjk" = "Lighthouse"
    "ogdlpmhglpejoiomcodnpjnfgcpmgale" = "Custom Cursor for Chrome"
    "iginnfkhmmfhlkagcmpgofnjhanpmklb" = "Boxel Rebound"
    "fadndhdgpmmaapbmfcknlfgcflmmmieb" = "FrankerFaceZ"
    "mefhakmgclhhfbdadeojlkbllmecialg" = "Tabby Cat"
    "anflghppebdhjipndogapfagemgnlblh" = "Cute Cursors - Custom Cursor for Chrome"
    "akimgimeeoiognljlfchpbkpfbmeapkh" = "Google Arts & Culture"
    "ejgnolahdlcimijhloboakpjogbfdkkp" = "Meow, The Cat Pet"
    "pjafcgbpdclmdeiipolenjgkikeldljl" = "Chrome Piano"
    "laookkfknpbbblfpciffpaejjkokdgca" = "Momentum"
    "pnjaodmkngahhkoihejjehlcdlnohgmp" = "RSS Feed Reader"
    "ngeokhpbgoadbpdpnplcminbjhdecjeb" = "UV Weather"
    "kfimphpokifbjgmjflanmfeppcjimgah" = "RSS Reader Extension (by Inoreader)"
    "ippnbhhbamibfpljlfmgogaondodicgi" = "Current Moon Phase"
    "kpkpmhddkhdnajjlkbkilakdobnfgopl" = "Techgenyz - Technology News, Daily Updates"
    "ndhinffkekpekljifjkkkkkhopnjodja" = "Feedly Mini"
    "oihdhfbfoagfkpcncinlbhfdgpegcigf" = "Image Size Info"
    "hliiefogghiapfajokakaehafbdpokgh" = "Unsplash For Chrome"
    "gefiaaeadjbmhjndnhedfccdjjlgjhho" = "Enhanced Image Viewer"
    "lcpkicdemehhmkjolekhlglljnkggfcf" = "imgur Uploader"
    "bhloflhklmhfpedakmangadcdofhnnoh" = "Earth View from Google Earth"
    "nnjjahlikiabnchcpehcpkdeckfgnohf" = "Fatkun Batch Download Image"
    "figkalbjanhcadgaeehekgbpecbchlek" = "PhotoPad Photo Editor Cloud Edition"
    "hgmhmanijnjhaffoampdlllchpolkdnj" = "Hunter - Email Finder Extension"
    "haebnnbpedcbhciplfhjjkbafijpncjl" = "TinEye Reverse Image Search"
    "hkligngkgcpcolhcnkgccglchdafcnao" = "Web Archives"
    "giihipjfimkajhlcilipnjeohabimjhi" = "SEO Minion"
    "hhnjkanigjoiglnlopahbbjdbfhkndjk" = "Power Thesaurus"
    "fpnmgdkabkmnadcjpehmlllkndpkmiak" = "Wayback Machine"
    "cpodebcggidjigndghagpkepglfbhali" = "AliExpress Search By Image"
    "chhjbpecpncaggjpdakmflnfcopglcmi" = "Rakuten: Get Cash Back For Shopping"
    "hfapbcheiepjppjbnkphkmegjlipojba" = "Klarna | Shop now. Pay later."
    "ghnomdcacenbmilgjigehppbamfndblo" = "The Camelizer"
    "edjkecefjhobekadlkdkopkggdefpgfp" = "Smarty"
    "gngocbkfmikdgphklgmmehbjjlfgdemm" = "SwagButton"
    "jpdapbcmfllbpojmkefcikllfeoahglb" = "Slickdeals: Automatic Coupons and Deals"
    "gpdjojdkbbmdfjfahjcgigfpmkopogic" = "Pinterest Save Button"
    "lifbcibllhkdhoafpjfnlhfpfgnpldfl" = "Skype"
    "bfgdeiadkckfbkeigkoncpdieiiefpig" = "Bitmoji"
    "ipdjnhgkpapgippgcgkfcbpdpcgifncb" = "Emoji Keyboard by JoyPixels"
    "cfidkbgamfhdgmedldkagjopnbobdmdn" = "Social Blade"
    "andgibkjiikabclfdkecpmdkfanpdapf" = "GIPHY for Gmail"
    "ndnaehgpjlnokgebbaldlmgkapkpjkkb" = "Email Tracker for Gmail, Mail Merge-Mailtrack"
    "mfmkedeaebcckihpinmhkadoagdbifaa" = "Basketball Box Scores"
    "pkejgpgaflkeonkliblcplomemekogop" = "GeoPrinter"
    "adicaaffkmhgnfheifkjhopmambgfihl" = "FUTBIN"
    "ijhlikjoigjegofbedmfmlcfkmhabldh" = "ESPNCricinfo"
    "pfneigogocifpmjngcpbhfmjhbckjcao" = "Are You Watching This?!"
    "dcdhimjnicocbcjhmfcjlooncidccanl" = "Replay It"
    "mkindbniefmmhpmcelmkhcpaaieeddml" = "Click and Roll"
    "oledoejmoabfeenmmacihejabhmbhdan" = "r/soccer goals"
    "gojbdfnpnhogfdgjbigejoaolejmgdhk" = "OneNote Web Clipper"
    "jdlkkmamiaikhfampledjnhhkbeifokk" = "PDF Viewer"
    "cbcfbhjolgdaepkoaoepejclfggmdand" = "Word Bank"
    "lkhfeoafdgbaecajkdbioenncjopbpmk" = "IPP / CUPS printing for Chrome & Chromebooks"
    "pmaionhboofajejhmkheilkoifkmigfe" = "IPP/CUPS printing for G Suite admins"
    "lbeamcaffnnnmepjmpggnegdbammbfgc" = "skedula"
    "oocalimimngaihdkbihfgmpkcpnmlaoa" = "Netflix Party is now Teleparty"
}

if (test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\default") {
    $defaultExtensions = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\default\extensions" -r -fi "manifest.json" | % { $_.FullName})
    foreach ($extension in $defaultExtensions) {
        if (test-path $extension) {
            foreach ($dprofile in $extension) {
                "`nPath: $dprofile"
                foreach ($key in $extensionlist.Keys) {
                    $val = $extensionlist[$key]
                    if ($dprofile -like "*$key*") {
                        "Extension: $key -> $val"
                    }
                }
            }
        }
    }
}

if (test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\Profile*") {
    $profiles = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\Profile*").Name
    foreach ($profile in $profiles) {
        if(test-path "C:\Users\$username\appdata\local\Google\chrome\User Data\$profile") {
            "`n[+] chrome profile $profile on profile $username"
            $ProfilesExtensions = @(gci "C:\Users\$username\appdata\local\Google\chrome\User Data\$profile\extensions" -r -fi "manifest.json" | % { $_.FullName})
            foreach ($cprofile in $ProfilesExtensions) {
                "`nPath: $cprofile"
                foreach ($key in $extensionlist.Keys) {
                    $val = $extensionlist[$key]
                    if ($cprofile -like "*$key*") {
                        "Extension: $key -> $val"
                    }
                }
            }
        }
    }
}
