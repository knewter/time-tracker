module View.Users exposing (view)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div)
import Material.List as List
import Material.Button as Button
import Material.Icon as Icon


view : Model -> Html Msg
view model =
    div []
        [ addUserButton model
        , List.ul []
            (List.map (viewUserRow model) model.users)
        ]


viewUserRow : Model -> User -> Html Msg
viewUserRow model user =
    List.li []
        [ List.content []
            [ text user.name ]
        ]


addUserButton : Model -> Html Msg
addUserButton model =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Button.fab
        , Button.colored
        , Button.ripple
        , Button.onClick <| NavigateTo <| Just NewUser
        ]
        [ Icon.i "add" ]
