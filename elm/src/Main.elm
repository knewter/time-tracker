module Main exposing (..)

import Navigation
import View
import Update
import Model exposing (Model)
import Route exposing (Location(Login))
import Msg exposing (Msg(..))
import Material
import Util


type alias ProgramFlags =
    { apiKey : Maybe String
    }


main : Program ProgramFlags
main =
    Navigation.programWithFlags (Navigation.makeParser Route.locFor)
        { init = init
        , update = Update.update
        , urlUpdate = urlUpdate
        , view = View.view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdl model


urlUpdate : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location oldModel =
    let
        newUserForm =
            (Model.initialModel Nothing).usersModel.newUserForm

        oldUsersModel =
            oldModel.usersModel

        newUsersModel =
            { oldUsersModel | newUserForm = newUserForm }

        newModelWithClearedForms =
            { oldModel | route = location, usersModel = newUsersModel }

        ( newModel, loginRedirectCmd ) =
            case newModelWithClearedForms.apiKey of
                Nothing ->
                    case newModelWithClearedForms.route of
                        Just Login ->
                            newModelWithClearedForms ! []

                        _ ->
                            { newModelWithClearedForms | route = Just Login } ! [ Navigation.modifyUrl (Route.urlFor Login) ]

                Just apiKey ->
                    newModelWithClearedForms ! []
    in
        ( newModel
        , Cmd.batch <|
            loginRedirectCmd
                :: Material.init Mdl
                :: (Util.cmdsForModelRoute newModel)
        )


init : ProgramFlags -> Maybe Route.Location -> ( Model, Cmd Msg )
init programFlags location =
    let
        initialModel =
            Model.initialModel location
    in
        case programFlags.apiKey of
            Nothing ->
                urlUpdate location <| initialModel

            Just apiKey ->
                urlUpdate location <| { initialModel | apiKey = Just apiKey }
