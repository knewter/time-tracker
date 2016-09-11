module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..), UserMsg(..), ProjectMsg(..), OrganizationMsg(..), LoginMsg(..))
import Types exposing (User, UserSortableField(..), Sorted(..), Project, ProjectSortableField(..), Organization, OrganizationSortableField(..), APIFieldErrors)
import Material
import Material.Snackbar as Snackbar
import Navigation
import Route exposing (Location(..))
import Json.Decode as JD exposing ((:=))
import OurHttp exposing (Error(..))
import Http exposing (Value(..))
import API
import Form
import Dict
import Decoders


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

        LoginMsg' msg ->
            updateLoginMsg msg model

        UserMsg' msg ->
            updateUserMsg msg model

        ProjectMsg' msg ->
            updateProjectMsg msg model

        OrganizationMsg' msg ->
            updateOrganizationMsg msg model

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


updateLoginMsg : LoginMsg -> Model -> ( Model, Cmd Msg )
updateLoginMsg msg model =
    case msg of
        LoginFormMsg formMsg ->
            case ( formMsg, Form.getOutput (fst model.loginForm) ) of
                ( Form.Submit, Just ( username, password ) ) ->
                    model ! [ API.login model ( username, password ) (LoginMsg' << LoginFailed) (LoginMsg' << LoginSucceeded) ]

                _ ->
                    { model
                        | loginForm =
                            ( Form.update formMsg (fst model.loginForm)
                            , snd model.loginForm
                            )
                    }
                        ! []

        LoginSucceeded apiKey ->
            { model | apiKey = Just apiKey } ! [] |> andLog "Login success" apiKey

        LoginFailed error ->
            model ! [] |> andLog "Login failed" (toString <| decodeError error)


updateUserMsg : UserMsg -> Model -> ( Model, Cmd Msg )
updateUserMsg msg model =
    case msg of
        GotUsers users ->
            { model | users = users } ! []

        CreateUserSucceeded _ ->
            { model
                | newUserForm = initialModel.newUserForm
            }
                ! [ Navigation.newUrl (Route.urlFor Users) ]

        CreateUserFailed error ->
            { model | newUserForm = ( fst model.newUserForm, Just (decodeError error) ) }
                ! []
                |> andLog "Create User failed" (toString <| decodeError error)

        DeleteUser user ->
            model ! [ API.deleteUser model user (UserMsg' << DeleteUserFailed) (UserMsg' << DeleteUserSucceeded) ]

        DeleteUserFailed error ->
            model ! [] |> andLog "Delete User failed" error

        DeleteUserSucceeded user ->
            model ! [ API.fetchUsers model (always NoOp) (UserMsg' << GotUsers) ]

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

        UpdateUser ->
            case model.shownUser of
                Nothing ->
                    model ! []

                Just shownUser ->
                    model ! [ API.updateUser model shownUser (UserMsg' << UpdateUserFailed) (UserMsg' << UpdateUserSucceeded) ]

        UpdateUserFailed error ->
            model ! [] |> andLog "Update User failed" error

        UpdateUserSucceeded user ->
            case user.id of
                Nothing ->
                    { model | shownUser = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.Users ]

                Just id ->
                    { model | shownUser = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.ShowUser id ]

        NewUserFormMsg formMsg ->
            case ( formMsg, Form.getOutput (fst model.newUserForm) ) of
                ( Form.Submit, Just user ) ->
                    model ! [ API.createUser model user (UserMsg' << CreateUserFailed) (UserMsg' << CreateUserSucceeded) ]

                _ ->
                    { model
                        | newUserForm =
                            ( Form.update formMsg (fst model.newUserForm)
                            , snd model.newUserForm
                            )
                    }
                        ! []

        SwitchUsersListView usersListView ->
            { model | usersListView = usersListView } ! []


updateProjectMsg : ProjectMsg -> Model -> ( Model, Cmd Msg )
updateProjectMsg msg model =
    case msg of
        GotProjects projects ->
            { model | projects = projects } ! []

        CreateProjectSucceeded _ ->
            { model
                | newProjectForm = initialModel.newProjectForm
            }
                ! [ Navigation.newUrl (Route.urlFor Projects) ]

        CreateProjectFailed error ->
            { model | newProjectForm = ( fst model.newProjectForm, Just (decodeError error) ) }
                ! []
                |> andLog "Create Project failed" (toString <| decodeError error)

        DeleteProject project ->
            model ! [ API.deleteProject model project (ProjectMsg' << DeleteProjectFailed) (ProjectMsg' << DeleteProjectSucceeded) ]

        DeleteProjectFailed error ->
            model ! [] |> andLog "Delete Project failed" error

        DeleteProjectSucceeded project ->
            model ! [ API.fetchProjects model (always NoOp) (ProjectMsg' << GotProjects) ]

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

        UpdateProject ->
            case model.shownProject of
                Nothing ->
                    model ! []

                Just shownProject ->
                    model ! [ API.updateProject model shownProject (ProjectMsg' << UpdateProjectFailed) (ProjectMsg' << UpdateProjectSucceeded) ]

        UpdateProjectFailed error ->
            model ! [] |> andLog "Update Project failed" error

        UpdateProjectSucceeded project ->
            case project.id of
                Nothing ->
                    { model | shownProject = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.Projects ]

                Just id ->
                    { model | shownProject = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.ShowProject id ]

        NewProjectFormMsg formMsg ->
            case ( formMsg, Form.getOutput (fst model.newProjectForm) ) of
                ( Form.Submit, Just user ) ->
                    model ! [ API.createProject model user (ProjectMsg' << CreateProjectFailed) (ProjectMsg' << CreateProjectSucceeded) ]

                _ ->
                    { model
                        | newProjectForm =
                            ( Form.update formMsg (fst model.newProjectForm)
                            , snd model.newProjectForm
                            )
                    }
                        ! []


projectSortableFieldFun : ProjectSortableField -> (Project -> String)
projectSortableFieldFun sortableField =
    case sortableField of
        ProjectName ->
            .name


updateOrganizationMsg : OrganizationMsg -> Model -> ( Model, Cmd Msg )
updateOrganizationMsg msg model =
    case msg of
        GotOrganizations organizations ->
            { model | organizations = organizations } ! []

        CreateOrganizationSucceeded _ ->
            { model
                | newOrganizationForm = initialModel.newOrganizationForm
            }
                ! [ Navigation.newUrl (Route.urlFor Organizations) ]

        CreateOrganizationFailed error ->
            { model | newOrganizationForm = ( fst model.newOrganizationForm, Just (decodeError error) ) }
                ! []
                |> andLog "Create Organization failed" (toString <| decodeError error)

        DeleteOrganization organization ->
            model ! [ API.deleteOrganization model organization (OrganizationMsg' << DeleteOrganizationFailed) (OrganizationMsg' << DeleteOrganizationSucceeded) ]

        DeleteOrganizationFailed error ->
            model ! [] |> andLog "Delete Organization failed" error

        DeleteOrganizationSucceeded organization ->
            model ! [ API.fetchOrganizations model (always NoOp) (OrganizationMsg' << GotOrganizations) ]

        GotOrganization organization ->
            { model | shownOrganization = Just organization } ! []

        ReorderOrganizations field ->
            reorderOrganizations field model ! []

        SetShownOrganizationName name ->
            case model.shownOrganization of
                Nothing ->
                    model ! []

                Just organization ->
                    let
                        updatedOrganization =
                            { organization | name = name }
                    in
                        { model | shownOrganization = (Just updatedOrganization) } ! []

        UpdateOrganization ->
            case model.shownOrganization of
                Nothing ->
                    model ! []

                Just shownOrganization ->
                    model ! [ API.updateOrganization model shownOrganization (OrganizationMsg' << UpdateOrganizationFailed) (OrganizationMsg' << UpdateOrganizationSucceeded) ]

        UpdateOrganizationFailed error ->
            model ! [] |> andLog "Update Organization failed" error

        UpdateOrganizationSucceeded organization ->
            case organization.id of
                Nothing ->
                    { model | shownOrganization = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.Organizations ]

                Just id ->
                    { model | shownOrganization = Nothing } ! [ Navigation.newUrl <| Route.urlFor <| Route.ShowOrganization id ]

        NewOrganizationFormMsg formMsg ->
            case ( formMsg, Form.getOutput (fst model.newOrganizationForm) ) of
                ( Form.Submit, Just organization ) ->
                    model ! [ API.createOrganization model organization (OrganizationMsg' << CreateOrganizationFailed) (OrganizationMsg' << CreateOrganizationSucceeded) ]

                _ ->
                    { model
                        | newOrganizationForm =
                            ( Form.update formMsg (fst model.newOrganizationForm)
                            , snd model.newOrganizationForm
                            )
                    }
                        ! []


organizationSortableFieldFun : OrganizationSortableField -> (Organization -> String)
organizationSortableFieldFun sortableField =
    case sortableField of
        OrganizationName ->
            .name


reorderOrganizations : OrganizationSortableField -> Model -> Model
reorderOrganizations sortableField model =
    let
        fun =
            organizationSortableFieldFun sortableField
    in
        case model.organizationsSort of
            Nothing ->
                { model
                    | organizationsSort = Just ( Ascending, sortableField )
                    , organizations = List.sortBy fun model.organizations
                }

            Just ( sortOrder, currentSortableField ) ->
                case currentSortableField == sortableField of
                    True ->
                        case sortOrder of
                            Ascending ->
                                { model
                                    | organizationsSort = Just ( Descending, sortableField )
                                    , organizations = List.sortBy fun model.organizations |> List.reverse
                                }

                            Descending ->
                                { model
                                    | organizationsSort = Just ( Ascending, sortableField )
                                    , organizations = List.sortBy fun model.organizations
                                }

                    False ->
                        { model
                            | organizationsSort = Just ( Ascending, sortableField )
                            , organizations = List.sortBy fun model.organizations
                        }


andLog : String -> a -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
andLog tag value ( model, cmd ) =
    let
        _ =
            Debug.log tag value

        ( snackbar, snackCmd ) =
            Snackbar.add (Snackbar.toast Nothing (toString value)) model.snackbar
    in
        ( { model | snackbar = snackbar }
        , Cmd.batch
            [ cmd
            , Cmd.map Snackbar snackCmd
            ]
        )


{-| Just `Model.initialModel`, but applies a `Nothing` for the `Maybe
    Route.Location` argument so we can get a 0-arity version for convenience
-}
initialModel : Model
initialModel =
    Model.initialModel Nothing


decodeError : OurHttp.Error -> APIFieldErrors
decodeError error =
    case error of
        BadResponse code text value ->
            case value of
                Text responseBody ->
                    JD.decodeString Decoders.apiFieldErrorsDecoder (Debug.log "r" responseBody)
                        |> Result.withDefault
                            ((Debug.log <|
                                "derp didn't get an api field errors decodable response back, instead got "
                                    ++ responseBody
                             )
                                Dict.empty
                            )

                e ->
                    Dict.empty
                        |> (Debug.log <|
                                "this is a blob how did that happen?: "
                                    ++ (toString error)
                           )

        e ->
            Dict.empty
                |> (Debug.log <|
                        "Something other than a BadResponse: "
                            ++ (toString e)
                   )
