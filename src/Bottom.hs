import Xmobar

zenburnFg, doomBg :: String
zenburnFg       = "#989890"
doomBg          = "#22242b"

defaultHeight :: Int
defaultHeight   = 24

config :: Config
config = defaultConfig
    { font              = "InconsolataGo Nerd Font Mono 12"
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
