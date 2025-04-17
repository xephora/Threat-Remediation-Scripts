# I created a quick cloud scanner to check if a host has any known malicious Chrome extensions. Please specify the username in question.
# reference: https://x.com/tuckner/status/1912616945284788246
# reference: https://secureannex.com/blog/searching-for-something-unknow/
$username = "username_here"

$KnownExtensions = @{
    'odccobbfnngplckpongkahajfjpnbcck' = 'Fire Shield Secure Search'
    'afefmfbcccnppcaiebpmbpmddhilkkdi' = 'Fire Shield Chrome Safety'
    'oaljkhbgbedmfoiieocoenglpaeogjmf' = 'Safe Search for Chrome™'
    'ndajnaaobjaganokllcgbapngenfbgkc' = 'Fire Shield Extension Protection'
    'okjdbeegldeilceaflghgfdemobmfhbd' = 'Browser Checkup for Chrome by Doctor'
    'jhigofkbdbndeooldpdhmphldaglejlh' = 'Protecto for Chrome™'
    'pmgmbeeafpdjjhmeaalneginpmdhamhe' = 'Unbiased Search by Protecto'
    'eobcealmgdjeoheieiobkedbgddicaba' = 'Securify Your Browser'
    'lnedcnepmplnjmfdiclhbfhneconamoj' = 'Web Privacy Assistant'
    'gadjnphfolikkffmppnicebdfimlblkj' = 'Securify Kid Protection'
    'njfkgeajknkffkngdmjmjninkbgjedlo' = 'Bing Search by Securify'
    'eldjnmdpkecnjjkmmgndpcibgkfpodfh' = 'Browse Securely for Chrome™'
    'omieocempinhilcpbmnfdaamgomapded' = 'Better Browse by SecurySearch'
    'ilgbcnkedmncjlhpfconadpjnhlflejf' = 'Check My Permissions for Chrome'
    'okggiiagcegdfiajlkodohfkeemnjlnd' = 'Website Safety for Chrome'
    'jgajjllfidghjkjfipmjbaegafkdpfha' = 'MultiSearch for Chrome™'
    'gpibjjfllodpcfhcjpamonnblkbinbie' = 'Global Search for Chrome™'
    'hpdpddnfjaacnbcnoohlcipfafkbmdja' = 'Map Search for Chrome™'
    'lljnhidbljbfkejjcfogkhgmgdihjmlf' = 'Watch Tower Overview'
    'gclgncjpanihjpbjbecgfmfnipggcckn' = 'Incognito Shield for Chrome™'
    'cpehflfpgdgofpocagbdeecjlfhjfjdh' = 'In Site Search for Chrome™'
    'mdenajpfccjjjnbochgkdahmnipfpelc' = 'Privacy Guard for Chrome™'
    'eoclijfghiglinncpceohgaigfgnlbim' = 'Yahoo Search by Ghost'
    'cghdfcbncfjhleinblpalngjhojokjeo' = 'Private Search for Chrome™'
    'jeahgicmhigopdgilnmclihdjjlhnmop' = 'Total Safety for Chrome™'
    'edbhdbhgdbanjhdnpjcianjgfmdkgbcf' = 'Data Shield for Chrome'
    'jjnfhbcilcppomkcmkbbmcadoihkkgah' = 'Browser WatchDog for Chrome'
    'dmnajaiijohbndidolbdbpicdjanombo' = 'Incognito Search for Chrome™'
    'gpghebehjahceknfdcfifeifhdbongld' = 'Web Results for Chrome™'
    'gidejehfgombmkfflghejpncblgfkagj' = 'Cuponomia - Coupon and Cashback'
    'koolcjajfdkjjfklmidahmcjhcmmkhma' = 'Securify for Chrome™'
    'gijlkeaijpeaoihdajcgmiajeoonnkoj' = 'Securify Advanced Web Protection'
    'kldgaejigkhpgmfglbamggiglngkifck' = 'News Search for Chrome™'
    'ojlhcbolfcndnojcjhhjgmdblnojgefm' = 'SecuryBrowse for Chrome™'
    'kiecdaoopedhfgapicmpebbhodepnbbp' = 'Choose Your Chrome Tools'
    'dmakkciciccnjgmfjflpbdfkdnmpfghp' = 'Securify Viewpoint Search™'
    'ebhcaliljppmelancooakfgcgcceiind' = 'Quick Manuals for Chrome™'
    'eekblbhfmladafbmpgkdedmolbjkjbnc' = 'Search Images on Chrome™'
    'ejkdgndbgpfcaggpmnijcbddlnmdnpka' = 'Givero Search for Chrome™'
    'fojomppheellamdaddnbgommepnlkooh' = 'Secured Connection by SecuryBrowse'
    'gmbebpcapalekeaoekfhpbioilghcfmp' = 'AI Browser Manager™'
    'ndcphhjcebhifabfmebineokbfdnbphm' = 'Protected Browsing on Chrome™'
    'oghbffaoaooigagpockijkpfpgmnibkh' = 'ChatGPT Search for Chrome™'
    'oppeaknhldjjnfnflbcedipjbnbimhhf' = 'Games Search for Chrome™'
    'pcfapghfanllmbdfiipeiihpkojekckk' = 'Address Checker for Chrome™'
    'lfmdddfdacgdimongmjclgijepoknmjm' = 'Recipe Search for Chrome™'
    'pmannhofeaiadkcdbcebhnkcnkjjnfpn' = 'Search Safely by SecurySearch'
    'lkbfbidpkbeicafnnhlaockggaknjolf' = 'SecurySearch for Chrome'
    'adjpoipklnhlapjijccnemdhkcphcegd' = 'Website Orientations'
    'dkcjihabohaldgjkdmenepolojcjdaah' = 'Protecto Whois Search™'
    'iiegilogjnagependdonbfcmfmmaamon' = 'Productive Search for Chrome™'
    'aiaaeimmjjeceodjpficfnjckenedbon' = 'Secure Search for Chrome™'
    'alogdolelipkojjgggejccalcbdioolg' = 'Yahoo SecurySearch™'
    'fchgahponkgfomlgieipannlfanfbfak' = 'ProtectMyInfo for Chrome™'
    'ldanhaibkdifncinbpjdjpambmofmpkf' = 'Advanced Search for Chrome™'
    'aehjmdkbfemaefoebbihbfcmhehgimcl' = 'New Tab for Chrome™'
}

function Resolve-LocaleString {
    param(
        [string]$LocaleDir,
        [string]$Placeholder
    )

    if ($Placeholder -notmatch '^__MSG_(.+)__$') { return $Placeholder }
    $key = $Matches[1]

    $msgFile = Join-Path $LocaleDir 'messages.json'
    if (-not (Test-Path $msgFile)) { return $Placeholder }

    try {
        $msgs = Get-Content $msgFile -Raw | ConvertFrom-Json
        if ($msgs.$key.message) { return $msgs.$key.message }
    } catch { }
    return $Placeholder
}

function Get-ManifestName {
    param([string]$ManifestPath)

    try {
        $json = Get-Content $ManifestPath -Raw | ConvertFrom-Json
        $name = $json.name
        if ($name -match '^__MSG_') {
            # look for an English locale first, else first available locale
            $base     = Split-Path $ManifestPath -Parent
            $locale   = Get-ChildItem (Join-Path $base '_locales') -Directory -ErrorAction SilentlyContinue |
                        Where-Object { $_.Name -eq 'en' } |
                        Select-Object -First 1
            if (-not $locale) {
                $locale = Get-ChildItem (Join-Path $base '_locales') -Directory -ErrorAction SilentlyContinue |
                          Select-Object -First 1
            }
            if ($locale) {
                $resolved = Resolve-LocaleString $locale.FullName $name
                if ($resolved) { $name = $resolved }
            }
        }
        return $name
    } catch { return $null }
}

function Enumerate-ProfileExtensions {
    param (
        [string]   $ProfilePath,
        [hashtable]$Known
    )

    $extRoot = Join-Path $ProfilePath 'extensions'
    if (-not (Test-Path $extRoot)) { return }

    Get-ChildItem $extRoot -Recurse -Filter manifest.json -ErrorAction SilentlyContinue |
        ForEach-Object {
            $manifest = $_.FullName
            $extId    = ($manifest -split '\\extensions\\')[1].Split('\')[0]

            if ($Known.ContainsKey($extId)) {
                Write-Output "`n[KNOWN]  Path: $manifest  ->  $($Known[$extId])"
            }
        }
}

$base = "C:\Users\$username\AppData\Local\Google\Chrome\User Data"

Enumerate-ProfileExtensions (Join-Path $base 'Default') $KnownExtensions

Get-ChildItem $base -Directory -Filter 'Profile*' -ErrorAction SilentlyContinue |
    ForEach-Object {
        Enumerate-ProfileExtensions $_.FullName $KnownExtensions
    }
