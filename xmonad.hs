import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86

import XMonad
import XMonad.Layout.IndependentScreens
import qualified XMonad.StackSet as W


main :: IO ()
main = xmonad def
  { terminal    = "st"
  , modMask     = mod4Mask
  , borderWidth = 0
  , keys        = \c -> keys' c `M.union` keys def c
  , manageHook  = manageHook' <+> manageHook def
  , workspaces  = withScreens 2 $ map show [1..9]
  }
    where
      keys' conf = let modm = modMask conf in M.fromList $
        [ ((modm, xK_p),                  spawn "dmenu_run -fn 'Inconsolata-12'")
        , ((0, xF86XK_MonBrightnessUp),   spawn "light -A 5")
        , ((0, xF86XK_MonBrightnessDown), spawn "light -U 5")
        , ((0, xF86XK_AudioMute),         spawn "pamixer -t")
        , ((0, xF86XK_AudioRaiseVolume),  spawn "pamixer -i 5")
        , ((0, xF86XK_AudioLowerVolume),  spawn "pamixer -d 5")
        ]
        ++
        [ ((m .|. modm, k), windows $ onCurrentScreen f i)
          | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
          , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
        ]


      manageHook' = composeAll
        [ className =? "chromium" --> doShift "2"
        , className =? "Atom"     --> doShift "3"
        ]
