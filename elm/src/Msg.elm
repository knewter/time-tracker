module Msg exposing (Msg(..))

import Material
import Material.Snackbar as Snackbar


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
