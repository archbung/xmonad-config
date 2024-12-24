-- vim:set ts=2 sts=2 sw=2 et:
module Main where

import           XMonad
import           XMonad.Actions.UpdatePointer
import           Graphics.X11.ExtraTypes.XF86
import           XMonad.Hooks.DynamicLog
import qualified XMonad.Hooks.EwmhDesktops as E
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.SetWMName
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.Spiral
import           XMonad.Layout.ThreeColumns
import           XMonad.Util.EZConfig

main :: IO ()
main = xmonad $ E.ewmh def
  { modMask     = modKey
  , terminal    = terminal
  , borderWidth = 3
  , startupHook = setWMName "LG3D"
  , manageHook  = composeAll
      [ manageHook def
      , role    =? "browser"  --> doShift "2"
      , role    =? "popup"    --> doFloat
      , appName =? "obsidian" --> doShift "1"
      , fullscreenManageHook
      ]
  , layoutHook  = let full     = fullscreenFull Full
                      tall     = Tall 1 (3/100) (1/2)
                      threeCol = ThreeCol 1 (3/100) (1/2)
                   in onWorkspace "9" full . smartBorders . avoidStruts $
                      tall ||| Mirror tall ||| threeCol ||| spiral (6/7) ||| full
  , logHook     = dynamicLogWithPP def >> updatePointer (0.75, 0.75) (0.75, 0.75)
  , handleEventHook = mconcat
      [ handleEventHook def
      , fullscreenEventHook
      ]
  }
  `additionalKeys`
  [ ((modKey, xK_p),                spawn menu)
  , ((0, xF86XK_AudioMute),         spawn "wpctl set-mute @DEFAULT_AUDIO_SINK@")
  , ((0, xF86XK_AudioRaiseVolume),  spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ +5%")
  , ((0, xF86XK_AudioLowerVolume),  spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ -5%")
  , ((0, xF86XK_MonBrightnessUp),   spawn "xbacklight -inc 5")
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")
  ]
  
  where
    role      = stringProperty "WM_WINDOW_ROLE"
    menu      = "rofi -combi-modi window,drun,ssh -font 'Inconsolata Nerd Font Mono 12' -show combi"
    modKey    = mod4Mask
    terminal  = "bash -c 'wmctrl -x -a alacritty || alacritty -e tmux'"

