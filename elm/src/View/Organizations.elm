module View.Organizations exposing (view, header)

import Model exposing (Model)
import Types exposing (Organization, OrganizationSortableField(..), Sorted(..), Paginated)
import Msg exposing (Msg(..), OrganizationMsg(..))
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
import View.Helpers as Helpers
import View.Pieces.PaginatedTable as PaginatedTable
import Util
import RemoteData exposing (RemoteData(..))


view : Model -> Html Msg
view model =
    div []
        [ organizationsTable model ]


organizationsTable : Model -> Html Msg
organizationsTable model =
    case model.organizationsModel.organizations.current of
        NotAsked ->
            text "Initialising..."

        Loading ->
            text "Loading..."

        Failure err ->
            text <| "There was a problem fetching the organizations: " ++ toString err

        Success paginatedOrganizations ->
            div []
                [ Table.table
                    [ Options.css "width" "100%"
                    , Elevation.e2
                    ]
                    [ Table.thead []
                        [ Table.th
                            (thOptions OrganizationName model)
                            [ text "Name" ]
                        , Table.th [] [ text "Actions" ]
                        ]
                    , Table.tbody []
                        (List.indexedMap (organizationRow model) paginatedOrganizations.items)
                    , Table.tfoot []
                        [ Html.td [ colspan 999, class "mdl-data-table__cell--non-numeric" ]
                            [ PaginatedTable.paginationData [ 7, 3 ] (OrganizationMsg' << FetchOrganizations) model paginatedOrganizations ]
                        ]
                    ]
                ]


organizationRow : Model -> Int -> Organization -> Html Msg
organizationRow model index organization =
    let
        attributes =
            case organization.id of
                Nothing ->
                    []

                Just id ->
                    [ href (Route.urlFor (ShowOrganization id)) ]
    in
        Table.tr []
            [ Table.td [] [ a attributes [ text organization.name ] ]
            , Table.td []
                [ editButton model index organization
                , deleteButton model index organization
                ]
            ]


addButton : Model -> Html Msg
addButton model =
    Button.render Mdl
        [ 7, 0 ]
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
        , Button.onClick <| NavigateTo <| Just NewOrganization
        ]
        [ Icon.i "add" ]


deleteButton : Model -> Int -> Organization -> Html Msg
deleteButton model index organization =
    Button.render Mdl
        [ 7, 1, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.onClick <| OrganizationMsg' <| DeleteOrganization organization
        ]
        [ Icon.i "delete" ]


editButton : Model -> Int -> Organization -> Html Msg
editButton model index organization =
    case organization.id of
        Nothing ->
            text ""

        Just id ->
            Button.render Mdl
                [ 7, 2, index ]
                model.mdl
                [ Button.minifab
                , Button.colored
                , Button.ripple
                , Button.onClick <| NavigateTo <| Just <| EditOrganization id
                ]
                [ Icon.i "edit" ]


thOptions : OrganizationSortableField -> Model -> List (Options.Property (Util.MaterialTableHeader Msg) Msg)
thOptions sortableField model =
    [ Table.onClick <| OrganizationMsg' <| ReorderOrganizations sortableField
    , Options.css "cursor" "pointer"
    ]
        ++ case model.organizationsModel.organizationsSort of
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
    Helpers.defaultHeaderWithNavigation model "Organizations" [ addButton model ]
