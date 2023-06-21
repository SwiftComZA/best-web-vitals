module UI.Styled exposing (..)

import Element
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import Html.Events
import UI.Styles as Styles
import Utils.List exposing (with)



-- Some prebuilt components.
-- If you want to add extra styles to a component, use the -With function


text t =
    textWith [] t


textWith styles t =
    Element.el styles <| Element.text t


wrappedText t =
    wrappedTextWith [] t


wrappedTextWith styles t =
    Element.paragraph styles [ Element.text t ]


submitButton args =
    submitButtonWith [] args


submitButtonWith styles { label, onPress, disabled } =
    if disabled then
        Input.button
            (styles
                |> with
                    [ Font.color Styles.color.lightGrey
                    , Element.mouseOver []
                    , Element.htmlAttribute <| Html.Attributes.style "cursor" "default"
                    ]
            )
            { label = label
            , onPress = Nothing
            }

    else
        Input.button styles
            { label = label
            , onPress = onPress
            }


dropdown args =
    dropdownWith [] args


dropdownWith styles { label, onChange } options =
    Element.el ([ Element.width Element.fill ] |> with styles) <|
        Element.html <|
            Html.select
                [ Html.Events.onInput onChange
                , Html.Attributes.style "width" "100%"
                , Html.Attributes.style "height" "100%"
                , Html.Attributes.style "font" "inherit"
                , Html.Attributes.style "padding" "10px"
                , Html.Attributes.style "cursor" "pointer"
                , Html.Attributes.style "border" "none"
                ]
                (Html.option [ Html.Attributes.disabled True, Html.Attributes.selected True ] [ Html.text label ]
                    :: (options
                            |> List.map
                                (\option ->
                                    Html.option
                                        [ Html.Attributes.value option ]
                                        [ Html.text option ]
                                )
                       )
                )


message : Maybe ( String, Bool ) -> Element.Element msg
message maybeMessage =
    case maybeMessage of
        Just ( content, isError ) ->
            textWith
                [ Element.centerX
                , Font.color <|
                    if isError then
                        Styles.color.red

                    else
                        Styles.color.green
                ]
                content

        Nothing ->
            Element.el [ Element.height <| Element.px 20 ] Element.none


svg url width height =
    Element.html <|
        Html.node "svg"
            [ Html.Attributes.attribute "xmlns" url
            , Html.Attributes.width width
            , Html.Attributes.height height
            ]
            []
