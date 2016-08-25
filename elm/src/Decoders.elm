module Decoders exposing (usersDecoder, userDecoder)

import Json.Decode as JD exposing ((:=))
import Types exposing (User)


usersDecoder : JD.Decoder (List User)
usersDecoder =
    JD.list userDecoder


userDecoder : JD.Decoder User
userDecoder =
    JD.object2 User
        (JD.maybe ("id" := JD.int))
        ("name" := JD.string)
