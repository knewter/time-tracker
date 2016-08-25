module API exposing (fetchUsers, createUser, deleteUser, fetchUser)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Types exposing (User)
import Http
import Decoders
import Json.Decode exposing ((:=))
import Task
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))


fetchUsers : Model -> Cmd Msg
fetchUsers model =
    Http.get ("data" := Decoders.usersDecoder) (model.baseUrl ++ "/users")
        |> Task.perform (always (GotUsers [])) GotUsers


fetchUser : Int -> Model -> Cmd Msg
fetchUser id model =
    Http.get ("data" := Decoders.userDecoder) (model.baseUrl ++ "/users" ++ (toString id))
        |> Task.perform (always NoOp) GotUser


createUser : User -> Model -> Cmd Msg
createUser user model =
    Http.send Http.defaultSettings
        { verb = "POST"
        , url = model.baseUrl ++ "/users"
        , body = Http.string (encodeUser user |> JE.encode 0)
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> Http.fromJson ("data" := Decoders.userDecoder)
        |> Task.perform CreateFailed CreateSucceeded


deleteUser : User -> Model -> Cmd Msg
deleteUser user model =
    case user.id of
        Nothing ->
            Cmd.none

        Just id ->
            Http.send Http.defaultSettings
                { verb = "DELETE"
                , url = model.baseUrl ++ "/users/" ++ (toString id)
                , body = Http.empty
                , headers = [ ( "Content-Type", "application/json" ) ]
                }
                |> Task.perform DeleteFailed (always <| DeleteSucceeded user)


encodeUser : User -> JE.Value
encodeUser user =
    JE.object
        [ ( "user"
          , JE.object
                [ ( "name", JE.string user.name )
                ]
          )
        ]
