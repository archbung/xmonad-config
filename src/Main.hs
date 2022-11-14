module Main where

import XMonad
import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import qualified XMonad.Hooks.EwmhDesktops as E
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig

main :: IO ()
main = xmonad =<< xmobar (E.ewmh def
  { terminal    = "kitty"
  , modMask     = mod4Mask
  , borderWidth = 2
  , startupHook = setWMName "LG3D"
  , manageHook  = composeAll
    [ manageHook def
    , role =? "browser"   --> doShift "2"
    , role =? "popup"     --> doFloat
    , appName =? "Steam"  --> doShift "9"
    , appName =? "Emacs"  --> doShift "1"
    , fullscreenManageHook
    ]
  , layoutHook  = let full = noBorders (fullscreenFull Full)
                      tall = Tall 1 (3/100) (1/2)
                      threeCol = ThreeCol 1 (3/100) (1/2)
                   in onWorkspace "9" full . smartBorders . avoidStruts $
                      tall ||| Mirror tall ||| threeCol ||| spiral (6/7) ||| full
  , logHook     = dynamicLogWithPP def >> updatePointer (0.75, 0.75) (0.75, 0.75)
  , handleEventHook = mconcat
      [ handleEventHook def
      , fullscreenEventHook
      ]
  }
  `additionalKeysP`
  [ ("M-p", spawn menu)
  ])

  where
    role = stringProperty "WM_WINDOW_ROLE"
    menu = "dmenu_run -fn 'InconsolataGo Nerd Font Mono-12' -b"
