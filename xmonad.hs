import XMonad
import qualified XMonad.StackSet as W
import XMonad.Layout.Renamed (renamed, Rename(..))
import XMonad.Layout.NoBorders (noBorders, lessBorders, Ambiguity(Screen))
import XMonad.Layout.Magnifier (magnifier, MagnifyMsg(..))
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Prompt
import XMonad.Prompt.Shell
import System.IO
import Data.Char (ord)

-- from https://github.com/ibotty/solarized-xmonad/blob/master/Solarized.hs
solarizedBase03  = "#002b36"
solarizedBase02  = "#073642"
solarizedBase01  = "#586e75"
solarizedBase00  = "#657b83"
solarizedBase0   = "#839496"
solarizedBase1   = "#93a1a1"
solarizedBase2   = "#eee8d5"
solarizedBase3   = "#fdf6e3"
solarizedYellow  = "#b58900"
solarizedOrange  = "#cb4b16"
solarizedRed     = "#dc322f"
solarizedMagenta = "#d33682"
solarizedViolet  = "#6c71c4"
solarizedBlue    = "#268bd2"
solarizedCyan    = "#2aa198"
solarizedGreen   = "#859900"

startup :: X ()
startup = do
  spawn "/home/d/.xmonad/remap.sh"
  spawn "/home/d/.xmonad/startup.sh"
  
main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar /home/d/.xmobarrc" 
  xmonad $ defaultConfig
            { manageHook = manageDocks <+> manageHook defaultConfig
                       	 <+> composeAll myManagementHooks
            , startupHook = setWMName "LG3D" >> startup
            , layoutHook = myLayoutHook
            , terminal   = "/usr/bin/xfce4-terminal"
            , workspaces = ["α","β","γ","δ","ε","ζ","η","θ"]
            , focusedBorderColor = myFocusedBorderColor
            , normalBorderColor = myNormalBorderColor
            , modMask = mod4Mask
            , logHook =  dynamicLogWithPP xmobarPP
                              { ppOutput = hPutStrLn xmproc
                              , ppSep = " :: "
                              , ppCurrent = xmobarColor solarizedBase01 "" . wrap "[" "]"
                              , ppTitle = xmobarColor solarizedBase0 "" 
                                          . shorten 90 
                                          . filter (\c -> ord c < 128) }
            } `additionalKeys`
            [ ((0, xK_Print), spawn "scrot")
            , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
	    , ((shiftMask .|. mod4Mask, xK_r), shellPrompt myXPConfig)
            ]


myNormalBorderColor = solarizedBase02
myFocusedBorderColor = solarizedBase01
myFgColor = solarizedBase1
myBgColor = solarizedBase03

myManagementHooks = [ resource =? "stalonetray" --> doIgnore
                    , isFullscreen   --> (doF W.focusDown <+> doFullFloat)
  -- , (className =? "Empathy") --> 
  ]

myXPConfig = defaultXPConfig { font = "xft:Ubuntu Mono-12"
                 , bgColor           = myBgColor
                 , fgColor           = myFgColor
                 , fgHLight          = myFgColor
                 , bgHLight          = myFocusedBorderColor
                 , borderColor       = myNormalBorderColor
                 , promptBorderWidth = 1
                 , position          = Bottom
                 , height            = 20
                 , historySize       = 256
                 }

myLayoutHook = avoidStruts (Full ||| tiled ||| Mirror tiled) 
               ||| rename "Fullscreen" ( noBorders (fullscreenFull Full) )
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100
     rename s = renamed [Replace s] . magnifier
