module Pages.Home_ exposing (Model, Msg(..), page)

import Api.Site as Site exposing (Score(..), ScoreType(..), Site, Sort(..))
import Dict
import Effect exposing (Effect)
import Element exposing (centerX, column, el, fill, fillPortion, layout, padding, paddingEach, paddingXY, pointer, rgba, row, spacing, table, text, width)
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Page
import Request exposing (Request)
import Shared
import String exposing (fromInt)
import UI.Styled as Styled
import UI.Styles as Styles exposing (noPadding)
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.advanced
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { searchTerm : String
    }


init : ( Model, Effect Msg )
init =
    ( { searchTerm = "" }
    , Effect.none
    )



-- UPDATE


type Msg
    = ClickedChangeSort Sort
    | UpdatedSearchTerm String
    | NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedChangeSort sort ->
            ( model, Effect.fromShared <| Shared.ChangedSort sort )

        UpdatedSearchTerm term ->
            ( { model | searchTerm = term }, Effect.none )

        NoOp ->
            ( model, Effect.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    let
        sites =
            shared.sites
                |> Dict.values
                |> Site.sort shared.sort
                |> List.filter (\site -> site.url |> String.contains model.searchTerm)
    in
    { title = ""
    , body =
        [ layout [ width fill, paddingXY 50 20 ] <|
            column [ width fill, spacing 50 ]
                [ Styled.textWith [ centerX ] "A list of sites with Core Web Vitals scores."
                , Input.text
                    Styles.inputStyle
                    { onChange = UpdatedSearchTerm
                    , placeholder = Just <| Input.placeholder [] <| Element.text "Search"
                    , text = model.searchTerm
                    , label = Input.labelHidden ""
                    }
                , siteScoresTable sites
                ]
        ]
    }


siteScoresTable : List Site -> Element.Element Msg
siteScoresTable siteList =
    table [ centerX, Border.shadow { offset = ( 0, 0 ), size = 0, blur = 20, color = rgba 0 0 0 0.15 } ]
        { data = siteList
        , columns =
            [ { header = tableCell [ Font.bold, pointer, onClick <| ClickedChangeSort Domain ] <| text "Domain"
              , width = fillPortion 1
              , view = \site -> tableCell [] <| text site.url
              }
            , { header = tableCell [ Font.center, Font.bold, pointer, onClick <| ClickedChangeSort Category ] <| text "Category"
              , width = fillPortion 1
              , view = \site -> tableCell [ Font.center ] <| text site.category
              }
            , { header = tableCell [ Font.center, Font.bold, pointer, onClick <| ClickedChangeSort FrontendLang ] <| text "Frontend Language"
              , width = fillPortion 1
              , view = \site -> tableCell [ Font.center ] <| text site.frontendLang
              }
            ]
                ++ tableScoreColumns
        }


tableScoreColumns : List (Element.Column Site Msg)
tableScoreColumns =
    [ { header =
            tableCell [ Font.bold, width fill ] <|
                column [ width fill, centerX, Font.center ]
                    [ el [ centerX, pointer, onClick <| ClickedChangeSort (MobileScore Perf) ] <| text "Mobile Score"
                    , row [ width fill, paddingEach { noPadding | top = 10 } ]
                        [ el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (MobileScore Perf) ] <| text "perf"
                        , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (MobileScore A11y) ] <| text "a11y"
                        , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (MobileScore BP) ] <| text "bp"
                        , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (MobileScore SEO) ] <| text "seo"
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
                    [ el [ centerX, pointer, onClick <| ClickedChangeSort (DesktopScore Perf) ] <| text "Desktop Score"
                    , row [ width fill, paddingEach { noPadding | top = 10 } ]
                        [ el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (DesktopScore Perf) ] <| text "perf"
                        , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (DesktopScore A11y) ] <| text "a11y"
                        , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (DesktopScore BP) ] <| text "bp"
                        , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (DesktopScore SEO) ] <| text "seo"
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


tableCell : List (Element.Attribute Msg) -> Element.Element Msg -> Element.Element Msg
tableCell atts content =
    el (atts ++ [ padding 10 ]) <| content
