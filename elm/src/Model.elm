module Model exposing (Model, initialModel)

import Msg exposing (Msg)
import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, Sorted, UserSortableField, Project, ProjectSortableField, Organization, OrganizationSortableField, APIFieldErrors)
import Form exposing (Form)
import Validators


type alias FormWithErrors a =
    ( Form String a, Maybe APIFieldErrors )


type alias Model =
    { mdl : Material.Model
    , snackbar : Snackbar.Model (Maybe Msg)
    , baseUrl : String
    , route : Route.Model
    , users : List User
    , newUserForm : FormWithErrors User
    , shownUser : Maybe User
    , usersSort : Maybe ( Sorted, UserSortableField )
    , projects : List Project
    , newProject : Project
    , shownProject : Maybe Project
    , projectsSort : Maybe ( Sorted, ProjectSortableField )
    , organizations : List Organization
    , newOrganizationForm : FormWithErrors Organization
    , shownOrganization : Maybe Organization
    , organizationsSort : Maybe ( Sorted, OrganizationSortableField )
    }


initialModel : Maybe Route.Location -> Model
initialModel location =
    { mdl = Material.model
    , snackbar = Snackbar.model
    , baseUrl = "http://localhost:4000"
    , route = Route.init location
    , users = []
    , newUserForm = ( Form.initial [] Validators.validateNewUser, Nothing )
    , shownUser = Nothing
    , usersSort = Nothing
    , projects = []
    , newProject = Project Nothing ""
    , shownProject = Nothing
    , projectsSort = Nothing
    , organizations = []
    , newOrganizationForm = ( Form.initial [] Validators.validateNewOrganization, Nothing )
    , shownOrganization = Nothing
    , organizationsSort = Nothing
    }
