module Msg exposing (Msg(..), UserMsg(..), ProjectMsg(..), OrganizationMsg(..))

import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, UserSortableField, Project, ProjectSortableField, Organization, OrganizationSortableField)
import Http


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | UserMsg' UserMsg
    | ProjectMsg' ProjectMsg
    | OrganizationMsg' OrganizationMsg
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


type OrganizationMsg
    = GotOrganization Organization
    | GotOrganizations (List Organization)
    | SetNewOrganizationName String
    | CreateOrganization
    | CreateOrganizationSucceeded Organization
    | CreateOrganizationFailed Http.Error
    | DeleteOrganization Organization
    | DeleteOrganizationSucceeded Organization
    | DeleteOrganizationFailed Http.RawError
    | ReorderOrganizations OrganizationSortableField
    | SetShownOrganizationName String
    | UpdateOrganization
    | UpdateOrganizationFailed Http.Error
    | UpdateOrganizationSucceeded Organization
