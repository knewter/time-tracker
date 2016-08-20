module Main exposing (..)

import Navigation
import View
import Update
import Model exposing (Model)
import Types exposing (User)
import Route
import Msg exposing (Msg(..))
import Task
import Material
import Http
import Decoders


main : Program Never
main =
    Navigation.program (Navigation.makeParser Route.locFor)
        { init = Model.init
        , update = Update.update
        , urlUpdate = urlUpdate
        , view = View.view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdl model


urlUpdate : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
urlUpdate route model =
    let
        newModel =
            { model | route = route }
    in
        case route of
            Just (Route.Users) ->
                -- Pretend we did an API call and it got us some new users
                newModel ! [ fetchMockUsers newModel ]

            _ ->
                newModel ! []


fetchUsers : Model -> Cmd Msg
fetchUsers model =
    -- This "error condition" that just says we got no users is dumb, we should log something and inform the UI
    Task.perform (always (GotUsers [])) GotUsers (Http.get Decoders.usersDecoder "http://localhost:4000/users")


fetchMockUsers : Model -> Cmd Msg
fetchMockUsers model =
    Task.perform
        (always <| GotUsers (mockUser :: model.users))
        (always <| GotUsers (mockUser :: model.users))
        (Task.succeed ())


mockUser : User
mockUser =
    { name = "Jumpy McFiddlepants" }
