module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Types exposing (User, UserSortableField(..), Sorted(..), Project, ProjectSortableField(..))
import Material
import Material.Snackbar as Snackbar
import Navigation
import Route exposing (Location(..))
import API


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg: " msg of
        Mdl msg' ->
            Material.update msg' model

        Snackbar msg' ->
            let
                ( snackbar, snackCmd ) =
                    Snackbar.update msg' model.snackbar
            in
                { model | snackbar = snackbar } ! [ Cmd.map Snackbar snackCmd ]

        NavigateTo maybeLocation ->
            case maybeLocation of
                Nothing ->
                    model ! []

                Just location ->
                    model ! [ Navigation.newUrl (Route.urlFor location) ]

        GotUsers users ->
            { model | users = users } ! []

        SetNewUserName name ->
            let
                oldNewUser =
                    model.newUser
            in
                { model | newUser = { oldNewUser | name = name } } ! []

        CreateNewUser ->
            model ! [ API.createUser model.newUser model ]

        CreateUserSucceeded _ ->
            { model | newUser = User Nothing "" }
                ! [ Navigation.newUrl (Route.urlFor Users) ]

        CreateUserFailed error ->
            let
                _ =
                    Debug.log "Create User failed: " error
            in
                model ! []

        DeleteUser user ->
            let
                _ =
                    Debug.log "Deleting user: " user
            in
                model ! [ API.deleteUser user model ]

        DeleteUserFailed error ->
            let
                _ =
                    Debug.log "Delete User failed: " error
            in
                model ! []

        DeleteUserSucceeded user ->
            model ! [ API.fetchUsers model ]

        GotUser user ->
            { model | shownUser = Just user } ! []

        ReorderUsers field ->
            reorderUsers field model ! []

        SetShownUserName name ->
            case model.shownUser of
                Nothing ->
                    model ! []

                Just user ->
                    let
                        updatedUser =
                            { user | name = name }
                    in
                        { model | shownUser = (Just updatedUser) } ! []

        UpdateShownUser ->
            case model.shownUser of
                Nothing ->
                    model ! []

                Just shownUser ->
                    model ! [ API.updateUser shownUser model ]

        UpdateUserFailed error ->
            let
                _ =
                    Debug.log "Update User failed: " error
            in
                model ! []

        UpdateUserSucceeded user ->
            case user.id of
                Nothing ->
                    { model | shownUser = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.Users ]

                Just id ->
                    { model | shownUser = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.ShowUser id ]

        GotProjects projects ->
            { model | projects = projects } ! []

        SetNewProjectName name ->
            let
                oldNewProject =
                    model.newProject
            in
                { model | newProject = { oldNewProject | name = name } } ! []

        CreateNewProject ->
            model ! [ API.createProject model.newProject model ]

        CreateProjectSucceeded _ ->
            { model | newProject = Project Nothing "" }
                ! [ Navigation.newUrl (Route.urlFor Projects) ]

        CreateProjectFailed error ->
            let
                _ =
                    Debug.log "Create Project failed: " error
            in
                model ! []

        DeleteProject project ->
            let
                _ =
                    Debug.log "Deleting project: " project
            in
                model ! [ API.deleteProject project model ]

        DeleteProjectFailed error ->
            let
                _ =
                    Debug.log "Delete Project failed: " error
            in
                model ! []

        DeleteProjectSucceeded project ->
            model ! [ API.fetchProjects model ]

        GotProject project ->
            { model | shownProject = Just project } ! []

        ReorderProjects field ->
            reorderProjects field model ! []

        SetShownProjectName name ->
            case model.shownProject of
                Nothing ->
                    model ! []

                Just project ->
                    let
                        updatedProject =
                            { project | name = name }
                    in
                        { model | shownProject = (Just updatedProject) } ! []

        UpdateShownProject ->
            case model.shownProject of
                Nothing ->
                    model ! []

                Just shownProject ->
                    model ! [ API.updateProject shownProject model ]

        UpdateProjectFailed error ->
            let
                _ =
                    Debug.log "Update Project failed: " error
            in
                model ! []

        UpdateProjectSucceeded project ->
            case project.id of
                Nothing ->
                    { model | shownProject = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.Projects ]

                Just id ->
                    { model | shownProject = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.ShowProject id ]

        NoOp ->
            model ! []


reorderUsers : UserSortableField -> Model -> Model
reorderUsers sortableField model =
    let
        fun =
            userSortableFieldFun sortableField
    in
        case model.usersSort of
            Nothing ->
                { model
                    | usersSort = Just ( Ascending, sortableField )
                    , users = List.sortBy fun model.users
                }

            Just ( sortOrder, currentSortableField ) ->
                case currentSortableField == sortableField of
                    True ->
                        case sortOrder of
                            Ascending ->
                                { model
                                    | usersSort = Just ( Descending, sortableField )
                                    , users = List.sortBy fun model.users |> List.reverse
                                }

                            Descending ->
                                { model
                                    | usersSort = Just ( Ascending, sortableField )
                                    , users = List.sortBy fun model.users
                                }

                    False ->
                        { model
                            | usersSort = Just ( Ascending, sortableField )
                            , users = List.sortBy fun model.users
                        }


userSortableFieldFun : UserSortableField -> (User -> String)
userSortableFieldFun sortableField =
    case sortableField of
        UserName ->
            .name


reorderProjects : ProjectSortableField -> Model -> Model
reorderProjects sortableField model =
    let
        fun =
            projectSortableFieldFun sortableField
    in
        case model.projectsSort of
            Nothing ->
                { model
                    | projectsSort = Just ( Ascending, sortableField )
                    , projects = List.sortBy fun model.projects
                }

            Just ( sortOrder, currentSortableField ) ->
                case currentSortableField == sortableField of
                    True ->
                        case sortOrder of
                            Ascending ->
                                { model
                                    | projectsSort = Just ( Descending, sortableField )
                                    , projects = List.sortBy fun model.projects |> List.reverse
                                }

                            Descending ->
                                { model
                                    | projectsSort = Just ( Ascending, sortableField )
                                    , projects = List.sortBy fun model.projects
                                }

                    False ->
                        { model
                            | projectsSort = Just ( Ascending, sortableField )
                            , projects = List.sortBy fun model.projects
                        }


projectSortableFieldFun : ProjectSortableField -> (Project -> String)
projectSortableFieldFun sortableField =
    case sortableField of
        ProjectName ->
            .name
