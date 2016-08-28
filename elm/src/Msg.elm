module Msg exposing (Msg(..))

import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, UserSortableField)
import Http


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | NavigateTo (Maybe Route.Location)
    | GotUsers (List User)
    | SetNewUserName String
    | CreateNewUser
    | CreateSucceeded User
    | CreateFailed Http.Error
    | DeleteUser User
    | DeleteSucceeded User
    | DeleteFailed Http.RawError
    | GotUser User
    | ReorderUsers UserSortableField
    | SetShownUserName String
    | UpdateShownUser
    | UpdateFailed Http.Error
    | UpdateSucceeded User
    | NoOp
