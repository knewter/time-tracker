module Model exposing (Model, init)

import Msg exposing (Msg)
import Material
import Material.Snackbar as Snackbar


type alias Model =
    { mdl : Material.Model
    , snackbar : Snackbar.Model (Maybe Msg)
    }


initialModel : Model
initialModel =
    { mdl = Material.model
    , snackbar = Snackbar.model
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! []
