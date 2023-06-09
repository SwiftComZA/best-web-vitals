module Utils.If exposing (..)

import Element exposing (Element, none)


viewIf : Bool -> Element msg -> Element msg
viewIf condition view =
    if condition then
        view

    else
        none


viewIfElse : Bool -> Element msg -> Element msg -> Element msg
viewIfElse condition viewIfTrue viewIfFalse =
    if condition then
        viewIfTrue

    else
        viewIfFalse
