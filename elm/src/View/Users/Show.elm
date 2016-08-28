module View.Users.Show exposing (view)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div, a)
import Html.Attributes exposing (href)
import Route exposing (Location(..))


view : Model -> Int -> Html Msg
view model id =
    case model.shownUser of
        Nothing ->
            text "No user here, sorry bud."

        Just user ->
            div []
                [ h2 [] [ text user.name ]
                , div [] [ a [ href <| Route.urlFor (EditUser id) ] [ text "Edit" ] ]
                , div [] [ a [ href <| Route.urlFor Users ] [ text "Users" ] ]
                ]
