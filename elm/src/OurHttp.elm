module OurHttp exposing (fromJson, Error(..))

import Http exposing (Value(..), RawError(..))
import Task exposing (Task, fail, succeed, mapError, andThen)
import Json.Decode as JD


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
            `andThen` handleResponse decode


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


handleResponse : (String -> Task Error a) -> Http.Response -> Task Error a
handleResponse handle response =
    if 200 <= response.status && response.status < 300 then
        case response.value of
            Text str ->
                handle str

            _ ->
                fail (UnexpectedPayload "Response body is a blob, expecting a string.")
    else
        fail (BadResponse response.status response.statusText response.value)
