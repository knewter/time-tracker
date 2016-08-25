module Model exposing (Model, init, cmdsForMaybeLocation)

import Msg exposing (Msg)
import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User)
import Api


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


init : Maybe Route.Location -> ( Model, Cmd Msg )
init location =
    (initialModel location) ! (cmdsForMaybeLocation location)


cmdsForMaybeLocation : Maybe Route.Location -> Cmd Msg
cmdsForMaybeLocation location =
    case location of
        Just (Route.Users) ->
            [ API.fetchUsers newModel ]

        Just (Route.ShowUser id) ->
            [ API.fetchUser id newModel ]

        _ ->
            []
