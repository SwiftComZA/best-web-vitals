module UI.Styles exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (style)


color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF
    , red = rgb255 0xFF 0x00 0x00
    , green = rgb255 0x00 0xFF 0x00
    }


noPadding =
    { top = 0
    , bottom = 0
    , left = 0
    , right = 0
    }


buttonStyle =
    [ padding 10
    , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 20, color = rgba 0 0 0 0.15 }
    , width fill
    , Font.center
    , mouseOver
        [ Background.color color.lightBlue
        ]
    , focused []
    ]


inputStyle =
    [ Border.shadow { offset = ( 0, 0 ), size = 0, blur = 20, color = rgba 0 0 0 0.15 }
    , Border.width 0
    , Border.rounded 0
    , focused []
    ]


dropdownStyle =
    [ Border.shadow { offset = ( 0, 0 ), size = 0, blur = 20, color = Element.rgba 0 0 0 0.15 }
    ]


footerStyle =
    [ style "height" "50px"
    , style "position" "sticky"
    , style "width" "100%"
    , style "bottom" "0"
    , style "box-shadow" "0px 0px 20px 0px rgba(0,0,0,0.15)"
    , style "font-family" "\"Open Sans\", Helvetica, Verdana, sans-serif"
    , style "display" "flex"
    , style "justify-content" "space-between"
    , style "align-items" "center"
    , style "padding" "0 20px"
    , style "box-sizing" "border-box"
    , style "background" "white"
    ]
