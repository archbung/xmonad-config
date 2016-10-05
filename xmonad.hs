import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
import XMonad


main :: IO ()
main = xmonad def 
  { terminal    = "termite"
  , modMask     = mod4Mask
  , borderWidth = 0
  , keys        = \c -> keys' c `M.union` keys def c
  , manageHook  = manageHook' <+> manageHook def
  }
    where
      keys' XConfig { modMask = modm } = M.fromList
        [ ((modm, xK_p),                  spawn "dmenu_run -fn 'Inconsolata-11'")
        , ((0, xF86XK_MonBrightnessUp),   spawn "xbacklight +5")
        , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -5")
        , ((0, xF86XK_AudioMute),         spawn "pamixer -t")
        , ((0, xF86XK_AudioRaiseVolume),  spawn "pamixer -i 5")
        , ((0, xF86XK_AudioLowerVolume),  spawn "pamixer -d 5")
        ]

      manageHook' = composeAll
        [ className =? "chromium" --> doShift "2"
        ]
