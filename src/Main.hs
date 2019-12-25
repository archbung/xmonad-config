module Main where

import           XMonad
import           XMonad.Hooks.ManageDocks
import qualified XMonad.Hooks.EwmhDesktops      as Ewmh
import           XMonad.Hooks.DynamicLog
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Spiral
import           XMonad.Layout.PerWorkspace
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
        , appName =? "zenity"   --> doFloat
        , fullscreenManageHook
        ]
  , layoutHook  = let full = noBorders (fullscreenFull Full)
                   in onWorkspace "9" full $ smartBorders $ avoidStruts $
                        (Tall 1 (3/100) (1/2)) ||| (spiral (6/7)) ||| full
  , logHook     = dynamicLogWithPP def >> updatePointer (0.75, 0.75) (0.75, 0.75)
  , handleEventHook = mconcat
        [ handleEventHook def
        , fullscreenEventHook
        ]
  }
  `additionalKeysP`
  [ ("M-p",                     spawn menu)
  , ("M-q",                     spawn "xmonad --restart")
  , ("M-S-l",                   spawn "i3lock -c 000000")
  , ("<XF86AudioMute>",         spawn "pamixer -t")
  , ("<XF86AudioRaiseVolume>",  spawn "pamixer -i 5")
  , ("<XF86AudioLowerVolume>",  spawn "pamixer -d 5")
  ])

    where
        role = stringProperty "WM_WINDOW_ROLE"
        menu = "rofi -combi-modi window,run -show combi -modi combi -hide-scrollbar"
