module Model exposing (Model, initialModel, initialModelNoRoute)

import Msg exposing (Msg)
import Material
import Material.Snackbar as Snackbar
import Route
import Types exposing (User, Sorted, UserSortableField, Project, ProjectSortableField, Organization, OrganizationSortableField)
import Form exposing (Form)
import Form.Validate exposing (Validation, form1, get, string)


type alias Model =
    { mdl : Material.Model
    , snackbar : Snackbar.Model (Maybe Msg)
    , baseUrl : String
    , route : Route.Model
    , users : List User
    , newUserForm : Form () User
    , shownUser : Maybe User
    , usersSort : Maybe ( Sorted, UserSortableField )
    , projects : List Project
    , newProject : Project
    , shownProject : Maybe Project
    , projectsSort : Maybe ( Sorted, ProjectSortableField )
    , organizations : List Organization
    , newOrganization : Organization
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
    , newUserForm = Form.initial [] validateNewUser
    , shownUser = Nothing
    , usersSort = Nothing
    , projects = []
    , newProject = Project Nothing ""
    , shownProject = Nothing
    , projectsSort = Nothing
    , organizations = []
    , newOrganization = Organization Nothing ""
    , shownOrganization = Nothing
    , organizationsSort = Nothing
    }


{-| Just `Model.initialModel`, but applies a `Nothing` for the `Maybe
    Route.Location` argument so we can get a 0-arity version for convenience
-}
initialModelNoRoute : Model
initialModelNoRoute =
    initialModel Nothing


validateNewUser : Validation () User
validateNewUser =
    form1 (User Nothing)
        (get "name" string)
