module Route exposing (..)

import String exposing (split)
import Navigation


type Location
    = Home
    | Users
    | NewUser
    | ShowUser Int


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

            _ ->
                Nothing
