module Msg exposing (Msg(..), UserMsg(..), ProjectMsg(..))

import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, UserSortableField, Project, ProjectSortableField)
import Http


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | UserMsg' UserMsg
    | ProjectMsg' ProjectMsg
    | NavigateTo (Maybe Route.Location)
    | NoOp


type UserMsg
    = GotUser User
    | GotUsers (List User)
    | SetNewUserName String
    | CreateUser
    | CreateUserSucceeded User
    | CreateUserFailed Http.Error
    | DeleteUser User
    | DeleteUserSucceeded User
    | DeleteUserFailed Http.RawError
    | ReorderUsers UserSortableField
    | SetShownUserName String
    | UpdateUser
    | UpdateUserFailed Http.Error
    | UpdateUserSucceeded User


type ProjectMsg
    = GotProject Project
    | GotProjects (List Project)
    | SetNewProjectName String
    | CreateProject
    | CreateProjectSucceeded Project
    | CreateProjectFailed Http.Error
    | DeleteProject Project
    | DeleteProjectSucceeded Project
    | DeleteProjectFailed Http.RawError
    | ReorderProjects ProjectSortableField
    | SetShownProjectName String
    | UpdateProject
    | UpdateProjectFailed Http.Error
    | UpdateProjectSucceeded Project
