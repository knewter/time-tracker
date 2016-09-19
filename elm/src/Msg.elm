module Msg exposing (Msg(..), UserMsg(..), ProjectMsg(..), OrganizationMsg(..), LoginMsg(..))

import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, UserSortableField, Project, ProjectSortableField, Organization, OrganizationSortableField, UsersListView)
import Http
import OurHttp
import Form


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | UserMsg' UserMsg
    | ProjectMsg' ProjectMsg
    | OrganizationMsg' OrganizationMsg
    | LoginMsg' LoginMsg
    | NavigateTo (Maybe Route.Location)
    | ClearApiKey
    | NoOp


type LoginMsg
    = LoginFormMsg Form.Msg
    | LoginSucceeded String
    | LoginFailed OurHttp.Error


type UserMsg
    = GotUser User
    | GotUsers (List User)
    | CreateUserSucceeded User
    | CreateUserFailed OurHttp.Error
    | DeleteUser User
    | DeleteUserSucceeded User
    | DeleteUserFailed Http.RawError
    | ReorderUsers UserSortableField
    | SetShownUserName String
    | UpdateUser
    | UpdateUserFailed OurHttp.Error
    | UpdateUserSucceeded User
    | NewUserFormMsg Form.Msg
    | SwitchUsersListView UsersListView


type ProjectMsg
    = GotProject Project
    | GotProjects (List Project)
    | CreateProjectSucceeded Project
    | CreateProjectFailed OurHttp.Error
    | DeleteProject Project
    | DeleteProjectSucceeded Project
    | DeleteProjectFailed Http.RawError
    | ReorderProjects ProjectSortableField
    | SetShownProjectName String
    | UpdateProject
    | UpdateProjectFailed OurHttp.Error
    | UpdateProjectSucceeded Project
    | NewProjectFormMsg Form.Msg


type OrganizationMsg
    = GotOrganization Organization
    | GotOrganizations (List Organization)
    | CreateOrganizationSucceeded Organization
    | CreateOrganizationFailed OurHttp.Error
    | DeleteOrganization Organization
    | DeleteOrganizationSucceeded Organization
    | DeleteOrganizationFailed Http.RawError
    | ReorderOrganizations OrganizationSortableField
    | SetShownOrganizationName String
    | UpdateOrganization
    | UpdateOrganizationFailed OurHttp.Error
    | UpdateOrganizationSucceeded Organization
    | NewOrganizationFormMsg Form.Msg
