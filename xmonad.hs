import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.StackSet (RationalRect(..))
import XMonad.Prompt
import XMonad.Prompt.Shell
import System.IO

startup = do
  spawn "/home/d/.xmonad/remap.sh"
  spawn "/home/d/.xmonad/startup.sh"
  
main = do
  xmproc <- spawnPipe "xmobar /home/d/.xmobarrc" 
  xmonad $ defaultConfig
            { manageHook = manageDocks <+> manageHook defaultConfig
                       	 <+> composeAll myManagementHooks
            , startupHook = startup
            , layoutHook = myLayoutHook
            , workspaces = ["α","β","γ","δ","ε","ζ","η","θ"]
            , focusedBorderColor = myFgColor
            , normalBorderColor = myFocusedBorderColor
            , modMask = mod4Mask
            , logHook =  dynamicLogWithPP xmobarPP
                              { ppOutput = hPutStrLn xmproc
                              , ppSep = " :: "
                              , ppCurrent = xmobarColor "#f0c674" "" . wrap "[" "]"
                              , ppTitle = xmobarColor "white" "" . shorten 90 }
            } `additionalKeys`
            [ ((0, xK_Print), spawn "scrot")
            , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
	    , ((shiftMask .|. mod4Mask, xK_r), shellPrompt myXPConfig)
            ]


myNormalBorderColor = "#282a2e"
myFocusedBorderColor = "#373b41"
myFgColor = "#c5c8c6"
myBgColor = "#1d1f21" 

myManagementHooks = [
  resource =? "stalonetray" --> doIgnore
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
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100
