module View.Pieces.PaginatedTable exposing (paginationData)

import Types exposing (Paginated)
import Msg exposing (Msg(..))
import Html exposing (Html, text, div)
import Html.Attributes exposing (style)
import Material.Grid exposing (grid, size, cell, Device(..))
import Material.Options as Options
import Material.Button as Button
import Material


paginationData : List Int -> (String -> Msg) -> Material.Model -> Paginated a -> Html Msg
paginationData mdlIndexPrefix tagger mdl paginatedData =
    let
        toButton link label index =
            Button.render Mdl
                (mdlIndexPrefix ++ [ index ])
                mdl
                [ Button.ripple
                , Button.onClick <| tagger link.target
                ]
                [ text label ]

        toListButton maybeLink label index =
            maybeLink
                |> Maybe.map (\l -> [ toButton l label index ])
                |> Maybe.withDefault []

        firstButton =
            toListButton paginatedData.links.first "first" 1

        previousButton =
            toListButton paginatedData.links.previous "previous" 2

        nextButton =
            toListButton paginatedData.links.next "next" 3

        lastButton =
            toListButton paginatedData.links.last "last" 4

        pageProgressText =
            (toString paginatedData.pageNumber) ++ " of " ++ (toString paginatedData.totalPages) ++ " pages"

        firstItemNumber =
            ((paginatedData.pageNumber - 1) * paginatedData.perPage) + 1

        itemRange =
            (toString firstItemNumber) ++ " - " ++ (toString <| (firstItemNumber + (List.length paginatedData.items) - 1))
    in
        grid [ Options.css "width" "100%" ]
            [ cell
                [ size All 6 ]
                [ div
                    [ style [ ( "padding-top", "0.5em" ) ] ]
                    [ text <| itemRange ++ " of " ++ (toString paginatedData.total) ]
                ]
            , cell
                [ size All 6 ]
                [ div
                    [ style [ ( "text-align", "right" ) ] ]
                  <|
                    [ div [ style [ ( "display", "inline-block" ), ( "margin-right", "1em" ) ] ] [ text pageProgressText ] ]
                        ++ (firstButton
                                ++ previousButton
                                ++ nextButton
                                ++ lastButton
                           )
                ]
            ]
