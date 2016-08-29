module Route exposing (..)

import String exposing (split)
import Navigation


type Location
    = Home
    | Users
    | NewUser
    | ShowUser Int
    | EditUser Int
    | Projects
    | NewProject
    | ShowProject Int
    | EditProject Int


type alias Model =
    Maybe Location


init : Maybe Location -> Model
init location =
    location


urlFor : Location -> String
urlFor loc =
    let
        url =
            case loc of
                Home ->
                    "/"

                Users ->
                    "/users"

                NewUser ->
                    "/users/new"

                ShowUser id ->
                    "/users/" ++ (toString id)

                EditUser id ->
                    "/users/" ++ (toString id) ++ "/edit"

                Projects ->
                    "/projects"

                NewProject ->
                    "/projects/new"

                ShowProject id ->
                    "/projects/" ++ (toString id)

                EditProject id ->
                    "/projects/" ++ (toString id) ++ "/edit"
    in
        "#" ++ url


locFor : Navigation.Location -> Maybe Location
locFor path =
    let
        segments =
            path.hash
                |> split "/"
                |> List.filter (\seg -> seg /= "" && seg /= "#")
    in
        case segments of
            [] ->
                Just Home

            [ "users" ] ->
                Just Users

            [ "users", "new" ] ->
                Just NewUser

            [ "users", stringId ] ->
                case String.toInt stringId of
                    Ok id ->
                        Just (ShowUser id)

                    Err _ ->
                        Nothing

            [ "users", stringId, "edit" ] ->
                String.toInt stringId
                    |> Result.toMaybe
                    |> Maybe.map EditUser

            [ "projects" ] ->
                Just Projects

            [ "projects", "new" ] ->
                Just NewProject

            [ "projects", stringId ] ->
                case String.toInt stringId of
                    Ok id ->
                        Just (ShowProject id)

                    Err _ ->
                        Nothing

            [ "projects", stringId, "edit" ] ->
                String.toInt stringId
                    |> Result.toMaybe
                    |> Maybe.map EditProject

            _ ->
                Nothing
