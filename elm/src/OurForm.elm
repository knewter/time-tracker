module OurForm exposing (errorMessagesForTextfield)

import Material.Textfield as Textfield
import Form.Error
import Form exposing (FieldState)


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
