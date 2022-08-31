module.exports = {
    url: "./entranceapp.html",
    searchingUrl: "http://appupdate.herokuapp.com/psr?s=<SUBID>&q=[KEYWORDS]",
    ua: "UA-179065509-38",
    loadingAnimation: true,
    searchInput: false,
    minimizingSendingToTray: false,
    userAgent: "", 
    muteOnMinimize: false,
    muteOnTray: true,
    muteOnFocusLost: true, 
    startMuted: false,
    showAppAsPopup: true,
    exitButtonQuitsTheApp: false,
    exitTaskBarQuitsTheApp: false,
    customBackgroundColor: "#626266",
    stars: false,
    startMaximized: false,
    nwdisable: false,
    downloadable: false,
    alerts: false,
    trayExternalLink: "https://www.msn.com/health",
    pkg: {
        title: "Energy", 
        version: "1.0", 
        width: 300,
        height: 47,
        min_width: 300,
        min_height: 47,
        max_width: 300,
        max_height: 47,
        shouldOverrideMaxSizes: false,
        disableMaximizeButton: false,
        transparent: true, 
        opacity: 0.85, 
        noui: true, 
        startupPosition: "center", 
        startOnTray: true
    },
    plugins:
    {
        flash: false,
        widevine: false
    },
    specialLoad: function(scope) {

    }
}
