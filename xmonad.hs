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
            , modMask = mod4Mask
            , logHook =  dynamicLogWithPP xmobarPP
                              { ppOutput = hPutStrLn xmproc
                              , ppTitle = xmobarColor "white" "" . shorten 90 }
            } `additionalKeys`
            [ ((0, xK_Print), spawn "scrot")
            , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
	    , ((shiftMask .|. mod4Mask, xK_r), shellPrompt myXPConfig)
            ]


myNormalBorderColor = "#333"
myFocusedBorderColor = "#fedb73"

myManagementHooks = [
  resource =? "stalonetray" --> doIgnore
  -- , (className =? "Empathy") --> 
  ]

myXPConfig = defaultXPConfig { font = "xft:Ubuntu Mono-12"
                 , bgColor           = myNormalBorderColor
                 , fgColor           = myFocusedBorderColor
                 , fgHLight          = "#000000"
                 , bgHLight          = "#BBBBBB"
                 , borderColor       = myFocusedBorderColor
                 , promptBorderWidth = 1
                 , position          = Bottom
                 , height            = 14
                 , historySize       = 256
                 }

myLayoutHook = avoidStruts (Full ||| tiled ||| Mirror tiled)
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100