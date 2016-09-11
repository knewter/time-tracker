module View.Login exposing (view)

import Model exposing (Model)
import Msg exposing (Msg(..), LoginMsg(..))
import Html exposing (Html, text, div, form, a, button, label)
import Html.Attributes exposing (href, class)
import Html.Events exposing (onClick)
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Grid exposing (grid, size, cell, Device(..))
import Form exposing (Form)
import Form.Field
import Form.Input
import Form.Error
import OurForm


view : Model -> Html Msg
view model =
    grid []
        [ cell [ size All 12 ]
            [ usernameField model ]
        , cell [ size All 12 ]
            [ passwordField model ]
        , cell [ size All 12 ]
            [ submitButton model ]
        ]


usernameField : Model -> Html Msg
usernameField model =
    let
        ( form, apiErrors ) =
            model.loginForm

        username =
            Form.getFieldAsString "username" form
                |> OurForm.handleAPIErrors apiErrors
    in
        Textfield.render Mdl
            [ 7, 0 ]
            model.mdl
            ([ Textfield.label "Username"
             , Textfield.floatingLabel
             , Textfield.text'
             , Textfield.value <| Maybe.withDefault "" username.value
             , Textfield.onInput <| tagged << (Form.Field.Text >> Form.Input username.path)
             , Textfield.onFocus <| tagged <| Form.Focus username.path
             , Textfield.onBlur <| tagged <| Form.Blur username.path
             ]
                ++ OurForm.errorMessagesForTextfield username
            )


passwordField : Model -> Html Msg
passwordField model =
    let
        ( form, apiErrors ) =
            model.loginForm

        password =
            Form.getFieldAsString "password" form
                |> OurForm.handleAPIErrors apiErrors
    in
        Textfield.render Mdl
            [ 7, 1 ]
            model.mdl
            ([ Textfield.label "Password"
             , Textfield.floatingLabel
             , Textfield.password
             , Textfield.value <| Maybe.withDefault "" password.value
             , Textfield.onInput <| tagged << (Form.Field.Text >> Form.Input password.path)
             , Textfield.onFocus <| tagged <| Form.Focus password.path
             , Textfield.onBlur <| tagged <| Form.Blur password.path
             ]
                ++ OurForm.errorMessagesForTextfield password
            )


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 1, 1 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.colored
        , Button.onClick <| tagged Form.Submit
        ]
        [ text "Submit" ]


tagged : Form.Msg -> Msg
tagged =
    LoginMsg' << LoginFormMsg
