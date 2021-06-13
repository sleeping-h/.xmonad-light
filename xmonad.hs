-- Core
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
import qualified System.IO
import Data.List
import Data.Ratio ((%))

-- Prompts
import XMonad.Prompt
import XMonad.Prompt.Shell

-- Actions
import XMonad.Actions.MouseGestures
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS

-- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.FadeInactive

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.DecorationMadness
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutHints
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Gaps
import XMonad.Layout.Tabbed
import XMonad.Layout.Groups.Examples


defaults = defaultConfig
        { terminal            = "terminator"
        , normalBorderColor   = "#cccccc"
        , focusedBorderColor  = "#ecbfcc"
        , workspaces          = myWorkspaces
        , modMask             = mod4Mask
        , startupHook         = myStartupHook
        , layoutHook          = myLayoutHook
        , borderWidth         = 1
        , handleEventHook     = fullscreenEventHook
        }  `additionalKeysP` myKeysP `additionalKeys` myKeys

myWorkspaces :: [String]

myWorkspaces = [ "one"  , "two"  , "three"
               , "four" , "five" , "six"
               , "seven", "eight", "nine" ]

myStartupHook :: X ()

myStartupHook = setWMName "XMonad"

myLayoutHook = gaps [(U, 20)] $ toggleLayouts (Full) $ smartBorders $
    resizable ||| resizable' ||| tiled
  where
    tiled = avoidStruts $ Mirror $ Tall 1 (3/100) (1/2)
    resizable = avoidStruts $ ResizableTall 1 (3/100) (1/2) []
    resizable' = let x = 10 in avoidStruts $ spacing x $
                 gaps [(U, x), (D, x), (R, x), (L, x)] $
                 ResizableTall 1 (3/100) (1/2) []

-- these are for my 40% keyboard:
myKeysP = [ ("M-q", windows $ W.greedyView "one")
          , ("M-w", windows $ W.greedyView "two")
          , ("M-e", windows $ W.greedyView "three")
          , ("M-r", windows $ W.greedyView "four")
          , ("M-u", windows $ W.greedyView "seven")
          , ("M-i", windows $ W.greedyView "eight")
          , ("M-o", windows $ W.greedyView "nine")
          ]

myKeys = [ ((mod4Mask, xK_Right), moveTo Next NonEmptyWS)
         , ((mod4Mask, xK_Left), moveTo Prev NonEmptyWS)
         , ((mod4Mask, xK_Up), moveTo Next EmptyWS)
         , ((mod4Mask, xK_a), sendMessage MirrorShrink)
         , ((mod4Mask, xK_z), sendMessage MirrorExpand)
         , ((mod4Mask, xK_g), goToSelected defaultGSConfig)
         , ((mod4Mask .|. shiftMask, xK_Right), shiftToNext >> nextWS)
         , ((mod4Mask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
         , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 5%+")
         , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 5%-")
         , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute 1 toggle")
         , ((0, xK_F5), spawn "pactl set-sink-mute 1 toggle")
         , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight - 10")
         , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight + 10")
         , ((mod4Mask, xK_p), spawn "dmenu_run -nf \"#555555\" -nb \"#ffffff\" -fn \"xft:DejaVu Sans:size=11:book:antialias=true\"")
         , ((mod4Mask, xK_y), spawn "terminator")
         , ((mod4Mask, xK_c), spawn "firefox")
         , ((mod4Mask, xK_f), spawn "firefox")
         --, ((mod4Mask, xK_Delete), spawn "pgrep -c zoom && killall zoom") -- || zoom")
         , ((mod4Mask, xK_Delete), spawn "/home/sleeping/.xmonad/zoom.sh")
         , ((controlMask, xK_Print), spawn "sleep 0.2; scrot `date +%s`.png -s -z -e 'mv $f ~/screenshots'")
         , ((0, xK_Print), spawn "scrot `date +%s`.png -z -e 'mv $f ~/screenshots'")
         ]

-- colors

xmobarFg    = "#222222"
xmobarBg    = "#cacaca"
blockColor  = "#ffffff"
myColor     = "#ba4e9f"
iconColor   = "#666666"
aaaaaa      = "#333333" -- text in the blocks

-- icons

icon name = wrap "<icon=/home/sleeping/.xmonad/icons/" "/>" name
leftCnr   = icon "cnr_left.xbm"
rightCnr  = icon "cnr_right.xbm"
leftCnr'  = icon "cnr_left_.xbm"
rightCnr' = icon "cnr_right_.xbm"

-- xmobar

block leftIcon rightIcon fg bg fontColor =
    xmobarColor fontColor fg . wrap (wrapIcon leftIcon) (wrapIcon rightIcon)
    where wrapIcon = xmobarColor fg bg

leftBlock = block leftCnr rightCnr
rightBlock = block leftCnr' rightCnr'
colorIcon name = xmobarColor iconColor blockColor $ icon name

xmobarCommands = [ xmobarColor myColor blockColor "<fn=2>%kbd%</fn>"
                 , colorIcon "spkr.xbm" ++ " %vol%"
                 , colorIcon "cpu.xbm" ++ "%cpu%"
                 , colorIcon "battery.xbm" ++ " %battery%"
                 , colorIcon "wifi.xbm" ++ " %network%"
                 , xmobarColor aaaaaa blockColor "%date%"
                 , xmobarColor aaaaaa blockColor "%time%"
                 ]

xmobarRight = (foldl (++) "" . map rightBlock') xmobarCommands
    where rightBlock' = rightBlock blockColor xmobarBg aaaaaa
xmobarTemplate = "%StdinReader% }{ " ++ xmobarRight ++ " "
xmobarPipe = "/usr/bin/xmobar -t \"" ++ xmobarTemplate ++ "\" ~/.xmonad/xmobar.hs"

-- main

main = spawnPipe xmobarPipe >>= \xmproc ->
    xmonad -- $ ewmh -- support for NET_ACTIVE_WINDOW
           $ defaults {
        logHook =  dynamicLogWithPP $ def
          { ppOutput    = System.IO.hPutStrLn xmproc
          , ppTitle     = xmobarColor xmobarFg "" . shorten 130
          , ppCurrent   = leftBlock blockColor xmobarBg myColor
          , ppHidden    = leftBlock blockColor xmobarBg aaaaaa
          , ppVisible   = leftBlock blockColor xmobarBg "#ffffff"
          , ppSep       = "  " -- between WSs and title
          , ppWsSep     = ""
          , ppLayout    = \_ -> ""
       -- , ppHiddenNoWindows = showNamedWorkspaces
          }
} where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       then pad wsId
                                       else ""
