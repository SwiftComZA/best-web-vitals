module Vectors.MobileIcon exposing (..)

import Element
import Svg as Svg exposing (..)
import Svg.Attributes as SvgAttr


mobileIcon selected =
    Element.html <|
        svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.viewBox "0 0 1024 1024"
            , SvgAttr.version "1.1"
            , SvgAttr.xmlSpace "preserve"
            , SvgAttr.style "fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
            ]
            [ Svg.g
                [ SvgAttr.transform "matrix(11.4447,0,0,11.4447,-4803.67,-3407.54)"
                ]
                [ path
                    [ SvgAttr.d "M485.12,370.876L443.811,370.876L443.811,314.076L485.12,314.076L485.12,370.876ZM464.465,381.203C462.328,381.203 460.592,379.468 460.592,377.332C460.592,375.193 462.328,373.458 464.465,373.458C466.603,373.458 468.338,375.193 468.338,377.332C468.338,379.468 466.603,381.203 464.465,381.203ZM455.428,306.332L473.502,306.332C474.217,306.332 474.793,306.908 474.793,307.621C474.793,308.335 474.217,308.912 473.502,308.912L455.428,308.912C454.712,308.912 454.138,308.335 454.138,307.621C454.138,306.908 454.712,306.332 455.428,306.332ZM485.12,301.167L443.811,301.167C440.957,301.167 438.647,303.48 438.647,306.332L438.647,378.623C438.647,381.474 440.957,383.785 443.811,383.785L485.12,383.785C487.974,383.785 490.283,381.474 490.283,378.623L490.283,306.332C490.283,303.48 487.974,301.167 485.12,301.167Z"
                    , SvgAttr.style
                        ("fill:rgb("
                            ++ (if selected then
                                    "24,81,125"

                                else
                                    "150, 150, 150"
                               )
                            ++ ");fill-rule:nonzero;transition: fill 0.3s ease-out;"
                        )
                    ]
                    []
                ]
            ]
