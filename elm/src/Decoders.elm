module Decoders
    exposing
        ( usersDecoder
        , userDecoder
        , projectsDecoder
        , projectDecoder
        , organizationsDecoder
        , organizationDecoder
        , apiFieldErrorsDecoder
        , loginDecoder
        )

import Json.Decode as JD exposing ((:=))
import Types exposing (User, Project, Organization, APIFieldErrors)
import Dict


loginDecoder : JD.Decoder String
loginDecoder =
    JD.succeed "foo"


usersDecoder : JD.Decoder (List User)
usersDecoder =
    JD.list userDecoder


userDecoder : JD.Decoder User
userDecoder =
    JD.object2 User
        (JD.maybe ("id" := JD.int))
        ("name" := JD.string)


projectsDecoder : JD.Decoder (List Project)
projectsDecoder =
    JD.list projectDecoder


projectDecoder : JD.Decoder Project
projectDecoder =
    JD.object2 Project
        (JD.maybe ("id" := JD.int))
        ("name" := JD.string)


organizationsDecoder : JD.Decoder (List Organization)
organizationsDecoder =
    JD.list organizationDecoder


organizationDecoder : JD.Decoder Organization
organizationDecoder =
    JD.object2 Organization
        (JD.maybe ("id" := JD.int))
        ("name" := JD.string)


apiFieldErrorsDecoder : JD.Decoder APIFieldErrors
apiFieldErrorsDecoder =
    "errors" := (JD.dict <| JD.list JD.string)
