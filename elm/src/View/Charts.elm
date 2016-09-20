module View.Charts exposing (..)

import Svg exposing (Svg, svg)
import Svg.Attributes exposing (width, height)
import Chart exposing (Scale, Data)
import BarChart exposing (barChart, color, width)
import LineChart exposing (lineChart, color, width)
import ScatterPlot exposing (scatterPlot, color, size)


data : Data msg
data =
    [ ( 1, 22.2, [] )
    , ( 2, 34, [] )
    , ( 3, 56, [] )
    , ( 4, 62, [] )
    , ( 5, 77, [] )
    ]


xScale : Int -> Scale
xScale width x =
    20 + x * (toFloat width / 8)


yScale : Int -> Scale
yScale height y =
    (toFloat height) - (y * 3)


activity : ( Int, Int ) -> Svg msg
activity ( width, height ) =
    svg
        [ Svg.Attributes.width (toString width)
        , Svg.Attributes.height (toString height)
        ]
        [ lineChart
            [ LineChart.color "#7E94C7"
            , LineChart.width "4"
            ]
            { data = data
            , xScale = xScale width
            , yScale = yScale height
            }
        ]
