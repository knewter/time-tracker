module Model exposing (Model, initialModel)

import Msg exposing (Msg)
import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User)


type alias Model =
    { mdl : Material.Model
    , snackbar : Snackbar.Model (Maybe Msg)
    , baseUrl : String
    , route : Route.Model
    , users : List User
    , newUser : User
    , shownUser : Maybe User
    }


initialModel : Maybe Route.Location -> Model
initialModel location =
    { mdl = Material.model
    , snackbar = Snackbar.model
    , baseUrl = "http://localhost:4000"
    , route = Route.init location
    , users = []
    , newUser = User Nothing ""
    , shownUser = Nothing
    }
