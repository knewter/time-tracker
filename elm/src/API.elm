module API
    exposing
        ( login
        , fetchUsers
        , fetchUsersWithUrl
        , createUser
        , deleteUser
        , fetchUser
        , updateUser
        , fetchProjects
        , fetchProjectsWithUrl
        , createProject
        , deleteProject
        , fetchProject
        , updateProject
        , fetchOrganizations
        , fetchOrganizationsWithUrl
        , createOrganization
        , deleteOrganization
        , fetchOrganization
        , updateOrganization
        )

import Model exposing (Model)
import Msg exposing (Msg(..))
import Types exposing (User, Project, Organization, Paginated)
import Decoders
import OurHttp exposing (Error)
import Http
import Task
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))
import Dict exposing (Dict)
import RFC5988
import Combine exposing (parse)
import String


login : Model -> ( String, String ) -> (Error -> Msg) -> (String -> Msg) -> Cmd Msg
login model loginForm errorMsg msg =
    post model "/sessions" (encodeLoginForm loginForm) ("token" := JD.string) errorMsg msg


fetchResources : String -> JD.Decoder (List a) -> Model -> (OurHttp.Error -> Msg) -> (Paginated a -> Msg) -> Cmd Msg
fetchResources endpoint decoder model errorMsg msg =
    fetchResourcesWithUrl endpoint decoder model errorMsg msg


fetchResourcesWithUrl : String -> JD.Decoder (List a) -> Model -> (OurHttp.Error -> Msg) -> (Paginated a -> Msg) -> Cmd Msg
fetchResourcesWithUrl url decoder model errorMsg msg =
    let
        apiPath =
            case getQueryParams url of
                Nothing ->
                    url

                Just queryParams ->
                    url ++ "?" ++ queryParams
    in
        getPaginated model apiPath decoder errorMsg msg


fetchUsers : Model -> (OurHttp.Error -> Msg) -> (Paginated User -> Msg) -> Cmd Msg
fetchUsers model errorMsg msg =
    fetchResources "/users" Decoders.usersDecoder model errorMsg msg


fetchUsersWithUrl : String -> Model -> (OurHttp.Error -> Msg) -> (Paginated User -> Msg) -> Cmd Msg
fetchUsersWithUrl url model errorMsg msg =
    fetchResourcesWithUrl url Decoders.usersDecoder model errorMsg msg


getQueryParams : String -> Maybe String
getQueryParams url =
    url
        |> String.split "/"
        |> List.drop 3
        |> List.head
        |> Maybe.map (String.split "?" >> List.drop 1 >> List.head)
        |> Maybe.withDefault Nothing


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


encodeLoginForm : ( String, String ) -> JE.Value
encodeLoginForm ( username, password ) =
    JE.object
        [ ( "username", JE.string username )
        , ( "password", JE.string password )
        ]


encodeUser : User -> JE.Value
encodeUser user =
    JE.object
        [ ( "user"
          , JE.object
                [ ( "name", JE.string user.name )
                ]
          )
        ]


fetchProjects : Model -> (OurHttp.Error -> Msg) -> (Paginated Project -> Msg) -> Cmd Msg
fetchProjects model errorMsg msg =
    fetchResources "/projects" Decoders.projectsDecoder model errorMsg msg


fetchProjectsWithUrl : String -> Model -> (OurHttp.Error -> Msg) -> (Paginated Project -> Msg) -> Cmd Msg
fetchProjectsWithUrl url model errorMsg msg =
    fetchResourcesWithUrl url Decoders.projectsDecoder model errorMsg msg


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


fetchOrganizations : Model -> (OurHttp.Error -> Msg) -> (Paginated Organization -> Msg) -> Cmd Msg
fetchOrganizations model errorMsg msg =
    fetchResources "/organizations" Decoders.organizationsDecoder model errorMsg msg


fetchOrganizationsWithUrl : String -> Model -> (OurHttp.Error -> Msg) -> (Paginated Organization -> Msg) -> Cmd Msg
fetchOrganizationsWithUrl url model errorMsg msg =
    fetchResourcesWithUrl url Decoders.organizationsDecoder model errorMsg msg


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


defaultRequest : Model -> String -> Http.Request
defaultRequest model path =
    let
        conditionalHeaders =
            case model.apiKey of
                Nothing ->
                    []

                Just apiKey ->
                    [ ( "Authorization", "Bearer " ++ apiKey ) ]
    in
        { verb = "GET"
        , url = model.baseUrl ++ path
        , body = Http.empty
        , headers = [ ( "Content-Type", "application/json" ) ] ++ conditionalHeaders
        }


get : Model -> String -> JD.Decoder a -> (Http.Error -> Msg) -> (a -> Msg) -> Cmd Msg
get model path decoder errorMsg msg =
    Http.send Http.defaultSettings
        (defaultRequest model path)
        |> Http.fromJson ("data" := decoder)
        |> Task.perform errorMsg msg


getPaginated : Model -> String -> JD.Decoder (List a) -> (OurHttp.Error -> Msg) -> (Paginated a -> Msg) -> Cmd Msg
getPaginated model path decoder errorMsg msg =
    Http.send Http.defaultSettings
        (defaultRequest model path)
        |> OurHttp.fromJsonWithHeaders ("data" := decoder) paginationParser
        |> Task.perform errorMsg msg


paginationParser : Dict String String -> List a -> Paginated a
paginationParser headers data =
    let
        _ =
            Debug.log "headers" headers

        links =
            case headers |> Dict.get "link" of
                Nothing ->
                    []

                Just linksString ->
                    case parse RFC5988.rfc5988s linksString of
                        ( Ok links, _ ) ->
                            links

                        ( Err err, _ ) ->
                            Debug.log ("failed to parse links: " ++ (String.join ", " err)) []

        next =
            List.filter (\l -> l.relationType == "next") links |> List.head

        first =
            List.filter (\l -> l.relationType == "first") links |> List.head

        last =
            List.filter (\l -> l.relationType == "last") links |> List.head

        previous =
            List.filter (\l -> l.relationType == "prev") links |> List.head

        getMaybeStringNumber field =
            headers |> Dict.get field |> Maybe.withDefault "0" |> String.toInt |> Result.withDefault 0

        pageNumber =
            getMaybeStringNumber "page-number"

        totalPages =
            getMaybeStringNumber "total-pages"

        perPage =
            getMaybeStringNumber "per-page"

        total =
            getMaybeStringNumber "total"
    in
        { items = data
        , total = total
        , perPage = perPage
        , totalPages = totalPages
        , pageNumber = pageNumber
        , links =
            { first = first
            , last = last
            , next = next
            , previous = previous
            }
        }


post : Model -> String -> JE.Value -> JD.Decoder a -> (OurHttp.Error -> Msg) -> (a -> Msg) -> Cmd Msg
post model path encoded decoder errorMsg msg =
    let
        request =
            defaultRequest model path
    in
        Http.send Http.defaultSettings
            { request
                | verb = "POST"
                , body = Http.string (encoded |> JE.encode 0)
            }
            |> OurHttp.fromJson ("data" := decoder)
            |> Task.perform errorMsg msg


delete : Model -> String -> (Http.RawError -> Msg) -> Msg -> Cmd Msg
delete model path errorMsg msg =
    let
        request =
            defaultRequest model path
    in
        Http.send Http.defaultSettings
            { request | verb = "DELETE" }
            |> Task.perform errorMsg (always msg)


put : Model -> String -> JE.Value -> JD.Decoder a -> (OurHttp.Error -> Msg) -> (a -> Msg) -> Cmd Msg
put model path encoded decoder errorMsg msg =
    let
        request =
            defaultRequest model path
    in
        Http.send Http.defaultSettings
            { request
                | verb = "PUT"
                , body = Http.string (encoded |> JE.encode 0)
            }
            |> OurHttp.fromJson ("data" := decoder)
            |> Task.perform errorMsg msg
