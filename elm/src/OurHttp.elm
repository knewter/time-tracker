module OurHttp exposing (fromJson, Error(..), fromJsonWithHeaders)

import Http exposing (Value(..), RawError(..))
import Task exposing (Task, fail, succeed, mapError, andThen, map)
import Json.Decode as JD
import Dict exposing (Dict)


fromJson : JD.Decoder a -> Task Http.RawError Http.Response -> Task Error a
fromJson decoder response =
    let
        decode str =
            case JD.decodeString decoder str of
                Ok v ->
                    succeed v

                Err msg ->
                    fail (UnexpectedPayload msg)
    in
        mapError promoteError response
            `andThen` handleResponseValue decode


fromJsonWithHeaders : JD.Decoder a -> (Dict String String -> a -> b) -> Task Http.RawError Http.Response -> Task Error b
fromJsonWithHeaders decoder merger response =
    let
        decode str =
            case JD.decodeString decoder str of
                Ok v ->
                    succeed v

                Err msg ->
                    fail (UnexpectedPayload msg)
    in
        mapError promoteError response
            `andThen` handleResponseValueWithHeaders decode merger


type Error
    = Timeout
    | NetworkError
    | UnexpectedPayload String
    | BadResponse Int String Http.Value


promoteError : Http.RawError -> Error
promoteError rawError =
    case rawError of
        RawTimeout ->
            Timeout

        RawNetworkError ->
            NetworkError


handleResponseValue : (String -> Task Error a) -> Http.Response -> Task Error a
handleResponseValue handle response =
    if 200 <= response.status && response.status < 300 then
        case response.value of
            Text str ->
                handle str

            _ ->
                fail (UnexpectedPayload "Response body is a blob, expecting a string.")
    else
        fail (BadResponse response.status response.statusText response.value)


handleResponseValueWithHeaders : (String -> Task Error a) -> (Dict String String -> a -> b) -> Http.Response -> Task Error b
handleResponseValueWithHeaders handle merger response =
    if 200 <= response.status && response.status < 300 then
        case response.value of
            Text str ->
                handle str
                    |> map (merger response.headers)

            _ ->
                fail (UnexpectedPayload "Response body is a blob, expecting a string.")
    else
        fail (BadResponse response.status response.statusText response.value)
