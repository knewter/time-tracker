module Decoders
    exposing
        ( usersDecoder
        , userDecoder
        , projectsDecoder
        , projectDecoder
        )

import Json.Decode as JD exposing ((:=))
import Types exposing (User, Project)


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
