import Xmobar


zenburnRed      = "#CC9393"
zenburnBg       = "#1f1f1f"
zenburnFg       = "#989890"
zenburnYl       = "#F0DFAF"
zenburnGreen    = "#7F9F7F"
doomBg          = "#22242b"

defaultHeight :: Int
defaultHeight   = 24

config :: Config
config = defaultConfig
    { font              = "xft:Inconsolata:size=10:antialias=true"
    , bgColor           = doomBg
    , fgColor           = zenburnFg
    , position          = BottomSize C 100 defaultHeight
    , border            = NoBorder
    , alpha             = 255
    , overrideRedirect  = True
    , lowerOnStart      = True
    , hideOnStart       = False
    , allDesktops       = True
    , persistent        = True
    , sepChar           = "|"
    , alignSep          = "{}"
    , template          = "|StdinReader| {} |date|"
    , commands          =
        [ Run $ Date "%H:%M" "date" 5
        , Run StdinReader
        ]
    }

main :: IO ()
main = xmobar config
