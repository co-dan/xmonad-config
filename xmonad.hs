import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.StackSet (RationalRect(..))
import System.IO

startup = do
  spawn "/home/dan/.xmonadrc/remap.sh"
  
main = do
  xmproc <- spawnPipe "xmobar /home/dan/.xmobarrc" 
  xmonad $ defaultConfig
            { manageHook = (manageDocks <+> manageHook defaultConfig) <+> manageScratchPad
            , startupHook = startup
            , layoutHook = avoidStruts  $  layoutHook defaultConfig
            , modMask = mod4Mask
            , logHook =  dynamicLogWithPP xmobarPP
                              { ppOutput = hPutStrLn xmproc
                              , ppTitle = xmobarColor "white" "" . shorten 90 }
            } `additionalKeys`
            [ ((0, xK_Print), spawn "scrot")
            , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
            , ((mod4Mask .|. shiftMask, xK_r), scratchpadSpawnActionTerminal "x-terminal-emulator")
            ]

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (RationalRect l t w h)
  where
    h = 0.1     -- terminal height, 10%
    w = 1       -- terminal width, 100%
    t = 1 - h   -- distance from top edge, 90%
    l = 1 - w   -- distance from left edge, 0%
