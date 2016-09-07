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
        , fetchOrganizations
        , createOrganization
        , deleteOrganization
        , fetchOrganization
        , updateOrganization
        )

import Model exposing (Model)
import Msg exposing (Msg(..))
import Types exposing (User, Project, Organization)
import Decoders
import Json.Decode exposing ((:=))
import OurHttp exposing (Error)
import Http
import Task
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))


fetchUsers : Model -> (Http.Error -> Msg) -> (List User -> Msg) -> Cmd Msg
fetchUsers model errorMsg msg =
    get model "/users" Decoders.usersDecoder errorMsg msg


fetchUser : Model -> Int -> (Http.Error -> Msg) -> (User -> Msg) -> Cmd Msg
fetchUser model id errorMsg msg =
    get model ("/users/" ++ (toString id)) Decoders.userDecoder errorMsg msg


createUser : Model -> User -> (Error -> Msg) -> (User -> Msg) -> Cmd Msg
createUser model user errorMsg msg =
    post model "/users" (encodeUser user) Decoders.userDecoder errorMsg msg


deleteUser : Model -> User -> (Http.RawError -> Msg) -> (User -> Msg) -> Cmd Msg
deleteUser model user errorMsg msg =
    case user.id of
        Nothing ->
            Cmd.none

        Just id ->
            delete model ("/users/" ++ (toString id)) errorMsg (msg user)


updateUser : Model -> User -> (Error -> Msg) -> (User -> Msg) -> Cmd Msg
updateUser model user errorMsg msg =
    case user.id of
        Nothing ->
            Cmd.none

        Just id ->
            put model ("/users/" ++ (toString id)) (encodeUser user) Decoders.userDecoder errorMsg msg


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
    get model "/projects" Decoders.projectsDecoder errorMsg msg


fetchProject : Model -> Int -> (Http.Error -> Msg) -> (Project -> Msg) -> Cmd Msg
fetchProject model id errorMsg msg =
    get model ("/projects/" ++ (toString id)) Decoders.projectDecoder errorMsg msg


createProject : Model -> Project -> (Error -> Msg) -> (Project -> Msg) -> Cmd Msg
createProject model project errorMsg msg =
    post model "/projects" (encodeProject project) Decoders.projectDecoder errorMsg msg


deleteProject : Model -> Project -> (Http.RawError -> Msg) -> (Project -> Msg) -> Cmd Msg
deleteProject model project errorMsg msg =
    case project.id of
        Nothing ->
            Cmd.none

        Just id ->
            delete model ("/projects/" ++ (toString id)) errorMsg (msg project)


updateProject : Model -> Project -> (Error -> Msg) -> (Project -> Msg) -> Cmd Msg
updateProject model project errorMsg msg =
    case project.id of
        Nothing ->
            Cmd.none

        Just id ->
            put model ("/projects/" ++ (toString id)) (encodeProject project) Decoders.userDecoder errorMsg msg


encodeProject : Project -> JE.Value
encodeProject project =
    JE.object
        [ ( "project"
          , JE.object
                [ ( "name", JE.string project.name )
                ]
          )
        ]


fetchOrganizations : Model -> (Http.Error -> Msg) -> (List Organization -> Msg) -> Cmd Msg
fetchOrganizations model errorMsg msg =
    get model "/organizations" Decoders.organizationsDecoder errorMsg msg


fetchOrganization : Model -> Int -> (Http.Error -> Msg) -> (Organization -> Msg) -> Cmd Msg
fetchOrganization model id errorMsg msg =
    get model ("/organizations/" ++ (toString id)) Decoders.organizationDecoder errorMsg msg


createOrganization : Model -> Organization -> (Error -> Msg) -> (Organization -> Msg) -> Cmd Msg
createOrganization model organization errorMsg msg =
    post model "/organizations" (encodeOrganization organization) Decoders.organizationDecoder errorMsg msg


deleteOrganization : Model -> Organization -> (Http.RawError -> Msg) -> (Organization -> Msg) -> Cmd Msg
deleteOrganization model organization errorMsg msg =
    case organization.id of
        Nothing ->
            Cmd.none

        Just id ->
            delete model ("/organizations/" ++ (toString id)) errorMsg (msg organization)


updateOrganization : Model -> Organization -> (Error -> Msg) -> (Organization -> Msg) -> Cmd Msg
updateOrganization model organization errorMsg msg =
    case organization.id of
        Nothing ->
            Cmd.none

        Just id ->
            put model ("/organizations/" ++ (toString id)) (encodeOrganization organization) Decoders.userDecoder errorMsg msg


encodeOrganization : Organization -> JE.Value
encodeOrganization organization =
    JE.object
        [ ( "organization"
          , JE.object
                [ ( "name", JE.string organization.name )
                ]
          )
        ]


get : Model -> String -> JD.Decoder a -> (Http.Error -> Msg) -> (a -> Msg) -> Cmd Msg
get model path decoder errorMsg msg =
    Http.get ("data" := decoder) (model.baseUrl ++ path)
        |> Task.perform errorMsg msg


post : Model -> String -> JE.Value -> JD.Decoder a -> (OurHttp.Error -> Msg) -> (a -> Msg) -> Cmd Msg
post model path encoded decoder errorMsg msg =
    Http.send Http.defaultSettings
        { verb = "POST"
        , url = model.baseUrl ++ path
        , body = Http.string (encoded |> JE.encode 0)
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> OurHttp.fromJson ("data" := decoder)
        |> Task.perform errorMsg msg


delete : Model -> String -> (Http.RawError -> Msg) -> Msg -> Cmd Msg
delete model path errorMsg msg =
    Http.send Http.defaultSettings
        { verb = "DELETE"
        , url = model.baseUrl ++ path
        , body = Http.empty
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> Task.perform errorMsg (always msg)


put : Model -> String -> JE.Value -> JD.Decoder a -> (OurHttp.Error -> Msg) -> (a -> Msg) -> Cmd Msg
put model path encoded decoder errorMsg msg =
    Http.send Http.defaultSettings
        { verb = "PUT"
        , url = model.baseUrl ++ path
        , body = Http.string (encoded |> JE.encode 0)
        , headers = [ ( "Content-Type", "application/json" ) ]
        }
        |> OurHttp.fromJson ("data" := decoder)
        |> Task.perform errorMsg msg
