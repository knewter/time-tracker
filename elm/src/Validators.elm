module Validators exposing (validateNewUser)

import Form.Validate exposing (Validation, form1, get, string)
import Types exposing (User, APIFieldErrors)


validateNewUser : Validation String User
validateNewUser =
    form1 (User Nothing)
        (get "name" string)
