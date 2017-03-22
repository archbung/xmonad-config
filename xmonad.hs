module Main where

import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86

import XMonad
import qualified XMonad.StackSet as W


main :: IO ()
main = xmonad def
  { terminal    = "alacritty"
  , modMask     = mod4Mask
  , borderWidth = 0
  , keys        = \c -> keys' c `M.union` keys def c
  , manageHook  = manageHook' <+> manageHook def
  }
    where
      keys' conf = let modm = modMask conf in M.fromList $
        [ ((modm, xK_p),                  spawn "dmenu_run -b -fn 'Inconsolata-12'")
        , ((0, xF86XK_MonBrightnessUp),   spawn "xbacklight +5")
        , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -5")
        , ((0, xF86XK_AudioMute),         spawn "ponymix toggle")
        , ((0, xF86XK_AudioRaiseVolume),  spawn "ponymix increase 5")
        , ((0, xF86XK_AudioLowerVolume),  spawn "ponymix decrease 5")
        ]

      manageHook' = composeAll
        [ className =? "Chromium" --> doShift "2"
        , className =? "Emacs"    --> doShift "3"
        ]
