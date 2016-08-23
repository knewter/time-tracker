module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Material
import Material.Snackbar as Snackbar
import Navigation
import Route exposing (Location(..))
import Http
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))
import Types exposing (User)
import Task
import Decoders


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg' ->
            Material.update msg' model

        Snackbar msg' ->
            let
                ( snackbar, snackCmd ) =
                    Snackbar.update msg' model.snackbar
            in
                { model | snackbar = snackbar } ! [ Cmd.map Snackbar snackCmd ]

        NavigateTo maybeLocation ->
            case maybeLocation of
                Nothing ->
                    model ! []

                Just location ->
                    model ! [ Navigation.newUrl (Route.urlFor location) ]

        GotUsers users ->
            { model | users = users } ! []

        SetNewUserName name ->
            let
                oldNewUser =
                    model.newUser
            in
                { model | newUser = { oldNewUser | name = name } } ! []

        CreateNewUser ->
            model ! [ createUser model.newUser CreateFailed CreateSucceeded ]

        CreateSucceeded _ ->
            { model | newUser = User "" }
                ! [ Navigation.newUrl (Route.urlFor Users) ]

        CreateFailed error ->
            let
                _ =
                    Debug.log "Create User failed: " error
            in
                model ! []


baseUrl : String
baseUrl =
    "http://localhost:4000"


createUser : User -> (Http.Error -> msg) -> (User -> msg) -> Cmd msg
createUser user errorMsg msg =
    Http.send Http.defaultSettings
        { verb = "POST"
        , url = baseUrl ++ "/users"
        , body = Http.string (encodeUser user |> JE.encode 0)
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> Http.fromJson ("data" := Decoders.userDecoder)
        |> Task.perform errorMsg msg


encodeUser : User -> JE.Value
encodeUser user =
    JE.object
        [ ( "user"
          , JE.object
                [ ( "name", JE.string user.name )
                ]
          )
        ]
