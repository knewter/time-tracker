module Update exposing (update)

import Model exposing (Model, UsersModel, ProjectsModel, OrganizationsModel)
import Msg exposing (Msg(..), UserMsg(..), ProjectMsg(..), OrganizationMsg(..), LoginMsg(..))
import Types
    exposing
        ( User
        , UserSortableField(..)
        , Sorted(..)
        , Project
        , ProjectSortableField(..)
        , Organization
        , OrganizationSortableField(..)
        , APIFieldErrors
        , RemotePersistent
        )
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
import Ports
import RemoteData exposing (RemoteData(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
            let
                ( projectsModel, cmd, maybeLog ) =
                    updateProjectMsg model msg model.projectsModel
            in
                case maybeLog of
                    Nothing ->
                        ( { model | projectsModel = projectsModel }
                        , cmd
                        )

                    Just ( tag, value ) ->
                        ( { model | projectsModel = projectsModel }
                        , cmd
                        )
                            |> andLog tag value

        OrganizationMsg' msg ->
            let
                ( organizationsModel, cmd, maybeLog ) =
                    updateOrganizationMsg model msg model.organizationsModel
            in
                case maybeLog of
                    Nothing ->
                        ( { model | organizationsModel = organizationsModel }
                        , cmd
                        )

                    Just ( tag, value ) ->
                        ( { model | organizationsModel = organizationsModel }
                        , cmd
                        )
                            |> andLog tag value

        ClearApiKey ->
            { model | apiKey = Nothing } ! [ Navigation.newUrl <| Route.urlFor Login ]

        NoOp ->
            model ! []


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
            { model | apiKey = Just apiKey } ! [ Ports.storeApiKey apiKey ] |> andLog "Login success" apiKey

        LoginFailed error ->
            model ! [] |> andLog "Login failed" (toString <| decodeError error)


{-| Returns a 3-tuple where the third element is maybe something to log
-}
updateUserMsg : Model -> UserMsg -> UsersModel -> ( UsersModel, Cmd Msg, Maybe ( String, String ) )
updateUserMsg model msg usersModel =
    case msg of
        FetchUsers url ->
            ( { usersModel | users = updateRemotePersistent Loading usersModel.users }, API.fetchUsersWithUrl url model (UserMsg' << GotUsers), Nothing )

        GotUsers users ->
            ( { usersModel | users = updateRemotePersistent users usersModel.users }, Cmd.none, Nothing )

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
            ( { usersModel | users = updateRemotePersistent Loading usersModel.users }
            , API.fetchUsers model (UserMsg' << GotUsers)
            , Nothing
            )

        GotUser user ->
            ( { usersModel | shownUser = Just user }
            , Cmd.none
            , Nothing
            )

        ReorderUsers field ->
            let
                newUsersModel =
                    reorderUsers field usersModel
            in
                ( newUsersModel
                , API.fetchUsers { model | usersModel = newUsersModel } <| UserMsg' << GotUsers
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

        SetUserSearchQuery query ->
            ( { usersModel | userSearchQuery = query }
            , Cmd.none
            , Nothing
            )


updateProjectMsg : Model -> ProjectMsg -> ProjectsModel -> ( ProjectsModel, Cmd Msg, Maybe ( String, String ) )
updateProjectMsg model msg projectsModel =
    case msg of
        FetchProjects url ->
            ( { projectsModel | projects = updateRemotePersistent Loading projectsModel.projects }
            , API.fetchProjectsWithUrl url model (ProjectMsg' << GotProjects)
            , Nothing
            )

        GotProjects projects ->
            ( { projectsModel | projects = updateRemotePersistent projects projectsModel.projects }
            , Cmd.none
            , Nothing
            )

        CreateProjectSucceeded _ ->
            ( { projectsModel
                | newProjectForm = initialModel.projectsModel.newProjectForm
              }
            , Navigation.newUrl (Route.urlFor Projects)
            , Nothing
            )

        CreateProjectFailed error ->
            ( { projectsModel | newProjectForm = ( fst model.projectsModel.newProjectForm, Just (decodeError error) ) }
            , Cmd.none
            , Just ( "Create Project failed", toString <| decodeError error )
            )

        DeleteProject project ->
            ( projectsModel
            , API.deleteProject model project (ProjectMsg' << DeleteProjectFailed) (ProjectMsg' << DeleteProjectSucceeded)
            , Nothing
            )

        DeleteProjectFailed error ->
            ( projectsModel
            , Cmd.none
            , Just ( "Delete Project failed", toString error )
            )

        DeleteProjectSucceeded project ->
            ( { projectsModel | projects = updateRemotePersistent Loading projectsModel.projects }
            , API.fetchProjects model (ProjectMsg' << GotProjects)
            , Nothing
            )

        GotProject project ->
            ( { projectsModel | shownProject = Just project }
            , Cmd.none
            , Nothing
            )

        ReorderProjects field ->
            let
                newProjectsModel =
                    reorderProjects field projectsModel
            in
                ( newProjectsModel
                , API.fetchProjects { model | projectsModel = newProjectsModel } <| ProjectMsg' << GotProjects
                , Nothing
                )

        SetShownProjectName name ->
            case projectsModel.shownProject of
                Nothing ->
                    ( projectsModel
                    , Cmd.none
                    , Nothing
                    )

                Just project ->
                    let
                        updatedProject =
                            { project | name = name }
                    in
                        ( { projectsModel | shownProject = (Just updatedProject) }
                        , Cmd.none
                        , Nothing
                        )

        UpdateProject ->
            case projectsModel.shownProject of
                Nothing ->
                    ( projectsModel, Cmd.none, Nothing )

                Just shownProject ->
                    ( projectsModel
                    , API.updateProject model shownProject (ProjectMsg' << UpdateProjectFailed) (ProjectMsg' << UpdateProjectSucceeded)
                    , Nothing
                    )

        UpdateProjectFailed error ->
            ( projectsModel
            , Cmd.none
            , Just ( "Update Project failed", toString error )
            )

        UpdateProjectSucceeded project ->
            case project.id of
                Nothing ->
                    ( { projectsModel | shownProject = Nothing }
                    , Navigation.newUrl <| Route.urlFor <| Route.Projects
                    , Nothing
                    )

                Just id ->
                    ( { projectsModel | shownProject = Nothing }
                    , Navigation.newUrl <| Route.urlFor <| Route.ShowProject id
                    , Nothing
                    )

        NewProjectFormMsg formMsg ->
            case ( formMsg, Form.getOutput (fst projectsModel.newProjectForm) ) of
                ( Form.Submit, Just user ) ->
                    ( projectsModel
                    , API.createProject model user (ProjectMsg' << CreateProjectFailed) (ProjectMsg' << CreateProjectSucceeded)
                    , Nothing
                    )

                _ ->
                    ( { projectsModel
                        | newProjectForm =
                            ( Form.update formMsg (fst projectsModel.newProjectForm)
                            , snd projectsModel.newProjectForm
                            )
                      }
                    , Cmd.none
                    , Nothing
                    )

        SetProjectSearchQuery query ->
            ( { projectsModel | projectSearchQuery = query }
            , Cmd.none
            , Nothing
            )


updateOrganizationMsg : Model -> OrganizationMsg -> OrganizationsModel -> ( OrganizationsModel, Cmd Msg, Maybe ( String, String ) )
updateOrganizationMsg model msg organizationsModel =
    case msg of
        FetchOrganizations url ->
            ( { organizationsModel | organizations = updateRemotePersistent Loading organizationsModel.organizations }
            , API.fetchOrganizationsWithUrl url model (OrganizationMsg' << GotOrganizations)
            , Nothing
            )

        GotOrganizations organizations ->
            ( { organizationsModel | organizations = updateRemotePersistent organizations organizationsModel.organizations }
            , Cmd.none
            , Nothing
            )

        CreateOrganizationSucceeded _ ->
            ( { organizationsModel
                | newOrganizationForm = initialModel.organizationsModel.newOrganizationForm
              }
            , Navigation.newUrl (Route.urlFor Organizations)
            , Nothing
            )

        CreateOrganizationFailed error ->
            ( { organizationsModel | newOrganizationForm = ( fst model.organizationsModel.newOrganizationForm, Just (decodeError error) ) }
            , Cmd.none
            , Just ( "Create Organization failed", toString <| decodeError error )
            )

        DeleteOrganization organization ->
            ( organizationsModel
            , API.deleteOrganization model organization (OrganizationMsg' << DeleteOrganizationFailed) (OrganizationMsg' << DeleteOrganizationSucceeded)
            , Nothing
            )

        DeleteOrganizationFailed error ->
            ( organizationsModel
            , Cmd.none
            , Just ( "Delete Organization failed", toString error )
            )

        DeleteOrganizationSucceeded organization ->
            ( { organizationsModel | organizations = updateRemotePersistent Loading organizationsModel.organizations }
            , API.fetchOrganizations model (OrganizationMsg' << GotOrganizations)
            , Nothing
            )

        GotOrganization organization ->
            ( { organizationsModel | shownOrganization = Just organization }
            , Cmd.none
            , Nothing
            )

        ReorderOrganizations field ->
            let
                newOrganizationsModel =
                    reorderOrganizations field organizationsModel
            in
                ( newOrganizationsModel
                , API.fetchOrganizations { model | organizationsModel = newOrganizationsModel } <| OrganizationMsg' << GotOrganizations
                , Nothing
                )

        SetShownOrganizationName name ->
            case organizationsModel.shownOrganization of
                Nothing ->
                    ( organizationsModel
                    , Cmd.none
                    , Nothing
                    )

                Just organization ->
                    let
                        updatedOrganization =
                            { organization | name = name }
                    in
                        ( { organizationsModel | shownOrganization = (Just updatedOrganization) }
                        , Cmd.none
                        , Nothing
                        )

        UpdateOrganization ->
            case organizationsModel.shownOrganization of
                Nothing ->
                    ( organizationsModel, Cmd.none, Nothing )

                Just shownOrganization ->
                    ( organizationsModel
                    , API.updateOrganization model shownOrganization (OrganizationMsg' << UpdateOrganizationFailed) (OrganizationMsg' << UpdateOrganizationSucceeded)
                    , Nothing
                    )

        UpdateOrganizationFailed error ->
            ( organizationsModel
            , Cmd.none
            , Just ( "Update Organization failed", toString error )
            )

        UpdateOrganizationSucceeded organization ->
            case organization.id of
                Nothing ->
                    ( { organizationsModel | shownOrganization = Nothing }
                    , Navigation.newUrl <| Route.urlFor <| Route.Organizations
                    , Nothing
                    )

                Just id ->
                    ( { organizationsModel | shownOrganization = Nothing }
                    , Navigation.newUrl <| Route.urlFor <| Route.ShowOrganization id
                    , Nothing
                    )

        NewOrganizationFormMsg formMsg ->
            case ( formMsg, Form.getOutput (fst organizationsModel.newOrganizationForm) ) of
                ( Form.Submit, Just user ) ->
                    ( organizationsModel
                    , API.createOrganization model user (OrganizationMsg' << CreateOrganizationFailed) (OrganizationMsg' << CreateOrganizationSucceeded)
                    , Nothing
                    )

                _ ->
                    ( { organizationsModel
                        | newOrganizationForm =
                            ( Form.update formMsg (fst organizationsModel.newOrganizationForm)
                            , snd organizationsModel.newOrganizationForm
                            )
                      }
                    , Cmd.none
                    , Nothing
                    )

        SetOrganizationSearchQuery query ->
            ( { organizationsModel | organizationSearchQuery = query }
            , Cmd.none
            , Nothing
            )


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


updateRemotePersistent : RemoteData Error a -> RemotePersistent a -> RemotePersistent a
updateRemotePersistent newValue persistentWrapped =
    case persistentWrapped.current of
        Success a ->
            { current = newValue, previous = Just a }

        _ ->
            { current = newValue, previous = Nothing }


userSortableFieldFun : UserSortableField -> (User -> String)
userSortableFieldFun sortableField =
    case sortableField of
        UserName ->
            .name


reorderUsers : UserSortableField -> UsersModel -> UsersModel
reorderUsers sortableField model =
    let
        fun =
            userSortableFieldFun sortableField

        loadingModel =
            { model | users = updateRemotePersistent Loading model.users }
    in
        case loadingModel.usersSort of
            Nothing ->
                { loadingModel
                    | usersSort = Just ( Ascending, sortableField )
                }

            Just ( sortOrder, currentSortableField ) ->
                case currentSortableField == sortableField of
                    True ->
                        case sortOrder of
                            Ascending ->
                                { loadingModel
                                    | usersSort = Just ( Descending, sortableField )
                                }

                            Descending ->
                                { loadingModel
                                    | usersSort = Just ( Ascending, sortableField )
                                }

                    False ->
                        { loadingModel
                            | usersSort = Just ( Ascending, sortableField )
                        }


projectSortableFieldFun : ProjectSortableField -> (User -> String)
projectSortableFieldFun sortableField =
    case sortableField of
        ProjectName ->
            .name


reorderProjects : ProjectSortableField -> ProjectsModel -> ProjectsModel
reorderProjects sortableField model =
    let
        fun =
            projectSortableFieldFun sortableField

        loadingModel =
            { model | projects = updateRemotePersistent Loading model.projects }
    in
        case loadingModel.projectsSort of
            Nothing ->
                { loadingModel
                    | projectsSort = Just ( Ascending, sortableField )
                }

            Just ( sortOrder, currentSortableField ) ->
                case currentSortableField == sortableField of
                    True ->
                        case sortOrder of
                            Ascending ->
                                { loadingModel
                                    | projectsSort = Just ( Descending, sortableField )
                                }

                            Descending ->
                                { loadingModel
                                    | projectsSort = Just ( Ascending, sortableField )
                                }

                    False ->
                        { loadingModel
                            | projectsSort = Just ( Ascending, sortableField )
                        }


organizationSortableFieldFun : OrganizationSortableField -> (User -> String)
organizationSortableFieldFun sortableField =
    case sortableField of
        OrganizationName ->
            .name


reorderOrganizations : OrganizationSortableField -> OrganizationsModel -> OrganizationsModel
reorderOrganizations sortableField model =
    let
        fun =
            organizationSortableFieldFun sortableField

        loadingModel =
            { model | organizations = updateRemotePersistent Loading model.organizations }
    in
        case loadingModel.organizationsSort of
            Nothing ->
                { loadingModel
                    | organizationsSort = Just ( Ascending, sortableField )
                }

            Just ( sortOrder, currentSortableField ) ->
                case currentSortableField == sortableField of
                    True ->
                        case sortOrder of
                            Ascending ->
                                { loadingModel
                                    | organizationsSort = Just ( Descending, sortableField )
                                }

                            Descending ->
                                { loadingModel
                                    | organizationsSort = Just ( Ascending, sortableField )
                                }

                    False ->
                        { loadingModel
                            | organizationsSort = Just ( Ascending, sortableField )
                        }
