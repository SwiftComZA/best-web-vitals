module Vectors.FeatherArrow exposing (..)

import Element
import Svg as Svg exposing (..)
import Svg.Attributes as SvgAttr


featherArrow rotated =
    Element.html <|
        svg
            [ SvgAttr.width "10"
            , SvgAttr.height "15"
            , SvgAttr.viewBox "0 0 22 43"
            , SvgAttr.fill "none"
            , SvgAttr.style
                ("transform: rotate("
                    ++ (if rotated then
                            "-90deg"

                        else
                            "90deg"
                       )
                    ++ ");transition: transform 0.1s ease-out;"
                )
            ]
            [ path
                [ SvgAttr.d "M1.90451 42.8137C1.43742 42.8137 0.97034 42.6417 0.60159 42.2729C0.258701 41.9259 0.0664062 41.4578 0.0664062 40.97C0.0664062 40.4822 0.258701 40.014 0.60159 39.6671L16.6299 23.6387C17.8099 22.4587 17.8099 20.5412 16.6299 19.3612L0.60159 3.3329C0.258701 2.98594 0.0664063 2.51779 0.0664062 2.02999C0.0664063 1.54218 0.258701 1.07403 0.60159 0.72707C1.31451 0.0141537 2.49451 0.0141537 3.20742 0.72707L19.2358 16.7554C20.4895 18.0092 21.2024 19.7054 21.2024 21.5C21.2024 23.2946 20.5141 24.9908 19.2358 26.2446L3.20742 42.2729C2.83867 42.6171 2.37159 42.8137 1.90451 42.8137Z"
                , SvgAttr.fill "#CACACA"
                ]
                []
            ]
