module UI.Table exposing (..)

import Api.Site exposing (Score(..), Site)
import Element exposing (centerX, column, el, fill, fillPortion, padding, paddingEach, rgba, row, table, text, width)
import Element.Border as Border
import Element.Font as Font
import String exposing (fromInt)
import UI.Styles exposing (noPadding)


siteScoresTable : List Site -> Element.Element msg
siteScoresTable siteList =
    table [ centerX, Border.shadow { offset = ( 0, 0 ), size = 0, blur = 20, color = rgba 0 0 0 0.15 } ]
        { data = siteList
        , columns =
            [ { header = tableCell [ Font.bold ] <| text "Domain"
              , width = fillPortion 1
              , view = \site -> tableCell [] <| text site.url
              }
            , { header = tableCell [ Font.center, Font.bold ] <| text "Category"
              , width = fillPortion 1
              , view = \site -> tableCell [ Font.center ] <| text "..."
              }
            , { header = tableCell [ Font.center, Font.bold ] <| text "Frontend Language"
              , width = fillPortion 1
              , view = \site -> tableCell [ Font.center ] <| text "..."
              }
            ]
                ++ tableScoreColumns
        }


tableScoreColumns : List (Element.Column Site msg)
tableScoreColumns =
    [ { header =
            tableCell [ Font.bold, width fill ] <|
                column [ width fill, centerX, Font.center ]
                    [ el [ centerX ] <| text "Mobile Score"
                    , row [ width fill, paddingEach { noPadding | top = 10 } ]
                        [ el [ width fill ] <| text "perf"
                        , el [ width fill ] <| text "a11y"
                        , el [ width fill ] <| text "bp"
                        , el [ width fill ] <| text "seo"
                        ]
                    ]
      , width = fillPortion 2
      , view =
            \site ->
                case site.mobileScore of
                    Pending ->
                        tableCell [ Font.center ] <| text "Pending"

                    Failed ->
                        tableCell [ Font.center ] <| text "Failed"

                    Success score ->
                        tableCell [] <|
                            row [ width fill ]
                                [ el [ width fill, Font.center ] <| text <| fromInt <| round <| score.performance * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.accessibility * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.bestPractices * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.seo * 100
                                ]
      }
    , { header =
            tableCell [ Font.bold, width fill ] <|
                column [ width fill, centerX, Font.center ]
                    [ el [ centerX ] <| text "Desktop Score"
                    , row [ width fill, paddingEach { noPadding | top = 10 } ]
                        [ el [ width fill ] <| text "perf"
                        , el [ width fill ] <| text "a11y"
                        , el [ width fill ] <| text "bp"
                        , el [ width fill ] <| text "seo"
                        ]
                    ]
      , width = fillPortion 2
      , view =
            \site ->
                case site.desktopScore of
                    Pending ->
                        tableCell [ Font.center ] <| text "Pending"

                    Failed ->
                        tableCell [ Font.center ] <| text "Failed"

                    Success score ->
                        tableCell [] <|
                            row [ width fill ]
                                [ el [ width fill, Font.center ] <| text <| fromInt <| round <| score.performance * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.accessibility * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.bestPractices * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.seo * 100
                                ]
      }
    ]


tableCell : List (Element.Attribute msg) -> Element.Element msg -> Element.Element msg
tableCell atts content =
    el (atts ++ [ padding 10 ]) <| content
