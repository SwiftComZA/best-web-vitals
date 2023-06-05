module UI.Navbar exposing (..)

import Element
    exposing
        ( alignLeft
        , centerY
        , el
        , fill
        , height
        , layout
        , link
        , mouseOver
        , px
        , rgb255
        , rgba
        , row
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)


view : Html msg
view =
    layout [ width fill ] <|
        row
            [ width fill
            , height <| px 75
            , Border.shadow
                { offset = ( 0, 0 )
                , size = 0
                , blur = 20
                , color = rgba 0 0 0 0.15
                }
            ]
            [ link
                [ alignLeft
                , height fill
                , mouseOver [ Background.color <| rgb255 103 162 235 ]
                ]
                { url = "/"
                , label =
                    el
                        [ centerY
                        , width <| px 100
                        , Font.center
                        ]
                    <|
                        text "Home"
                }
            , link
                [ alignLeft
                , height fill
                , mouseOver [ Background.color <| rgb255 103 162 235 ]
                ]
                { url = "/admin"
                , label =
                    el
                        [ centerY
                        , width <| px 100
                        , Font.center
                        ]
                    <|
                        text "Admin"
                }
            , link
                [ alignLeft
                , height fill
                , mouseOver [ Background.color <| rgb255 103 162 235 ]
                ]
                { url = "/add-site"
                , label =
                    el
                        [ centerY
                        , width <| px 100
                        , Font.center
                        ]
                    <|
                        text "Add Site"
                }
            ]
