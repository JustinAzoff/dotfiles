import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Actions.CycleWS 
import System.Exit

import qualified XMonad.Prompt         as P
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S
import XMonad.Prompt.Shell
-- import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Window

--import XMonad.Util.Scratchpad
import XMonad.Layout.Tabbed
import XMonad.ManageHook

searchEngineMap method = M.fromList $
    [ ((0, xK_g), method S.google)
--    , ((0, xK_h), method S.hoogle)
    , ((0, xK_w), method S.wikipedia)
    ]



-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
     ,((modm, xK_F2), spawn $ XMonad.terminal conf)
 
    --launch commands
    --, ((modm,               xK_p     ), spawn "exe=`dmenu_path | dmenu -b` && eval \"exec $exe\"")
    , ((modm,               xK_e     ), shellPrompt P.defaultXPConfig)
    , ((modm, xK_grave), prompt ("xterm" ++ " -e") P.defaultXPConfig)
    , ((modm .|. shiftMask, xK_t     ), prompt ("twyt" ++ " tweet") P.defaultXPConfig)
 
    -- launch gmrun
    --, ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
 
    -- close focused window 
    , ((modm .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modm,               xK_k     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modm,               xK_j     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    -- TODO, update this binding with avoidStruts , ((modm , xK_b ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), restart "xmonad" True)
    -- moving workspaces
    , ((modm               , xK_Left  ),    prevWS )
    , ((modm               , xK_Right ),    nextWS )
    , ((modm .|. shiftMask, xK_Left  ),    shiftToPrev >> prevWS)
    , ((modm .|. shiftMask, xK_Right ),    shiftToNext >> nextWS)

    , ((modm               , xK_Down ),    toggleWS )
    , ((modm,  xK_g     ), windowPromptGoto  P.defaultXPConfig )
    , ((modm , xK_b     ), windowPromptBring P.defaultXPConfig)
    --, ((modm, xK_grave),    scratchpadSpawnAction conf)

    -- Search commands
     , ((modm, xK_s), SM.submap $ searchEngineMap $ S.promptSearch P.defaultXPConfig)
     , ((modm .|. shiftMask, xK_s), SM.submap $ searchEngineMap $ S.selectSearch)
  
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    -- ++
    -- I wish I had 3 screens..  :-)
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myLayouts = simpleTabbed ||| tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

--myManageHook = scratchpadManageHook (W.RationalRect 0 0 1 0.3) <+> manageHook gnomeConfig

main = xmonad $ gnomeConfig {
    terminal = "x-terminal-emulator"
  , modMask = mod4Mask
  , keys = myKeys
  , layoutHook = ewmhDesktopsLayout $ avoidStruts $ myLayouts
  --  manageHook = myManageHook
}
