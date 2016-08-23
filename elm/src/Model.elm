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
    }


initialModel : Maybe Route.Location -> Model
initialModel location =
    { mdl = Material.model
    , snackbar = Snackbar.model
    , route = Route.init location
    , users = mockUsers
    , newUser = User ""
    }


init : Maybe Route.Location -> ( Model, Cmd Msg )
init location =
    (initialModel location) ! []


mockUsers : List User
mockUsers =
    [ { name = "Josh Adams" }, { name = "Adam Dill" } ]
