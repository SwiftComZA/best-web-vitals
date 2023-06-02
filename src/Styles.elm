module Styles exposing (..)

import Element exposing (..)
import Element.Border as Border
import Element.Background as Background
import Element.Font as Font


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    }


buttonStyle =
    [ padding 10
    , Border.width 3
    , Border.rounded 6
    , Border.color color.blue
    , Background.color color.lightBlue
    , Font.variant Font.smallCaps

    -- The order of mouseDown/mouseOver can be significant when changing
    -- the same attribute in both
    , mouseDown
        [ Background.color color.blue
        , Border.color color.blue
        , Font.color color.white
        ]
    , mouseOver
        [ Background.color color.white
        , Border.color color.lightGrey
        ]
    ]
