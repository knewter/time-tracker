module View.Users exposing (view)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div, a)
import Html.Attributes exposing (href)
import Material.List as List
import Material.Button as Button
import Material.Icon as Icon
import Json.Decode as JD


view : Model -> Html Msg
view model =
    div []
        [ addUserButton model
        , List.ul []
            (List.indexedMap (viewUserRow model) model.users)
        ]


viewUserRow : Model -> Int -> User -> Html Msg
viewUserRow model index user =
    let
        attributes =
            case user.id of
                Nothing ->
                    []

                Just id ->
                    [ href (Route.urlFor (ShowUser id)) ]
    in
        List.li []
            [ List.content []
                [ a attributes [ text user.name ]
                , deleteButton model index user
                ]
            ]


addUserButton : Model -> Html Msg
addUserButton model =
    Button.render Mdl
        [ 0, 0 ]
        model.mdl
        [ Button.fab
        , Button.colored
        , Button.ripple
        , Button.onClick <| NavigateTo <| Just NewUser
        ]
        [ Icon.i "add" ]


deleteButton : Model -> Int -> User -> Html Msg
deleteButton model index user =
    Button.render Mdl
        [ 0, 1, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.onClick <| DeleteUser user
        ]
        [ Icon.i "delete" ]
