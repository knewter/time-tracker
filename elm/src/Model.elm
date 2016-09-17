module Model exposing (Model, UsersModel, initialModel)

import Msg exposing (Msg)
import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, Sorted, UserSortableField, Project, ProjectSortableField, Organization, OrganizationSortableField, APIFieldErrors, UsersListView(..))
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
    , projects : List Project
    , newProjectForm : FormWithErrors Project
    , shownProject : Maybe Project
    , projectsSort : Maybe ( Sorted, ProjectSortableField )
    , organizations : List Organization
    , newOrganizationForm : FormWithErrors Organization
    , shownOrganization : Maybe Organization
    , organizationsSort : Maybe ( Sorted, OrganizationSortableField )
    }


type alias UsersModel =
    { users : List User
    , usersListView : UsersListView
    , newUserForm : FormWithErrors User
    , shownUser : Maybe User
    , usersSort : Maybe ( Sorted, UserSortableField )
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
        , users = []
        , newUserForm = ( Form.initial [] Validators.validateNewUser, Nothing )
        , shownUser = Nothing
        , usersSort = Nothing
        }
    , projects = []
    , newProjectForm = ( Form.initial [] Validators.validateNewProject, Nothing )
    , shownProject = Nothing
    , projectsSort = Nothing
    , organizations = []
    , newOrganizationForm = ( Form.initial [] Validators.validateNewOrganization, Nothing )
    , shownOrganization = Nothing
    , organizationsSort = Nothing
    }
