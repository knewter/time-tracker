module Model exposing (Model, UsersModel, ProjectsModel, OrganizationsModel, initialModel)

import Msg exposing (Msg)
import Material
import Material.Snackbar as Snackbar
import Route
import Types
    exposing
        ( User
        , Sorted
        , UserSortableField
        , Project
        , ProjectSortableField
        , Organization
        , OrganizationSortableField
        , APIFieldErrors
        , UsersListView(..)
        , Paginated
        )
import Form exposing (Form)
import Validators
import RemoteData exposing (RemoteData(..))
import OurHttp


type alias FormWithErrors a =
    ( Form String a, Maybe APIFieldErrors )


type alias Model =
    { mdl : Material.Model
    , snackbar : Snackbar.Model (Maybe Msg)
    , route : Route.Model
    , baseUrl : String
    , apiKey : Maybe String
    , loginForm : FormWithErrors ( String, String )
    , usersModel : UsersModel
    , projectsModel : ProjectsModel
    , organizationsModel : OrganizationsModel
    }


type alias UsersModel =
    { users : RemoteData OurHttp.Error (Paginated User)
    , usersListView : UsersListView
    , newUserForm : FormWithErrors User
    , shownUser : Maybe User
    , usersSort : Maybe ( Sorted, UserSortableField )
    }


type alias ProjectsModel =
    { projects : RemoteData OurHttp.Error (Paginated Project)
    , newProjectForm : FormWithErrors Project
    , shownProject : Maybe Project
    , projectsSort : Maybe ( Sorted, ProjectSortableField )
    }


type alias OrganizationsModel =
    { organizations : RemoteData OurHttp.Error (Paginated Organization)
    , newOrganizationForm : FormWithErrors Organization
    , shownOrganization : Maybe Organization
    , organizationsSort : Maybe ( Sorted, OrganizationSortableField )
    }


initialModel : Maybe Route.Location -> Model
initialModel location =
    { mdl = Material.model
    , snackbar = Snackbar.model
    , route = Route.init location
    , baseUrl = "http://localhost:4000"
    , apiKey = Nothing
    , loginForm = ( Form.initial [] Validators.validateLoginForm, Nothing )
    , usersModel =
        { usersListView = UsersTable
        , users = NotAsked
        , newUserForm = ( Form.initial [] Validators.validateNewUser, Nothing )
        , shownUser = Nothing
        , usersSort = Nothing
        }
    , projectsModel =
        { projects = NotAsked
        , newProjectForm = ( Form.initial [] Validators.validateNewProject, Nothing )
        , shownProject = Nothing
        , projectsSort = Nothing
        }
    , organizationsModel =
        { organizations = NotAsked
        , newOrganizationForm = ( Form.initial [] Validators.validateNewOrganization, Nothing )
        , shownOrganization = Nothing
        , organizationsSort = Nothing
        }
    }
