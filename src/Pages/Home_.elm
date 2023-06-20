module Pages.Home_ exposing (Model, Msg(..), page)

import Api.Site as Site exposing (Platform(..), Score(..), ScoreType(..), Site, Sort(..), extractDomain)
import Dict
import Effect exposing (Effect)
import Element exposing (alignRight, centerX, centerY, column, el, fill, height, html, layout, maximum, newTabLink, padding, paddingEach, paddingXY, pointer, px, rgb, row, shrink, spacing, table, text, width)
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
import Vectors.DesktopIcon exposing (desktopIcon)
import Vectors.MobileIcon exposing (mobileIcon)
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
    , platform : Platform
    }


init : ( Model, Effect Msg )
init =
    ( { searchTerm = "", platform = Mobile }
    , Effect.none
    )



-- UPDATE


type Msg
    = ClickedChangeSort Sort
    | UpdatedSearchTerm String
    | ClickedPlatform Platform
    | NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedChangeSort sort ->
            ( model, Effect.fromShared <| Shared.ChangedSort sort )

        UpdatedSearchTerm term ->
            ( { model | searchTerm = term }, Effect.none )

        ClickedPlatform platform ->
            ( { model | platform = platform }, Effect.none )

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
    { title = "Best Web Vitals"
    , body =
        [ layout [ width fill, paddingXY 20 50 ] <|
            column [ width fill, spacing 50 ]
                [ Styled.wrappedTextWith
                    [ centerX
                    , Font.bold
                    , Font.center
                    ]
                    "A Web Vitals Leaderboard"
                , Input.text
                    (Styles.inputStyle ++ [ width <| maximum 400 fill, centerX ])
                    { onChange = UpdatedSearchTerm
                    , placeholder = Just <| Input.placeholder [] <| Element.text "Search"
                    , text = model.searchTerm
                    , label = Input.labelHidden ""
                    }
                , column [ width fill ]
                    [ row [ alignRight, padding 20, spacing 10 ]
                        [ el
                            [ height <| px 30
                            , width <| px 30
                            , pointer
                            , onClick <| ClickedPlatform Mobile
                            ]
                          <|
                            html <|
                                mobileIcon (model.platform == Mobile)
                        , el
                            [ height <| px 30
                            , width <| px 30
                            , pointer
                            , onClick <| ClickedPlatform Desktop
                            ]
                          <|
                            html <|
                                desktopIcon (model.platform == Desktop)
                        ]
                    , siteScoresTable model.platform shared.viewportWidth sites
                    ]
                ]
        ]
    }


siteScoresTable : Platform -> Float -> List Site -> Element.Element Msg
siteScoresTable platform viewportWidth siteList =
    let
        columns =
            [ { header = tableCell [ Font.bold, pointer, onClick <| ClickedChangeSort Domain ] <| text "Domain"
              , width = fill
              , view =
                    \site ->
                        tableCell [] <|
                            newTabLink []
                                { url = "https://pagespeed.web.dev/analysis?url=" ++ site.url
                                , label = text <| extractDomain site.url
                                }
              }
            , { header = tableCell [ Font.center, Font.bold, pointer, onClick <| ClickedChangeSort Category ] <| text "Category"
              , width = fill
              , view = \site -> tableCell [ Font.center ] <| text site.category
              }
            , { header = tableCell [ Font.center, Font.bold, pointer, onClick <| ClickedChangeSort FrontendLang ] <| text "Frontend Language"
              , width = fill
              , view = \site -> tableCell [ Font.center ] <| text site.frontendLang
              }
            ]
    in
    table
        [ centerX
        , Styles.borderShadow
        , paddingEach { noPadding | bottom = 10 }
        ]
        { data = siteList
        , columns =
            (if viewportWidth < 480 then
                columns |> List.take 1

             else if viewportWidth < 720 then
                columns |> List.take 2

             else
                columns
            )
                ++ tableScoreColumns platform viewportWidth
        }


tableScoreColumns : Platform -> Float -> List (Element.Column Site Msg)
tableScoreColumns platform viewportWidth =
    let
        scoreHeadings =
            [ el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (MobileScore Perf) ] <|
                text
                    (if viewportWidth < 860 then
                        "Score"

                     else
                        "Performance"
                    )
            , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (MobileScore A11y) ] <| text "Accessibility"
            , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (MobileScore BP) ] <| text "Best Practices"
            , el [ width fill, Font.center, pointer, onClick <| ClickedChangeSort (MobileScore SEO) ] <| text "SEO"
            ]
    in
    [ { header =
            tableCell [ Font.bold, width fill ] <|
                column [ width fill, centerX, Font.center ]
                    [ row [ width fill ]
                        (if viewportWidth < 860 then
                            scoreHeadings |> List.take 1

                         else if viewportWidth < 1024 then
                            scoreHeadings |> List.take 2

                         else if viewportWidth < 1280 then
                            scoreHeadings |> List.take 3

                         else
                            scoreHeadings
                        )
                    ]
      , width = maximum 600 fill
      , view =
            \site ->
                case
                    (case platform of
                        Mobile ->
                            .mobileScore

                        Desktop ->
                            .desktopScore
                    )
                    <|
                        site
                of
                    Pending ->
                        tableCell [] <| scoreLabel [ width shrink, scoreColor -1 ] <| Styled.textWith [ centerX, centerY ] "Pending"

                    Failed ->
                        tableCell [] <| scoreLabel [ width shrink, scoreColor 0 ] <| Styled.textWith [ centerX, centerY, paddingXY 20 0 ] "Failed"

                    Success score ->
                        let
                            scoreData =
                                [ el [ width fill ] <| scoreLabel [ scoreColor score.performance ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.performance
                                , el [ width fill ] <| scoreLabel [ scoreColor score.accessibility ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.accessibility
                                , el [ width fill ] <| scoreLabel [ scoreColor score.bestPractices ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.bestPractices
                                , el [ width fill ] <| scoreLabel [ scoreColor score.seo ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.seo
                                ]
                        in
                        tableCell [ height <| px 45 ] <|
                            row [ width fill, centerY ]
                                (if viewportWidth < 860 then
                                    scoreData |> List.take 1

                                 else if viewportWidth < 1024 then
                                    scoreData |> List.take 2

                                 else if viewportWidth < 1280 then
                                    scoreData |> List.take 3

                                 else
                                    scoreData
                                )
      }
    ]


tableCell : List (Element.Attribute Msg) -> Element.Element Msg -> Element.Element Msg
tableCell atts content =
    el (atts ++ [ padding 10, centerY ]) <| content


scoreColor : Float -> Element.Attribute msg
scoreColor scoreFloat =
    let
        score =
            scoreFloat * 100
    in
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


scoreLabel styles =
    el
        ([ Border.rounded 17
         , height <| px 34
         , centerX
         , width <| px 34
         , Styles.innerBorderShadow
         , Font.size 15
         , Font.center
         ]
            ++ styles
        )


formatScore score =
    score * 100 |> round |> fromInt
