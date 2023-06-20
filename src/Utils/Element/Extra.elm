module Utils.Element.Extra exposing (absolute, attIf, bottom, fixed, hidden, left, overflow, position, relative, right, scroll, static, sticky, top, visible)

import Element
import Html.Attributes
import String exposing (fromInt)



-- Conditional Attribute


attIf : Bool -> Element.Attribute msg -> Element.Attribute msg
attIf cond att =
    if cond then
        att

    else
        Element.htmlAttribute <| Html.Attributes.style "" ""



-- Position


type Position
    = Static
    | Relative
    | Fixed
    | Absolute
    | Sticky


position : Position -> Element.Attribute msg
position val =
    Element.htmlAttribute <|
        Html.Attributes.style "position" <|
            case val of
                Static ->
                    "static"

                Relative ->
                    "relative"

                Fixed ->
                    "fixed"

                Absolute ->
                    "absolute"

                Sticky ->
                    "sticky"


static =
    Static


relative =
    Relative


fixed =
    Fixed


absolute =
    Absolute


sticky =
    Sticky



-- Top, Bottom, Left, Right


top : Int -> Element.Attribute msg
top val =
    Element.htmlAttribute <| Html.Attributes.style "top" <| fromInt val ++ "px"


bottom : Int -> Element.Attribute msg
bottom val =
    Element.htmlAttribute <| Html.Attributes.style "bottom" <| fromInt val ++ "px"


left : Int -> Element.Attribute msg
left val =
    Element.htmlAttribute <| Html.Attributes.style "left" <| fromInt val ++ "px"


right : Int -> Element.Attribute msg
right val =
    Element.htmlAttribute <| Html.Attributes.style "right" <| fromInt val ++ "px"



-- Overflow


type Overflow
    = Visible
    | Hidden
    | Scroll


overflow : Overflow -> Element.Attribute msg
overflow val =
    Element.htmlAttribute <|
        Html.Attributes.style "overflow" <|
            case val of
                Visible ->
                    "visible"

                Hidden ->
                    "hidden"

                Scroll ->
                    "scroll"


visible =
    Visible


hidden =
    Hidden


scroll =
    Scroll
