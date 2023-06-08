module UI.Styled exposing (..)

import Element
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import Html.Events
import UI.Styles



-- Some prebuilt components.
-- If you want to add extra styles to a component, use the -With function


text t =
    textWith [] t


textWith styles t =
    Element.el styles <| Element.text t


submitButton args =
    submitButtonWith [] args


submitButtonWith styles { label, onPress, disabled } =
    if disabled then
        Input.button
            (styles
                ++ [ Font.color UI.Styles.color.lightGrey
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
    Element.el
        ([ Element.width <| Element.fill
         ]
            ++ styles
        )
    <|
        Element.html <|
            Html.select
                [ Html.Events.onInput <| onChange
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
