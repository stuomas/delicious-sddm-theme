//Config file entries. Older versions of Qt don't support ES6 const modifier, so must be var until wider adpotion of Qt > 5.11
var cfgIconTheme = config.icontheme
var cfgBackground = "../background/" + config.background
var cfgFontFamily = config.fontfamily
var cfgFontColor = config.fontcolor
var cfgFontScale = config.fontscale
var cfgSessions = config.sessions
var cfgIconFormat = config.iconformat
var cfgIconColor = config.iconoverlay
var cfgIconGlowEnabled = (config.iconglow == "enable") ? true : false //Pending change to SDDM might break this in future
var cfgGlowColor = config.glowcolor

var iconPath = "../icons/" + cfgIconTheme + "/"
var backgroundType = parseBackgroundType(cfgBackground)
var isImage = parseBackgroundType(cfgBackground) === "image"
var isVideo = !isImage

function getIcon(session) 
{
    var sessionArray = cfgSessions.trim().split(",")
    for (var i in sessionArray) {
        if (session.toLowerCase().indexOf(sessionArray[i]) >= 0) {
            return sessionArray[i]
        }
    }
    console.log("NOTICE! One your your DE/WMs was not recognized and will not show correct icon. Add new sessions to sessionicons list in theme.conf")
    return "unlisted"
}

function parseBackgroundType(img)
{
    var vidFormats = ["avi", "mp4", "mov", "mkv", "m4v", "webm"]
    var fileExt = cfgBackground.split('.').pop()
    for (var i in vidFormats) {
        if (fileExt.toLowerCase().indexOf(vidFormats[i]) >= 0) {
            return "video"
        }
    }
    return "image"
}