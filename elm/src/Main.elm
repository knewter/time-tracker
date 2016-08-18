module Main exposing (..)

import Navigation
import View
import Update
import Model exposing (Model)
import Route
import Msg exposing (Msg)


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
    { model | route = route } ! []
