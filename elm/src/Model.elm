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
    { users : Maybe (Paginated User)
    , usersListView : UsersListView
    , newUserForm : FormWithErrors User
    , shownUser : Maybe User
    , usersSort : Maybe ( Sorted, UserSortableField )
    }


type alias ProjectsModel =
    { projects : Maybe (Paginated Project)
    , newProjectForm : FormWithErrors Project
    , shownProject : Maybe Project
    , projectsSort : Maybe ( Sorted, ProjectSortableField )
    }


type alias OrganizationsModel =
    { organizations : Maybe (Paginated Organization)
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
        , users = Nothing
        , newUserForm = ( Form.initial [] Validators.validateNewUser, Nothing )
        , shownUser = Nothing
        , usersSort = Nothing
        }
    , projectsModel =
        { projects = Nothing
        , newProjectForm = ( Form.initial [] Validators.validateNewProject, Nothing )
        , shownProject = Nothing
        , projectsSort = Nothing
        }
    , organizationsModel =
        { organizations = Nothing
        , newOrganizationForm = ( Form.initial [] Validators.validateNewOrganization, Nothing )
        , shownOrganization = Nothing
        , organizationsSort = Nothing
        }
    }
