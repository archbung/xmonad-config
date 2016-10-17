import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86

import XMonad
import XMonad.Layout.IndependentScreens
import qualified XMonad.StackSet as W


main :: IO ()
main = xmonad def
  { terminal    = "termite -e fish"
  , modMask     = mod4Mask
  , borderWidth = 2
  , keys        = \c -> keys' c `M.union` keys def c
  , manageHook  = manageHook' <+> manageHook def
  }
    where
      keys' conf = let modm = modMask conf in M.fromList $
        [ ((modm, xK_p),                  spawn "dmenu_run -fn 'Inconsolata-12'")
        , ((0, xF86XK_MonBrightnessUp),   spawn "light -A 5")
        , ((0, xF86XK_MonBrightnessDown), spawn "light -U 5")
        , ((0, xF86XK_AudioMute),         spawn "ponymix toggle")
        , ((0, xF86XK_AudioRaiseVolume),  spawn "ponymix increase")
        , ((0, xF86XK_AudioLowerVolume),  spawn "ponymix decrease")
        ]
        ++
        [ ((m .|. modm, k), windows $ f i)
          | (i, k) <- zip (workspaces conf) [xK_1 .. xK_9]
          , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
        ]


      manageHook' = composeAll
        [ className =? "chromium" --> doShift "2"
        , className =? "Emacs"    --> doShift "3"
        ]
