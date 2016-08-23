module View.Users.New exposing (view)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div, form)
import Material.List as List
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Grid exposing (grid, size, cell, Device(..))


view : Model -> Html Msg
view model =
    grid []
        [ cell [ size All 12 ]
            [ nameField model ]
        , cell [ size All 12 ]
            [ submitButton model ]
        ]


nameField : Model -> Html Msg
nameField model =
    Textfield.render Mdl
        [ 1, 0 ]
        model.mdl
        [ Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text'
        , Textfield.value model.newUser.name
        , Textfield.onInput SetNewUserName
        ]


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 1, 1 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.colored
        , Button.onClick CreateNewUser
        ]
        [ text "Submit" ]
