module Main exposing (..)

import Html.App as App
import View
import Update
import Model exposing (Model)


main : Program Never
main =
    App.program
        { init = Model.init
        , update = Update.update
        , view = View.view
        , subscriptions = always Sub.none
        }
