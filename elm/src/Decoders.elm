module Decoders
    exposing
        ( usersDecoder
        , userDecoder
        , projectsDecoder
        , projectDecoder
        , organizationsDecoder
        , organizationDecoder
        , apiFieldErrorsDecoder
        , dayActivityDecoder
        , chartDataDecoder
        )

import Json.Decode as JD exposing ((:=))
import Json.Decode.Extra as JDE
import Types exposing (User, Project, Organization, APIFieldErrors, DayActivity(..))
import Dict
import Date exposing (Date)


chartDataDecoder : JD.Decoder (List ( Date, Float ))
chartDataDecoder =
    JD.list <|
        JD.tuple2 (,)
            (JD.map Date.fromTime JD.float)
            JD.float


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


dayActivityDecoder : JD.Decoder DayActivity
dayActivityDecoder =
    JD.object2 DayActivity
        ("date" := JDE.date)
        ("count" := JD.int)
