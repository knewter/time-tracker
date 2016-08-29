module API
    exposing
        ( fetchUsers
        , createUser
        , deleteUser
        , fetchUser
        , updateUser
        , fetchProjects
        , createProject
        , deleteProject
        , fetchProject
        , updateProject
        )

import Model exposing (Model)
import Msg exposing (Msg(..))
import Types exposing (User, Project)
import Http
import Decoders
import Json.Decode exposing ((:=))
import Task
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))


fetchUsers : Model -> Cmd Msg
fetchUsers model =
    Http.get ("data" := Decoders.usersDecoder) (model.baseUrl ++ "/users")
        |> Task.perform (always (GotUsers [])) GotUsers


fetchUser : Int -> Model -> Cmd Msg
fetchUser id model =
    Http.get ("data" := Decoders.userDecoder) (model.baseUrl ++ "/users/" ++ (toString id))
        |> Task.perform (always NoOp) GotUser


createUser : User -> Model -> Cmd Msg
createUser user model =
    Http.send Http.defaultSettings
        { verb = "POST"
        , url = model.baseUrl ++ "/users"
        , body = Http.string (encodeUser user |> JE.encode 0)
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> Http.fromJson ("data" := Decoders.userDecoder)
        |> Task.perform CreateUserFailed CreateUserSucceeded


deleteUser : User -> Model -> Cmd Msg
deleteUser user model =
    case user.id of
        Nothing ->
            Cmd.none

        Just id ->
            Http.send Http.defaultSettings
                { verb = "DELETE"
                , url = model.baseUrl ++ "/users/" ++ (toString id)
                , body = Http.empty
                , headers = [ ( "Content-Type", "application/json" ) ]
                }
                |> Task.perform DeleteUserFailed (always <| DeleteUserSucceeded user)


updateUser : User -> Model -> Cmd Msg
updateUser user model =
    case user.id of
        Nothing ->
            Cmd.none

        Just id ->
            Http.send Http.defaultSettings
                { verb = "PUT"
                , url = model.baseUrl ++ "/users/" ++ (toString id)
                , body = Http.string (encodeUser user |> JE.encode 0)
                , headers = [ ( "Content-Type", "application/json" ) ]
                }
                |> Http.fromJson ("data" := Decoders.userDecoder)
                |> Task.perform UpdateUserFailed UpdateUserSucceeded


encodeUser : User -> JE.Value
encodeUser user =
    JE.object
        [ ( "user"
          , JE.object
                [ ( "name", JE.string user.name )
                ]
          )
        ]


fetchProjects : Model -> Cmd Msg
fetchProjects model =
    Http.get ("data" := Decoders.projectsDecoder) (model.baseUrl ++ "/projects")
        |> Task.perform (always (GotProjects [])) GotProjects


fetchProject : Int -> Model -> Cmd Msg
fetchProject id model =
    Http.get ("data" := Decoders.projectDecoder) (model.baseUrl ++ "/projects/" ++ (toString id))
        |> Task.perform (always NoOp) GotProject


createProject : Project -> Model -> Cmd Msg
createProject project model =
    Http.send Http.defaultSettings
        { verb = "POST"
        , url = model.baseUrl ++ "/projects"
        , body = Http.string (encodeProject project |> JE.encode 0)
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> Http.fromJson ("data" := Decoders.projectDecoder)
        |> Task.perform CreateProjectFailed CreateProjectSucceeded


deleteProject : Project -> Model -> Cmd Msg
deleteProject project model =
    case project.id of
        Nothing ->
            Cmd.none

        Just id ->
            Http.send Http.defaultSettings
                { verb = "DELETE"
                , url = model.baseUrl ++ "/projects/" ++ (toString id)
                , body = Http.empty
                , headers = [ ( "Content-Type", "application/json" ) ]
                }
                |> Task.perform DeleteProjectFailed (always <| DeleteProjectSucceeded project)


updateProject : Project -> Model -> Cmd Msg
updateProject project model =
    case project.id of
        Nothing ->
            Cmd.none

        Just id ->
            Http.send Http.defaultSettings
                { verb = "PUT"
                , url = model.baseUrl ++ "/projects/" ++ (toString id)
                , body = Http.string (encodeProject project |> JE.encode 0)
                , headers = [ ( "Content-Type", "application/json" ) ]
                }
                |> Http.fromJson ("data" := Decoders.projectDecoder)
                |> Task.perform UpdateProjectFailed UpdateProjectSucceeded


encodeProject : Project -> JE.Value
encodeProject project =
    JE.object
        [ ( "project"
          , JE.object
                [ ( "name", JE.string project.name )
                ]
          )
        ]
