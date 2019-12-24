module Main where

import           XMonad
import           XMonad.Hooks.ManageDocks
import qualified XMonad.Hooks.EwmhDesktops      as Ewmh
import           XMonad.Hooks.DynamicLog
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Spiral
import           XMonad.Util.EZConfig
import           XMonad.Actions.UpdatePointer


main :: IO ()
main  = xmonad =<< xmobar (Ewmh.ewmh def
  { terminal    = "termite"
  , modMask     = mod4Mask
  , borderWidth = 2
  , manageHook  = mconcat
        [ manageHook def
        , role =? "browser"     --> doShift "2"
        , role =? "pop-up"      --> doFloat
        , className =? "Steam"  --> doShift "9"
        , fullscreenManageHook
        ]
  , layoutHook  = smartBorders $ avoidStruts $
        (Tall 1 (3/100) (1/2)) |||
        (spiral (6/7)) |||
        (noBorders (fullscreenFull Full))
  , logHook     = dynamicLogWithPP def >> updatePointer (0.75, 0.75) (0.75, 0.75)
  , handleEventHook = mconcat
        [ handleEventHook def
        , fullscreenEventHook
        ]
  }
  `additionalKeysP`
  [ ("M-p",                     spawn menu)
  , ("M-S-l",                   spawn "i3lock -c 000000")
  , ("<XF86AudioMute>",         spawn "pamixer -t")
  , ("<XF86AudioRaiseVolume>",  spawn "pamixer -i 5")
  , ("<XF86AudioLowerVolume>",  spawn "pamixer -d 5")
  ])

    where
        role = stringProperty "WM_WINDOW_ROLE"
        menu = "rofi -show run -modi run \
                \ -location 1 -width 100 -lines 1 \
                \ -line-margin 0 -line-padding 1 \
                \ -separator-style none -font 'Inconsolata 11' \
                \ -columns 9 -bw 0 -hide-scrollbar -kb-row-select 'Tab' -kb-row-tab ''"
