module View.Users exposing (view)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..))
import Html exposing (Html, text)
import Material.List as List


view : Model -> Html Msg
view model =
    List.ul []
        (List.map (viewUserRow model) model.users)


viewUserRow : Model -> User -> Html Msg
viewUserRow model user =
    List.li []
        [ List.content []
            [ text user.name ]
        ]
