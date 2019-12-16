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

import XMonad.Actions.UpdatePointer


myMenu = "rofi -show run -modi run \
    \ -location 7 -width 100 -lines 1 \
    \ -line-margin 0 -line-padding 1 \
    \ -separator-style none -font 'Input Mono Narrow 11' \
    \ -columns 9 -bw 0 -hide-scrollbar -kb-row-select 'Tab' -kb-row-tab ''"

myKeys conf = let modm = modMask conf in M.fromList
    [ ((modm, xK_p),                  spawn myMenu)
    , ((modm .|. shiftMask, xK_l),    spawn "i3lock -c 000000")
    , ((0, xF86XK_MonBrightnessUp),   spawn "xbacklight +5")
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -5")
    , ((0, xF86XK_AudioMute),         spawn "pamixer -t")
    , ((0, xF86XK_AudioRaiseVolume),  spawn "pamixer -i 5")
    , ((0, xF86XK_AudioLowerVolume),  spawn "pamixer -d 5")
    , ((0, xF86XK_Display),           spawn "multihead")
    ]

myManageHook = composeAll
    [ className =? "firefoxdeveloperedition" --> doShift "web"
    , className =? "Emacs" --> doShift "main"
    , className =? "Chromium" --> doShift "web"
    , className =? "Steam" --> doShift "fun"
    , className =? "Slack" --> doShift "comm"
    , className =? "Zenity" --> doFloat
    ]

myLayout = avoidStruts (
    renamed [Replace "R"] (Tall 1 (3/100) (1/2)) |||
    renamed [Replace "S" ] (spiral (6/7)) |||
    renamed [Replace "3C"] (ThreeColMid 1 (3/100) (3/4)) |||
    --Mirror (Tall 1 (3/100) (1/2)) |||
    renamed [Replace "T" ] (tabbed shrinkText def) |||
    --Full |||
    renamed [Replace "F" ] (noBorders (fullscreenFull Full)))

main :: IO ()
main  = xmonad $ def
  { terminal            = "termite"
  , modMask             = mod4Mask
  , borderWidth         = 2
  , focusFollowsMouse   = False
  , keys                = \c -> myKeys c `M.union` keys def c
  , manageHook          = myManageHook <+> manageHook def
  , layoutHook          = smartBorders myLayout
  , workspaces          = ["main", "web", "code", "4", "5", "6", "7", "comm", "fun", "scratch"]
  }
