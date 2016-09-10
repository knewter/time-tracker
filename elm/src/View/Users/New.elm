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
import String
import Dict
import OurForm


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
    let
        rawName =
            Form.getFieldAsString "name" (fst model.newUserForm)
                |> Debug.log "rawName"

        apiErrors =
            (snd model.newUserForm)

        name =
            case apiErrors of
                Nothing ->
                    rawName

                Just errorDict ->
                    case ( rawName.isDirty, rawName.liveError /= Nothing ) of
                        ( True, True ) ->
                            rawName

                        ( False, True ) ->
                            rawName

                        ( True, False ) ->
                            rawName

                        ( _, False ) ->
                            case Dict.get "name" errorDict of
                                Nothing ->
                                    rawName

                                Just errorList ->
                                    { rawName | liveError = Just <| Form.Error.CustomError (String.join ", " errorList) }
    in
        Textfield.render Mdl
            [ 1, 0 ]
            model.mdl
            ([ Textfield.label "Name"
             , Textfield.floatingLabel
             , Textfield.text'
             , Textfield.value <| Maybe.withDefault "" name.value
             , Textfield.onInput <| tagged << (Form.Field.Text >> Form.Input name.path)
             , Textfield.onFocus <| tagged <| Form.Focus name.path
             , Textfield.onBlur <| tagged <| Form.Blur name.path
             ]
                ++ OurForm.errorMessageTranslator name
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


tagged : Form.Msg -> Msg
tagged =
    UserMsg' << NewUserFormMsg
