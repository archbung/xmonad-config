-- vim:set ts=2 sts=2 sw=2 et:
import Xmobar

defaultHeight :: Int
defaultHeight = 24

config :: Config
config = defaultConfig
  { font              = "InconsolataGo Nerd Font Mono 12"
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
