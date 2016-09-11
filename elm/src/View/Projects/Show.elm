module View.Projects.Show exposing (view, header)

import Model exposing (Model)
import Types exposing (Project)
import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href)
import Route exposing (Location(..))
import Material.List as Lists
import Material.Options as Options
import View.Helpers as Helpers
import Material.Layout as Layout
import MultiwayTree


type alias Task =
    { id : Maybe Int
    , name : String
    }


type alias Tree =
    MultiwayTree.Tree Task


type alias Forest =
    MultiwayTree.Forest Task


node : String -> Int -> Forest -> Tree
node name id children =
    MultiwayTree.Tree { name = name, id = Just id } children


mockTasks : Tree
mockTasks =
    node "Task 1.1"
        0
        [ node "Task 1.2"
            1
            [ node "Task 1.2.1" 2 [] ]
        , node "Task 1.3" 3 []
        ]


view : Model -> Int -> Html Msg
view model id =
    Lists.ul [] <|
        taskList model 0 mockTasks


taskList : Model -> Int -> Tree -> List (Html Msg)
taskList model depth tasks =
    [ Lists.li
        [ Options.css "margin-left" <| (toString depth) ++ "rem" ]
        [ Lists.content []
            [ text (MultiwayTree.datum tasks).name ]
        ]
    ]
        ++ (List.concatMap (taskList model (depth + 1)) (MultiwayTree.children tasks))


header : Model -> Int -> List (Html Msg)
header model id =
    case model.shownProject of
        Nothing ->
            Helpers.defaultHeader model "No such project"

        Just project ->
            let
                links =
                    [ { route = EditProject id, linkText = "Edit" }
                    , { route = Projects, linkText = "Projects" }
                    ]
            in
                Helpers.defaultHeaderWithNavigation model
                    project.name
                    (List.map
                        (\{ route, linkText } ->
                            Layout.link
                                [ Layout.href <| Route.urlFor route ]
                                [ span [] [ text linkText ] ]
                        )
                        links
                    )
