module OurForm exposing (errorMessagesForTextfield, handleAPIErrors)

import Material.Textfield as Textfield
import Form.Error
import Form exposing (FieldState)
import Dict
import String
import Types exposing (APIFieldErrors)


errorMessageTranslator : FieldState String String -> Maybe String
errorMessageTranslator field =
    case field.liveError of
        Just error ->
            case error of
                Form.Error.InvalidString ->
                    Just "Cannot be blank"

                Form.Error.Empty ->
                    Just "Cannot be blank"

                Form.Error.CustomError errString ->
                    Just errString

                _ ->
                    Just <| toString error

        Nothing ->
            Nothing


errorMessagesForTextfield : FieldState String String -> List (Textfield.Property a)
errorMessagesForTextfield field =
    case errorMessageTranslator field of
        Just errorString ->
            [ Textfield.error errorString ]

        Nothing ->
            []


handleAPIErrors : Maybe APIFieldErrors -> FieldState String String -> FieldState String String
handleAPIErrors apiErrors field =
    case apiErrors of
        Nothing ->
            field

        Just errorDict ->
            case ( field.isDirty, field.liveError /= Nothing ) of
                ( True, True ) ->
                    field

                ( False, True ) ->
                    field

                ( True, False ) ->
                    field

                ( _, False ) ->
                    case Dict.get "name" errorDict of
                        Nothing ->
                            field

                        Just errorList ->
                            { field | liveError = Just <| Form.Error.CustomError (String.join ", " errorList) }
