module View.Users.Edit exposing (view)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div)


view : Model -> Int -> Html Msg
view model id =
    text <| "Edit user " ++ (toString id)
