module Model exposing (Model, init)

import Msg exposing (Msg)
import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User)


type alias Model =
    { mdl : Material.Model
    , snackbar : Snackbar.Model (Maybe Msg)
    , route : Route.Model
    , users : List User
    , newUser : User
    , baseUrl : String
    }


initialModel : Maybe Route.Location -> Model
initialModel location =
    { mdl = Material.model
    , snackbar = Snackbar.model
    , route = Route.init location
    , users = []
    , newUser = User Nothing ""
    , baseUrl = "http://localhost:4000"
    }


init : Maybe Route.Location -> ( Model, Cmd Msg )
init location =
    (initialModel location) ! []
