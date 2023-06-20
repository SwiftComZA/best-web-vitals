module Vectors.DesktopIcon exposing (..)

import Svg as Svg exposing (..)
import Svg.Attributes as SvgAttr


desktopIcon selected =
    svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 1024 1024"
        , SvgAttr.version "1.1"
        , SvgAttr.xmlSpace "preserve"
        , SvgAttr.style "fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
        ]
        [ Svg.g
            [ SvgAttr.transform "matrix(1.54899,0,0,1.54899,-13.1428,-322.9)"
            ]
            [ Svg.g
                [ SvgAttr.transform "matrix(10.2283,0,0,10.2283,-1651.74,-2990.97)"
                ]
                [ path
                    [ SvgAttr.d "M224.358,320.818L224.358,357.417C224.358,359.625 222.579,361.41 220.398,361.41L200.624,361.41C200.624,361.41 199.502,369.4 206.621,369.4L206.621,373.396L182.646,373.396L182.646,369.406C189.497,369.406 188.64,361.414 188.64,361.414L168.875,361.414C166.686,361.414 164.906,359.63 164.906,357.423L164.906,320.818C164.906,318.613 166.686,316.837 168.875,316.837L220.394,316.837C222.579,316.837 224.358,318.613 224.358,320.818Z"
                    , SvgAttr.style
                        ("fill:rgb("
                            ++ (if selected then
                                    "173,216,230"

                                else
                                    "10,6,12"
                               )
                            ++ ");"
                        )
                    ]
                    []
                ]
            , Svg.g
                [ SvgAttr.transform "matrix(10.2283,0,0,10.2283,-1651.74,-2990.97)"
                ]
                [ path
                    [ SvgAttr.d "M198.326,356.527C198.326,354.632 196.792,353.105 194.902,353.105C193.007,353.105 191.469,354.632 191.469,356.527C191.469,358.419 193.002,359.955 194.902,359.955C196.796,359.955 198.326,358.419 198.326,356.527Z"
                    , SvgAttr.style "fill:white;"
                    ]
                    []
                ]
            , Svg.g
                [ SvgAttr.transform "matrix(10.2283,0,0,10.2283,-1651.74,-2990.97)"
                ]
                [ path
                    [ SvgAttr.d "M194.937,354.382C193.758,354.382 192.809,355.337 192.809,356.507C192.809,357.683 193.764,358.636 194.937,358.636C196.108,358.636 197.062,357.683 197.062,356.507C197.062,355.337 196.114,354.382 194.937,354.382Z"
                    , SvgAttr.style
                        ("fill:rgb("
                            ++ (if selected then
                                    "173,216,230"

                                else
                                    "10,6,12"
                               )
                            ++ ");"
                        )
                    ]
                    []
                ]
            , Svg.g
                [ SvgAttr.transform "matrix(10.2283,0,0,10.2283,-1651.74,-2990.97)"
                ]
                [ path
                    [ SvgAttr.d "M220.113,321.072L169.156,321.072L169.156,351.929L220.113,351.929L220.113,321.072Z"
                    , SvgAttr.style "fill:white;"
                    ]
                    []
                ]
            ]
        ]
