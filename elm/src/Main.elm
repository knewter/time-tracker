module Main exposing (..)

import Navigation
import View
import Update
import Model exposing (Model)
import Types exposing (User)
import Route
import Msg exposing (Msg(..))
import Task


main : Program Never
main =
    Navigation.program (Navigation.makeParser Route.locFor)
        { init = Model.init
        , update = Update.update
        , urlUpdate = urlUpdate
        , view = View.view
        , subscriptions = always Sub.none
        }


urlUpdate : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
urlUpdate route model =
    let
        newModel =
            { model | route = route }
    in
        case route of
            Just (Route.Users) ->
                -- Pretend we did an API call and it got us some new users
                newModel ! [ fetchUsers newModel ]

            _ ->
                newModel ! []


mockUser : User
mockUser =
    { name = "Jumpy McFiddlepants" }


fetchUsers : Model -> Cmd Msg
fetchUsers newModel =
    Task.perform
        (always <| GotUsers (mockUser :: newModel.users))
        (always <| GotUsers (mockUser :: newModel.users))
        (Task.succeed ())
