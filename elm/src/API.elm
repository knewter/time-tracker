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


fetchUsers : Model -> (Http.Error -> Msg) -> (List User -> Msg) -> Cmd Msg
fetchUsers model errorMsg msg =
    Http.get ("data" := Decoders.usersDecoder) (model.baseUrl ++ "/users")
        |> Task.perform errorMsg msg


fetchUser : Model -> Int -> (Http.Error -> Msg) -> (User -> Msg) -> Cmd Msg
fetchUser model id errorMsg msg =
    Http.get ("data" := Decoders.userDecoder) (model.baseUrl ++ "/users/" ++ (toString id))
        |> Task.perform errorMsg msg


createUser : Model -> User -> (Http.Error -> Msg) -> (User -> Msg) -> Cmd Msg
createUser model user errorMsg msg =
    Http.send Http.defaultSettings
        { verb = "POST"
        , url = model.baseUrl ++ "/users"
        , body = Http.string (encodeUser user |> JE.encode 0)
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> Http.fromJson ("data" := Decoders.userDecoder)
        |> Task.perform errorMsg msg


deleteUser : Model -> User -> (Http.RawError -> Msg) -> (User -> Msg) -> Cmd Msg
deleteUser model user errorMsg msg =
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
                |> Task.perform errorMsg (always <| msg user)


updateUser : Model -> User -> (Http.Error -> Msg) -> (User -> Msg) -> Cmd Msg
updateUser model user errorMsg msg =
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
                |> Task.perform errorMsg msg


encodeUser : User -> JE.Value
encodeUser user =
    JE.object
        [ ( "user"
          , JE.object
                [ ( "name", JE.string user.name )
                ]
          )
        ]


fetchProjects : Model -> (Http.Error -> Msg) -> (List Project -> Msg) -> Cmd Msg
fetchProjects model errorMsg msg =
    Http.get ("data" := Decoders.projectsDecoder) (model.baseUrl ++ "/projects")
        |> Task.perform errorMsg msg


fetchProject : Model -> Int -> (Http.Error -> Msg) -> (Project -> Msg) -> Cmd Msg
fetchProject model id errorMsg msg =
    Http.get ("data" := Decoders.projectDecoder) (model.baseUrl ++ "/projects/" ++ (toString id))
        |> Task.perform errorMsg msg


createProject : Model -> Project -> (Http.Error -> Msg) -> (Project -> Msg) -> Cmd Msg
createProject model project errorMsg msg =
    Http.send Http.defaultSettings
        { verb = "POST"
        , url = model.baseUrl ++ "/projects"
        , body = Http.string (encodeProject project |> JE.encode 0)
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> Http.fromJson ("data" := Decoders.projectDecoder)
        |> Task.perform errorMsg msg


deleteProject : Model -> Project -> (Http.RawError -> Msg) -> (Project -> Msg) -> Cmd Msg
deleteProject model project errorMsg msg =
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
                |> Task.perform errorMsg (always <| msg project)


updateProject : Model -> Project -> (Http.Error -> Msg) -> (Project -> Msg) -> Cmd Msg
updateProject model project errorMsg msg =
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
                |> Task.perform errorMsg msg


encodeProject : Project -> JE.Value
encodeProject project =
    JE.object
        [ ( "project"
          , JE.object
                [ ( "name", JE.string project.name )
                ]
          )
        ]
