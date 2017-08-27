module Main where

import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86

import XMonad
import XMonad.Hooks.DynamicLog
import qualified XMonad.StackSet as W


main :: IO ()
main = xmonad =<< statusBar myBar myPP toggleStrutKey myConfig

myBar = "xmobar"   

myPP  = xmobarPP { ppCurrent = xmobarColor "#d79921" "" . wrap "[" "]" }

toggleStrutKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

myConfig = defaultConfig
  { terminal    = "alacritty"
  , modMask     = mod4Mask
  , borderWidth = 2
  , keys        = \c -> keys' c `M.union` keys def c
  , manageHook  = manageHook' <+> manageHook def
  }
    where
      keys' conf = let modm = modMask conf in M.fromList $
        [ ((modm, xK_p),                  spawn "dmenu_run -fn 'Iosevka-12'")
        , ((0, xF86XK_MonBrightnessUp),   spawn "xbacklight +5")
        , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -5")
        , ((0, xF86XK_AudioMute),         spawn "amixer set Master toggle")
        , ((0, xF86XK_AudioRaiseVolume),  spawn "amixer set Master 5%+")
        , ((0, xF86XK_AudioLowerVolume),  spawn "amixer set Master 5%-")
        ]

      manageHook' = composeAll
        [ className =? "Chromium" --> doShift "2"
        ]
