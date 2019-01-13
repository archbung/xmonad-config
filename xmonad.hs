module Main where

import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.Renamed
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns


myKeys conf = let modm = modMask conf in M.fromList
    [ ((modm, xK_p),                  spawn "dmenu_run -fn 'Inconsolata for Powerline-12' -b")
    , ((modm .|. shiftMask, xK_l),    spawn "i3lock -c 000000")
    , ((0, xF86XK_MonBrightnessUp),   spawn "xbacklight +5")
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -5")
    , ((0, xF86XK_AudioMute),         spawn "pamixer -t")
    , ((0, xF86XK_AudioRaiseVolume),  spawn "pamixer -i 5")
    , ((0, xF86XK_AudioLowerVolume),  spawn "pamixer -d 5")
    , ((0, xF86XK_Display),           spawn "multihead")
    ]

myManageHook = composeAll
    [ className =? "Chromium" --> doShift "3"
    , className =? "Firefox Developer Edition" --> doShift "2"
    , className =? "Nightly" --> doShift "2"
    , className =? "Emacs" --> doShift "1"
    ]

myLayout = avoidStruts (
    renamed [Replace "3C"] (ThreeColMid 1 (3/100) (3/4)) |||
    renamed [Replace "R!"] (Mirror (Tall 1 (3/100) (1/2))) |||
    --Mirror (Tall 1 (3/100) (1/2)) |||
    renamed [Replace "T" ] (tabbed shrinkText tabConfig) |||
    --Full |||
    --spiral (6/7) |||
    renamed [Replace "F" ] (noBorders (fullscreenFull Full)))

tabConfig = def
           
myConfig = def
  { terminal            = "kitty"
  , modMask             = mod4Mask
  , borderWidth         = 2
  , focusFollowsMouse   = False
  , keys                = \c -> myKeys c `M.union` keys def c
  , manageHook          = myManageHook <+> manageHook def
  , layoutHook          = smartBorders myLayout
  }

toggleStrutsKey XConfig { XMonad.modMask = modMask }  = (modMask, xK_b)

main :: IO ()
main  = xmonad =<< statusBar "xmobar" xmobarPP toggleStrutsKey myConfig

