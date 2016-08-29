module Msg exposing (Msg(..))

import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, UserSortableField, Project, ProjectSortableField)
import Http


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | NavigateTo (Maybe Route.Location)
    | GotUsers (List User)
    | SetNewUserName String
    | CreateNewUser
    | CreateUserSucceeded User
    | CreateUserFailed Http.Error
    | DeleteUser User
    | DeleteUserSucceeded User
    | DeleteUserFailed Http.RawError
    | GotUser User
    | ReorderUsers UserSortableField
    | SetShownUserName String
    | UpdateShownUser
    | UpdateUserFailed Http.Error
    | UpdateUserSucceeded User
    | GotProjects (List Project)
    | SetNewProjectName String
    | CreateNewProject
    | CreateProjectSucceeded Project
    | CreateProjectFailed Http.Error
    | DeleteProject Project
    | DeleteProjectSucceeded Project
    | DeleteProjectFailed Http.RawError
    | GotProject Project
    | ReorderProjects ProjectSortableField
    | SetShownProjectName String
    | UpdateShownProject
    | UpdateProjectFailed Http.Error
    | UpdateProjectSucceeded Project
    | NoOp
