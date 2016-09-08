module View.Users.New exposing (view)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..), UserMsg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div, form, a, button, label)
import Html.Attributes exposing (href, class)
import Html.Events exposing (onClick)
import Html.App
import Material.List as List
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Grid exposing (grid, size, cell, Device(..))
import Form exposing (Form)
import Form.Field
import Form.Input
import Form.Error


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



--Html.App.map (UserMsg' << NewUserFormMsg) <| viewForm newUserForm
-- viewForm : Form () User -> Html Form.Msg
-- viewForm form =
--     let
--         -- error presenter
--         errorFor field =
--             case field.liveError of
--                 Just error ->
--                     -- replace toString with your own translations
--                     div [ class "error" ] [ text (toString error) ]
--
--                 Nothing ->
--                     text ""
--
--         -- fields states
--         name =
--             Form.getFieldAsString "name" form
--     in
--         div []
--             [ label [] [ text "Name" ]
--             , Input.textInput name []
--             , errorFor name
--             , button [ onClick Form.Submit ]
--                 [ text "Submit" ]
--             ]
--


nameField : Model -> Html Msg
nameField model =
    let
        name =
            Form.getFieldAsString "name" model.newUserForm

        conditionalProperties =
            case name.liveError of
                Just error ->
                    case error of
                        Form.Error.InvalidString ->
                            [ Textfield.error "Cannot be blank" ]

                        Form.Error.Empty ->
                            [ Textfield.error "Cannot be blank" ]

                        _ ->
                            [ Textfield.error <| toString error ]

                Nothing ->
                    []
    in
        Textfield.render Mdl
            [ 1, 0 ]
            model.mdl
            ([ Textfield.label "Name"
             , Textfield.floatingLabel
             , Textfield.text'
             , Textfield.value <| Maybe.withDefault "" name.value
             , Textfield.onInput <| UserMsg' << NewUserFormMsg << (Form.Field.Text >> Form.Input name.path)
             , Textfield.onFocus <| UserMsg' << NewUserFormMsg <| Form.Focus name.path
             , Textfield.onBlur <| UserMsg' << NewUserFormMsg <| Form.Blur name.path
             ]
                ++ conditionalProperties
            )


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 1, 1 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.colored
          --, Button.onClick <| UserMsg' CreateUser
        , Button.onClick <| UserMsg' <| NewUserFormMsg <| Form.Submit
        ]
        [ text "Submit" ]


cancelButton : Model -> Html Msg
cancelButton model =
    Button.render Mdl
        [ 1, 2 ]
        model.mdl
        [ Button.ripple
        , Button.onClick <| NavigateTo <| Just Users
        , Options.css "margin-left" "1rem"
        ]
        [ text "Cancel" ]
