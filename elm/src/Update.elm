module Update exposing (update)

import Model exposing (Model, UsersModel)
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
            let
                ( usersModel, cmd, maybeLog ) =
                    updateUserMsg model msg model.usersModel
            in
                case maybeLog of
                    Nothing ->
                        ( { model | usersModel = usersModel }
                        , cmd
                        )

                    Just ( tag, value ) ->
                        ( { model | usersModel = usersModel }
                        , cmd
                        )
                            |> andLog tag value

        ProjectMsg' msg ->
            updateProjectMsg msg model

        OrganizationMsg' msg ->
            updateOrganizationMsg msg model

        NoOp ->
            model ! []


reorderUsers : UserSortableField -> UsersModel -> UsersModel
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


{-| Returns a 3-tuple where the third element is maybe something to log
-}
updateUserMsg : Model -> UserMsg -> UsersModel -> ( UsersModel, Cmd Msg, Maybe ( String, String ) )
updateUserMsg model msg usersModel =
    case msg of
        GotUsers users ->
            ( { usersModel | users = users }, Cmd.none, Nothing )

        CreateUserSucceeded _ ->
            ( { usersModel
                | newUserForm = initialModel.usersModel.newUserForm
              }
            , Navigation.newUrl (Route.urlFor Users)
            , Nothing
            )

        CreateUserFailed error ->
            ( { usersModel | newUserForm = ( fst usersModel.newUserForm, Just (decodeError error) ) }
            , Cmd.none
            , Just ( "Create User failed", toString <| decodeError error )
            )

        DeleteUser user ->
            ( usersModel
            , API.deleteUser model user (UserMsg' << DeleteUserFailed) (UserMsg' << DeleteUserSucceeded)
            , Nothing
            )

        DeleteUserFailed error ->
            ( usersModel
            , Cmd.none
            , Just ( "Delete User failed", toString error )
            )

        DeleteUserSucceeded user ->
            ( usersModel
            , API.fetchUsers model (always NoOp) (UserMsg' << GotUsers)
            , Nothing
            )

        GotUser user ->
            ( { usersModel | shownUser = Just user }
            , Cmd.none
            , Nothing
            )

        ReorderUsers field ->
            ( reorderUsers field model.usersModel
            , Cmd.none
            , Nothing
            )

        SetShownUserName name ->
            case usersModel.shownUser of
                Nothing ->
                    ( usersModel
                    , Cmd.none
                    , Nothing
                    )

                Just user ->
                    let
                        updatedUser =
                            { user | name = name }
                    in
                        ( { usersModel | shownUser = (Just updatedUser) }
                        , Cmd.none
                        , Nothing
                        )

        UpdateUser ->
            case usersModel.shownUser of
                Nothing ->
                    ( usersModel
                    , Cmd.none
                    , Nothing
                    )

                Just shownUser ->
                    ( usersModel
                    , API.updateUser model shownUser (UserMsg' << UpdateUserFailed) (UserMsg' << UpdateUserSucceeded)
                    , Nothing
                    )

        UpdateUserFailed error ->
            ( usersModel
            , Cmd.none
            , Just ( "Update User failed", toString error )
            )

        UpdateUserSucceeded user ->
            case user.id of
                Nothing ->
                    ( { usersModel | shownUser = Nothing }
                    , Navigation.newUrl <| Route.urlFor <| Route.Users
                    , Nothing
                    )

                Just id ->
                    ( { usersModel | shownUser = Nothing }
                    , Navigation.newUrl <| Route.urlFor <| Route.ShowUser id
                    , Nothing
                    )

        NewUserFormMsg formMsg ->
            case ( formMsg, Form.getOutput (fst usersModel.newUserForm) ) of
                ( Form.Submit, Just user ) ->
                    ( usersModel
                    , API.createUser model user (UserMsg' << CreateUserFailed) (UserMsg' << CreateUserSucceeded)
                    , Nothing
                    )

                _ ->
                    ( { usersModel
                        | newUserForm =
                            ( Form.update formMsg (fst usersModel.newUserForm)
                            , snd usersModel.newUserForm
                            )
                      }
                    , Cmd.none
                    , Nothing
                    )

        SwitchUsersListView usersListView ->
            ( { usersModel | usersListView = usersListView }
            , Cmd.none
            , Nothing
            )


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
