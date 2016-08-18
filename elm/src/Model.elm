module Model exposing (Model, init)

import Msg exposing (Msg)
import Material


type alias Model =
    { mdl : Material.Model
    }


initialModel : Model
initialModel =
    { mdl = Material.model
    }


init : ( Model, Cmd Msg )
init =
    initialModel ! []
