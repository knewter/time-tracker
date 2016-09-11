module Validators exposing (validateNewUser, validateNewOrganization)

import Form.Validate exposing (Validation, form1, get, string)
import Types exposing (User, Organization, APIFieldErrors)


validateNewUser : Validation String User
validateNewUser =
    form1 (User Nothing)
        (get "name" string)


validateNewOrganization : Validation String Organization
validateNewOrganization =
    form1 (Organization Nothing)
        (get "name" string)
