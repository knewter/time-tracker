module Msg exposing (Msg(..), UserMsg(..), ProjectMsg(..), OrganizationMsg(..), LoginMsg(..))

import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, UserSortableField, Project, ProjectSortableField, Organization, OrganizationSortableField, UsersListView, Paginated)
import Http
import OurHttp
import Form
import RemoteData exposing (RemoteData)
import Date exposing (Date)


type Msg
    = Mdl (Material.Msg Msg)
    | Snackbar (Snackbar.Msg (Maybe Msg))
    | UserMsg' UserMsg
    | ProjectMsg' ProjectMsg
    | OrganizationMsg' OrganizationMsg
    | LoginMsg' LoginMsg
    | NavigateTo (Maybe Route.Location)
    | ClearApiKey
    | GotChartData (List ( Date, Float ))
    | NoOp


type LoginMsg
    = LoginFormMsg Form.Msg
    | LoginSucceeded String
    | LoginFailed OurHttp.Error


type UserMsg
    = GotUser User
    | GotUsers (RemoteData OurHttp.Error (Paginated User))
    | FetchUsers String
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
    | SetUserSearchQuery String
    | SelectUserShowTab Int


type ProjectMsg
    = GotProject Project
    | GotProjects (RemoteData OurHttp.Error (Paginated Project))
    | FetchProjects String
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
    | SetProjectSearchQuery String


type OrganizationMsg
    = GotOrganization Organization
    | GotOrganizations (RemoteData OurHttp.Error (Paginated Organization))
    | FetchOrganizations String
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
    | SetOrganizationSearchQuery String
