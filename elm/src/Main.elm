module Main exposing (..)

import Html.App as App
import Html exposing (Html, text)


type alias Model =
    {}


type Msg
    = NoOp


init : ( Model, Cmd Msg )
init =
    {} ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []


view : Model -> Html Msg
view model =
    text "this is an app I promise"


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
