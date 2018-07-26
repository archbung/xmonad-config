module Main where

import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Actions.UpdatePointer
import qualified XMonad.StackSet as W


main :: IO ()
main = xmonad =<< statusBar myBar myPP toggleStrutKey myConfig

myBar = "xmobar"

myPP  = xmobarPP { ppCurrent = xmobarColor "#d79921" "" . wrap "[" "]" }

toggleStrutKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

myConfig = def
  { terminal    = "termite"
  , modMask     = mod4Mask
  , borderWidth = 2
  , focusFollowsMouse = False
  , keys        = \c -> keys' c `M.union` keys def c
  , manageHook  = manageHook' <+> manageHook def
  }
    where
      keys' conf = let modm = modMask conf in M.fromList $
        [ ((modm, xK_p),                  spawn "dmenu_run -fn 'Inconsolata-12' -b")
        , ((modm .|. shiftMask, xK_l),    spawn "i3lock -c 000000")
        , ((0, xF86XK_MonBrightnessUp),   spawn "xbacklight +5")
        , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -5")
        , ((0, xF86XK_AudioMute),         spawn "ponymix toggle")
        , ((0, xF86XK_AudioRaiseVolume),  spawn "ponymix increase 5")
        , ((0, xF86XK_AudioLowerVolume),  spawn "ponymix decrease 5")
        , ((0, xF86XK_Display),           spawn "multihead")
        ]

      manageHook' = composeAll
        [ className =? "Chromium" --> doShift "3"
        , className =? "Firefox Developer Edition" --> doShift "2"
        , className =? "Nightly" --> doShift "2"
        , className =? "Emacs" --> doShift "1"
        ]
