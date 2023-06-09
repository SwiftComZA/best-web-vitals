module Utils.Maybe exposing (boolToBool, splitTuple, toBool, tupleWithDefault, view)

import Element exposing (Element, none)


view : Maybe value -> (value -> Element msg) -> Element msg
view maybe toView =
    case maybe of
        Just value ->
            toView value

        Nothing ->
            none


toBool : Maybe a -> Bool
toBool maybeValue =
    case maybeValue of
        Just _ ->
            True

        Nothing ->
            False


boolToBool : Maybe Bool -> Bool
boolToBool maybeBool =
    case maybeBool of
        Just bool ->
            bool

        Nothing ->
            False


splitTuple : Maybe ( a, b ) -> ( Maybe a, Maybe b )
splitTuple maybeTuple =
    case maybeTuple of
        Just ( a, b ) ->
            ( Just a, Just b )

        Nothing ->
            ( Nothing, Nothing )


tupleWithDefault : ( a, b ) -> ( Maybe a, Maybe b ) -> ( a, b )
tupleWithDefault ( a, b ) ( maybeA, maybeB ) =
    case ( maybeA, maybeB ) of
        ( Nothing, Nothing ) ->
            ( a, b )

        ( Nothing, Just justB ) ->
            ( a, justB )

        ( Just justA, Nothing ) ->
            ( justA, b )

        ( Just justA, Just justB ) ->
            ( justA, justB )
