module Main exposing (..)

import Navigation
import View
import Update
import Model exposing (Model)
import Route exposing (Location(Login))
import Msg exposing (Msg(..))
import Material
import Util


main : Program Never
main =
    Navigation.program (Navigation.makeParser Route.locFor)
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
        newModelWithClearedForms =
            { oldModel | route = location, newUserForm = (Model.initialModel Nothing).newUserForm }

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
        , Cmd.batch <| loginRedirectCmd :: (Util.cmdsForModelRoute newModel)
        )


init : Maybe Route.Location -> ( Model, Cmd Msg )
init location =
    urlUpdate location <| Model.initialModel location
