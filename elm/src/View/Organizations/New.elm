module View.Organizations.New exposing (view)

import Model exposing (Model)
import Types exposing (Organization)
import Msg exposing (Msg(..), OrganizationMsg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div, form, a)
import Html.Attributes exposing (href)
import Material.List as List
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Grid exposing (grid, size, cell, Device(..))


view : Model -> Html Msg
view model =
    grid []
        [ cell [ size All 12 ]
            [ nameField model ]
        , cell [ size All 12 ]
            [ submitButton model
            , cancelButton model
            ]
        ]


nameField : Model -> Html Msg
nameField model =
    Textfield.render Mdl
        [ 6, 0 ]
        model.mdl
        [ Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text'
        , Textfield.value model.newOrganization.name
        , Textfield.onInput <| OrganizationMsg' << SetNewOrganizationName
        ]


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 6, 1 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.colored
        , Button.onClick <| OrganizationMsg' CreateOrganization
        ]
        [ text "Submit" ]


cancelButton : Model -> Html Msg
cancelButton model =
    Button.render Mdl
        [ 6, 2 ]
        model.mdl
        [ Button.ripple
        , Button.onClick <| NavigateTo <| Just Organizations
        , Options.css "margin-left" "1rem"
        ]
        [ text "Cancel" ]
