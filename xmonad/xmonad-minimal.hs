import XMonad
import Graphics.X11.ExtraTypes.XF86
import qualified Data.Map as M

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [
    -- volume keys
    ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
    ]

main = xmonad def
    { terminal	= "alacritty"
    , modMask	= mod4Mask
    , keys = myKeys <+> keys def
    }





