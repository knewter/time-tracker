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


xScale : Scale
xScale x =
    20 + x * 100


yScale : Scale
yScale y =
    600 - y * 3


activityGraph : Svg msg
activityGraph =
    svg
        [ Svg.Attributes.width "800"
        , Svg.Attributes.height "600"
        ]
        [ lineChart
            [ LineChart.color "#7E94C7"
            , LineChart.width "4"
            ]
            { data = data
            , xScale = xScale
            , yScale = (\y -> 500 - y * 4)
            }
        ]
