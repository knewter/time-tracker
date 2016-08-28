module View.Users.Edit exposing (view)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div)
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Grid exposing (grid, size, cell, Device(..))


view : Model -> Int -> Html Msg
view model id =
    case model.shownUser of
        Nothing ->
            text "No user here, sorry bud."

        Just user ->
            div []
                [ h2 [] [ text <| "Edit user " ++ (toString id) ]
                , grid []
                    [ cell [ size All 12 ]
                        [ nameField model ]
                    , cell [ size All 12 ]
                        [ submitButton model ]
                    ]
                ]


nameField : Model -> Html Msg
nameField model =
    Textfield.render Mdl
        [ 2, 0 ]
        model.mdl
        [ Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text'
        , Textfield.value <| Maybe.withDefault "" <| Maybe.map .name model.shownUser
        , Textfield.onInput SetShownUserName
        ]


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 2, 1 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.colored
        , Button.onClick UpdateShownUser
        ]
        [ text "Submit" ]
