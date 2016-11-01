module View.Projects exposing (view, header)

import Model exposing (Model)
import Types exposing (Project, ProjectSortableField(..), Sorted(..), Paginated)
import Msg exposing (Msg(..), ProjectMsg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div, a, img, span)
import Html.Attributes exposing (href, src, style, colspan, class)
import Material.List as List
import Material.Button as Button
import Material.Icon as Icon
import Material.Table as Table
import Material.Options as Options
import Material.Elevation as Elevation
import Material.Layout as Layout
import Material.Textfield as Textfield
import View.Helpers as Helpers
import View.Pieces.PaginatedTable as PaginatedTable
import Util exposing (onEnter)
import RemoteData exposing (RemoteData(..))


view : Model -> Html Msg
view model =
    div []
        [ projectsTable model ]


renderTable : Model -> Paginated Project -> Html Msg
renderTable model paginatedProjects =
    Table.table
        [ Options.css "width" "100%"
        , Elevation.e2
        ]
        [ Table.thead []
            [ Table.th
                (thOptions ProjectName model)
                [ text "Name" ]
            , Table.th []
                [ Textfield.render Mdl
                    [ 3, 4 ]
                    model.mdl
                    [ Textfield.label "Search"
                    , Textfield.floatingLabel
                    , Textfield.text'
                    , Textfield.value model.projectsModel.projectSearchQuery
                    , Textfield.onInput <| ProjectMsg' << SetProjectSearchQuery
                    , onEnter <| ProjectMsg' <| FetchProjects <| "/projects?q=" ++ model.projectsModel.projectSearchQuery
                    ]
                ]
            ]
        , Table.tbody []
            (List.indexedMap (projectRow model) paginatedProjects.items)
        , Table.tfoot []
            [ Html.td [ colspan 999, class "mdl-data-table__cell--non-numeric" ]
                [ PaginatedTable.paginationData [ 3, 3 ] (ProjectMsg' << FetchProjects) model.mdl paginatedProjects ]
            ]
        ]


projectsTable : Model -> Html Msg
projectsTable model =
    case model.projectsModel.projects.current of
        NotAsked ->
            text "Initialising..."

        Loading ->
            case model.projectsModel.projects.previous of
                Nothing ->
                    text "Loading..."

                Just previousProjects ->
                    div [ class "loading" ]
                        [ renderTable model previousProjects
                        ]

        Failure err ->
            case model.projectsModel.projects.previous of
                Nothing ->
                    text <| "There was a problem fetching the Projeccts: " ++ toString err

                Just previousProjects ->
                    div []
                        [ text <| "There was a problem fetching the Projects: " ++ toString err
                        , renderTable model previousProjects
                        ]

        Success paginatedProjects ->
            renderTable model paginatedProjects


projectRow : Model -> Int -> Project -> Html Msg
projectRow model index project =
    let
        attributes =
            case project.id of
                Nothing ->
                    []

                Just id ->
                    [ href (Route.urlFor (ShowProject id)) ]
    in
        Table.tr []
            [ Table.td [] [ a attributes [ text project.name ] ]
            , Table.td []
                [ editButton model index project
                , deleteButton model index project
                ]
            ]


addButton : Model -> Html Msg
addButton model =
    Button.render Mdl
        [ 3, 0 ]
        model.mdl
        [ Options.css "position" "fixed"
        , Options.css "display" "block"
        , Options.css "right" "0"
        , Options.css "top" "0"
        , Options.css "margin-right" "35px"
        , Options.css "margin-top" "35px"
        , Options.css "z-index" "900"
        , Button.fab
        , Button.colored
        , Button.ripple
        , Button.onClick <| NavigateTo <| Just NewProject
        ]
        [ Icon.i "add" ]


deleteButton : Model -> Int -> Project -> Html Msg
deleteButton model index project =
    Button.render Mdl
        [ 3, 1, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.onClick <| ProjectMsg' <| DeleteProject project
        ]
        [ Icon.i "delete" ]


editButton : Model -> Int -> Project -> Html Msg
editButton model index project =
    case project.id of
        Nothing ->
            text ""

        Just id ->
            Button.render Mdl
                [ 3, 2, index ]
                model.mdl
                [ Button.minifab
                , Button.colored
                , Button.ripple
                , Button.onClick <| NavigateTo <| Just <| EditProject id
                ]
                [ Icon.i "edit" ]


thOptions : ProjectSortableField -> Model -> List (Options.Property (Util.MaterialTableHeader Msg) Msg)
thOptions sortableField model =
    [ Table.onClick <| ProjectMsg' <| ReorderProjects sortableField
    , Options.css "cursor" "pointer"
    ]
        ++ case model.projectsModel.projectsSort of
            Nothing ->
                []

            Just ( sorted, sortedField ) ->
                case sortedField == sortableField of
                    True ->
                        case sorted of
                            Ascending ->
                                [ Table.sorted Table.Ascending ]

                            Descending ->
                                [ Table.sorted Table.Descending ]

                    False ->
                        []


header : Model -> List (Html Msg)
header model =
    Helpers.defaultHeaderWithNavigation model "Projects" [ addButton model ]
