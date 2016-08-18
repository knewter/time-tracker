module Msg exposing (Msg(..))

import Material
import Material.Snackbar as Snackbar
import Route


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | NavigateTo (Maybe Route.Location)
