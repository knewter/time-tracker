module View exposing (view)

import Html exposing (Html, text)
import Model exposing (Model)
import Msg exposing (Msg(..))


view : Model -> Html Msg
view model =
    text "this is an app I promise"
