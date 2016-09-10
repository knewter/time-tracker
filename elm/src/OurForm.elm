module OurForm exposing (errorMessageTranslator)

import Material.Textfield as Textfield
import Form.Error


errorMessageTranslator field =
    case field.liveError of
        Just error ->
            case error of
                Form.Error.InvalidString ->
                    [ Textfield.error "Cannot be blank" ]

                Form.Error.Empty ->
                    [ Textfield.error "Cannot be blank" ]

                Form.Error.CustomError errString ->
                    [ Textfield.error errString ]

                _ ->
                    [ Textfield.error <| toString error ]

        Nothing ->
            []
