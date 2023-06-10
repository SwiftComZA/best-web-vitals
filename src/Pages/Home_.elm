module Pages.Home_ exposing (Model, Msg(..), page)

import Api.Site as Site exposing (Score(..), ScoreType(..), Site, Sort(..), extractDomain)
import Dict
import Effect exposing (Effect)
import Element exposing (centerX, column, el, fill, fillPortion, layout, link, newTabLink, padding, paddingEach, paddingXY, pointer, px, rgb, rgba, row, shrink, spacing, table, text, width)
import Element.Background as Background
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
        [ layout [ width fill, paddingXY 50 50 ] <|
            column [ width fill, spacing 50 ]
                [ Styled.textWith [ centerX, Font.bold ] "A list of sites with Core Web Vitals scores."
                , Input.text
                    (Styles.inputStyle ++ [ width <| px 400, centerX ])
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
              , view = \site -> tableCell [] <| newTabLink [] { url = "https://pagespeed.web.dev/analysis?url=" ++ site.url, label = text <| extractDomain site.url }
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
                        tableCell [] <| shadowEl [ Font.center, width fill, scoreColor <| -1 ] <| text "Pending"

                    Failed ->
                        tableCell [] <| shadowEl [ Font.center, width fill, scoreColor <| 0 ] <| text "Failed"

                    Success score ->
                        tableCell [] <|
                            row [ width fill ]
                                [ shadowEl [ width fill, Font.center, scoreColor <| score.performance * 100 ] <| text <| fromInt <| round <| score.performance * 100
                                , shadowEl [ width fill, Font.center, scoreColor <| score.accessibility * 100 ] <| text <| fromInt <| round <| score.accessibility * 100
                                , shadowEl [ width fill, Font.center, scoreColor <| score.bestPractices * 100 ] <| text <| fromInt <| round <| score.bestPractices * 100
                                , shadowEl [ width fill, Font.center, scoreColor <| score.seo * 100 ] <| text <| fromInt <| round <| score.seo * 100
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
                        tableCell [] <| shadowEl [ Font.center, width fill, scoreColor <| -1 ] <| text "Pending"

                    Failed ->
                        tableCell [] <| shadowEl [ Font.center, width fill, scoreColor <| 0 ] <| text "Failed"

                    Success score ->
                        tableCell [] <|
                            row [ width fill ]
                                [ shadowEl [ width fill, Font.center, scoreColor <| score.performance * 100 ] <| text <| fromInt <| round <| score.performance * 100
                                , shadowEl [ width fill, Font.center, scoreColor <| score.accessibility * 100 ] <| text <| fromInt <| round <| score.accessibility * 100
                                , shadowEl [ width fill, Font.center, scoreColor <| score.bestPractices * 100 ] <| text <| fromInt <| round <| score.bestPractices * 100
                                , shadowEl [ width fill, Font.center, scoreColor <| score.seo * 100 ] <| text <| fromInt <| round <| score.seo * 100
                                ]
      }
    ]


tableCell : List (Element.Attribute Msg) -> Element.Element Msg -> Element.Element Msg
tableCell atts content =
    el (atts ++ [ padding 10 ]) <| content


scoreColor : Float -> Element.Attribute msg
scoreColor score =
    Background.color <|
        if score >= 75 then
            rgb 0 1 0

        else if score >= 50 then
            rgb 1 1 0

        else if score >= 25 then
            rgb 1 0.5 0

        else if score >= 0 then
            rgb 1 0.3 0.3

        else
            rgb 0.5 0.8 1


shadowEl styles =
    el
        ([ Border.innerShadow { offset = ( 0, 0 ), size = 0, blur = 10, color = Element.rgba 0 0 0 0.5 }
         ]
            ++ styles
        )
