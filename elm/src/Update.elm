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
            model ! [ API.createUser model model.newUser CreateUserFailed CreateUserSucceeded ]

        CreateUserSucceeded _ ->
            { model | newUser = User Nothing "" }
                ! [ Navigation.newUrl (Route.urlFor Users) ]

        CreateUserFailed error ->
            model ! [] |> andLog "Create User failed" error

        DeleteUser user ->
            model ! [ API.deleteUser model user DeleteUserFailed DeleteUserSucceeded ]

        DeleteUserFailed error ->
            model ! [] |> andLog "Delete User failed" error

        DeleteUserSucceeded user ->
            model ! [ API.fetchUsers model (always NoOp) GotUsers ]

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
                    model ! [ API.updateUser model shownUser UpdateUserFailed UpdateUserSucceeded ]

        UpdateUserFailed error ->
            model ! [] |> andLog "Update User failed" error

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
            model ! [ API.createProject model model.newProject CreateProjectFailed CreateProjectSucceeded ]

        CreateProjectSucceeded _ ->
            { model | newProject = Project Nothing "" }
                ! [ Navigation.newUrl (Route.urlFor Projects) ]

        CreateProjectFailed error ->
            model ! [] |> andLog "Create Project failed" error

        DeleteProject project ->
            model ! [ API.deleteProject model project DeleteProjectFailed DeleteProjectSucceeded ]

        DeleteProjectFailed error ->
            model ! [] |> andLog "Delete Project failed" error

        DeleteProjectSucceeded project ->
            model ! [ API.fetchProjects model (always NoOp) GotProjects ]

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
                    model ! [ API.updateProject model shownProject UpdateProjectFailed UpdateProjectSucceeded ]

        UpdateProjectFailed error ->
            model ! [] |> andLog "Update Project failed" error

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


andLog : String -> a -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
andLog tag value ( model, cmds ) =
    let
        _ =
            Debug.log (tag ++ ": ") value
    in
        ( model, cmds )
