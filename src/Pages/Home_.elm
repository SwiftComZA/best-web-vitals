module Pages.Home_ exposing (Model, Msg(..), page)

import Api.Site as Site exposing (Platform(..), Score(..), ScoreType(..), Site, Sort(..), extractDomain)
import Dict
import Effect exposing (Effect)
import Element exposing (alignRight, alignTop, centerX, centerY, column, el, fill, fillPortion, height, html, htmlAttribute, indexedTable, layout, maximum, newTabLink, none, padding, paddingEach, paddingXY, pointer, px, rgb, rgba, row, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Html exposing (div)
import Html.Attributes exposing (style)
import Page
import Request exposing (Request)
import Shared
import String exposing (fromInt)
import UI.Styled as Styled
import UI.Styles as Styles exposing (noPadding)
import Utils.Element.Extra exposing (absolute, attIf, hidden, left, overflow, position, relative, top, transition, zIndex)
import Utils.If exposing (viewIf)
import Vectors.DesktopIcon exposing (desktopIcon)
import Vectors.FeatherArrow exposing (featherArrow)
import Vectors.MobileIcon exposing (mobileIcon)
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.advanced
        { init = init
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { searchTerm : String
    , platform : Platform
    , expandedSite : Maybe String
    }


init : ( Model, Effect Msg )
init =
    ( { searchTerm = "", platform = Mobile, expandedSite = Nothing }
    , Effect.none
    )



-- UPDATE


type Msg
    = ClickedChangeSort Sort
    | UpdatedSearchTerm String
    | ClickedPlatform Platform
    | ClickedExpandSite String
    | NoOp


update : Shared.Model -> Msg -> Model -> ( Model, Effect Msg )
update shared msg model =
    case msg of
        ClickedChangeSort sort ->
            ( model, Effect.fromShared <| Shared.ChangedSort sort )

        UpdatedSearchTerm term ->
            ( { model | searchTerm = term }, Effect.none )

        ClickedPlatform platform ->
            let
                changeSort =
                    case shared.sort of
                        ( MobileScore score, _ ) ->
                            case platform of
                                Mobile ->
                                    Effect.none

                                Desktop ->
                                    Effect.fromShared <| Shared.ChangedSort <| DesktopScore score

                        ( DesktopScore score, _ ) ->
                            case platform of
                                Mobile ->
                                    Effect.fromShared <| Shared.ChangedSort <| MobileScore score

                                Desktop ->
                                    Effect.none

                        _ ->
                            Effect.none
            in
            ( { model | platform = platform }, changeSort )

        ClickedExpandSite site ->
            let
                newExpandedSite =
                    case model.expandedSite of
                        Just currentExpanded ->
                            if currentExpanded == site then
                                Nothing

                            else
                                Just site

                        Nothing ->
                            Just site
            in
            ( { model | expandedSite = newExpandedSite }, Effect.none )

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
        [ layout [ width fill, paddingXY 20 0 ] <|
            column [ width fill ]
                [ Styled.wrappedTextWith
                    [ centerX
                    , Font.bold
                    , Font.center
                    , paddingXY 0 50
                    ]
                    "A Web Vitals Leaderboard"
                , Input.text
                    (Styles.inputStyle ++ [ width <| maximum 400 fill, centerX ])
                    { onChange = UpdatedSearchTerm
                    , placeholder = Just <| Input.placeholder [] <| Element.text "Search"
                    , text = model.searchTerm
                    , label = Input.labelHidden ""
                    }
                , column [ width <| maximum 1440 fill, centerX ]
                    [ row [ alignRight, padding 20 ]
                        [ el
                            [ height <| px 60
                            , width <| px 40
                            , pointer
                            , onClick <| ClickedPlatform Mobile
                            , Border.widthEach { top = 0, bottom = 3, left = 0, right = 0 }
                            , Border.solid
                            , transition "all 0.3s ease-out"
                            , Border.color Styles.color.darkBlue |> attIf (model.platform == Mobile)
                            , Border.color Styles.color.grey |> attIf (model.platform == Desktop)
                            ]
                          <|
                            mobileIcon (model.platform == Mobile)
                        , el
                            [ height <| px 60
                            , width <| px 40
                            , pointer
                            , onClick <| ClickedPlatform Desktop
                            , Border.widthEach { top = 0, bottom = 3, left = 0, right = 0 }
                            , Border.solid
                            , transition "all 0.3s ease-out"
                            , Border.color Styles.color.darkBlue |> attIf (model.platform == Desktop)
                            , Border.color Styles.color.grey |> attIf (model.platform == Mobile)
                            ]
                          <|
                            desktopIcon (model.platform == Desktop)
                        ]
                    , siteScoresTable model.platform shared.viewportWidth (model.expandedSite |> Maybe.withDefault "") sites
                    ]
                ]
        ]
    }


siteScoresTable : Platform -> Float -> String -> List Site -> Element.Element Msg
siteScoresTable platform viewportWidth expandedSite siteList =
    let
        columns =
            [ { header = tableHeader [ onClick <| ClickedChangeSort Domain ] <| text "Domain"
              , width = fill
              , view =
                    \index site ->
                        tableCell (expandedSite == site.url)
                            viewportWidth
                            (if expandedSite == site.url then
                                [ Border.innerShadow { offset = ( 20, 0 ), size = -20, blur = 20, color = rgba 0 0 0 0.15 }, transition "box-shadow 0.1s ease-out" ]

                             else
                                []
                            )
                        <|
                            row [ position relative, height fill ]
                                [ newTabLink [ centerY ]
                                    { url = "https://pagespeed.web.dev/analysis?url=" ++ site.url
                                    , label =
                                        html <|
                                            div
                                                [ style "text-overflow" "ellipsis"
                                                , style "line-height" "23px"
                                                , style "width"
                                                    (if viewportWidth > 480 then
                                                        "fit-content"

                                                     else
                                                        "200px"
                                                    )
                                                , style "whitespace" "nowrap"
                                                , style "overflow" "hidden"
                                                ]
                                                [ Html.text <|
                                                    extractDomain site.url
                                                ]
                                    }
                                , el
                                    ([ position absolute
                                     , width <|
                                        px
                                            ((viewportWidth
                                                - (if viewportWidth < 680 then
                                                    60

                                                   else
                                                    80
                                                  )
                                             )
                                                |> floor
                                            )
                                     , left -5
                                     , top 39
                                     , height <|
                                        px
                                            (if viewportWidth > 600 then
                                                72

                                             else
                                                156
                                            )
                                     , htmlAttribute <|
                                        style "max-height"
                                            (if expandedSite == site.url then
                                                if viewportWidth > 600 then
                                                    "72px"

                                                else
                                                    "156px"

                                             else
                                                "0"
                                            )
                                     , transition "max-height 0.1s ease-out, box-shadow 0.1s ease-out"
                                     , overflow hidden
                                     , Background.color <| Styles.color.white
                                     , zIndex 2
                                     ]
                                        ++ (if expandedSite == site.url then
                                                [ Border.innerShadow { offset = ( 0, -20 ), size = 0, blur = 20, color = rgba 0 0 0 0.15 }
                                                , Border.color <| Styles.color.lightGrey
                                                , Border.solid
                                                , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
                                                ]

                                            else
                                                []
                                           )
                                    )
                                  <|
                                    column [ width fill, spacing 20 ]
                                        [ row [ width fill, paddingXY 20 10 ]
                                            [ column [ width shrink ]
                                                [ Styled.textWith [ centerX, Font.bold ] "Category" |> viewIf (viewportWidth > 600)
                                                , Styled.textWith [ centerX ] site.category
                                                ]
                                            , column [ width shrink, alignRight ]
                                                [ Styled.textWith [ centerX, Font.bold ] "Frontend Language" |> viewIf (viewportWidth > 600)
                                                , Styled.textWith [ centerX ] site.frontendLang
                                                ]
                                            ]
                                        , if viewportWidth > 600 then
                                            none

                                          else
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
                                                    tableCell (expandedSite == site.url) viewportWidth [] <| scoreLabel [ width shrink, scoreColor -1 ] <| Styled.textWith [ centerX, centerY ] "Pending"

                                                Failed ->
                                                    tableCell (expandedSite == site.url) viewportWidth [] <| scoreLabel [ width shrink, scoreColor 0 ] <| Styled.textWith [ centerX, centerY, paddingXY 20 0 ] "Failed"

                                                Success score ->
                                                    let
                                                        scoreData =
                                                            [ column [ width fill, spacing 10 ] [ scoreLabel [ scoreColor score.performance ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.performance, Styled.textWith [ centerX ] "perf." ]
                                                            , column [ width fill, spacing 10 ] [ scoreLabel [ scoreColor score.accessibility ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.accessibility, Styled.textWith [ centerX ] "a11y" ]
                                                            , column [ width fill, spacing 10 ] [ scoreLabel [ scoreColor score.bestPractices ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.bestPractices, Styled.textWith [ centerX ] "bp" ]
                                                            , column [ width fill, spacing 10 ] [ scoreLabel [ scoreColor score.seo ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.seo, Styled.textWith [ centerX ] "seo" ]
                                                            ]
                                                    in
                                                    row [ width fill, paddingXY 0 10 ] scoreData
                                        ]
                                ]
              }
            , { header = tableHeader [ onClick <| ClickedChangeSort Category ] <| text "Category"
              , width = fill
              , view = \index site -> tableCell (expandedSite == site.url) viewportWidth [ Font.center ] <| Styled.textWith [ centerY ] site.category
              }
            , { header =
                    tableHeader [ onClick <| ClickedChangeSort FrontendLang ] <|
                        text
                            (if viewportWidth <= 1280 then
                                "Frontend Lang."

                             else
                                "Frontend Language"
                            )
              , width = fill
              , view = \index site -> tableCell (expandedSite == site.url) viewportWidth [ Font.center ] <| Styled.textWith [ centerY ] site.frontendLang
              }
            ]
    in
    indexedTable
        [ centerX
        , Styles.borderShadow
        , padding <|
            if viewportWidth < 680 then
                10

            else
                20
        ]
        { data = siteList
        , columns =
            (if viewportWidth < 680 then
                columns |> List.take 1

             else if viewportWidth <= 768 then
                columns |> List.take 1

             else
                columns
            )
                ++ tableScoreColumns platform viewportWidth expandedSite
                ++ (if viewportWidth > 768 then
                        []

                    else
                        [ { header = tableHeader [] none
                          , width = px 30
                          , view =
                                \index site ->
                                    tableCell (expandedSite == site.url)
                                        viewportWidth
                                        (if expandedSite == site.url then
                                            [ Border.innerShadow { offset = ( -20, 0 ), size = -20, blur = 20, color = rgba 0 0 0 0.15 }, transition "box-shadow 0.1s ease-out" ]

                                         else
                                            []
                                        )
                                    <|
                                        el [ centerY, onClick <| ClickedExpandSite site.url ] <|
                                            featherArrow (expandedSite == site.url)
                          }
                        ]
                   )
        }


tableScoreColumns : Platform -> Float -> String -> List (Element.IndexedColumn Site Msg)
tableScoreColumns platform viewportWidth expandedSite =
    let
        scoreHeadings =
            [ el
                [ width <| fillPortion 1
                , Font.center
                , pointer
                , onClick <| ClickedChangeSort (MobileScore Perf)
                , paddingEach { noPadding | bottom = 10 }
                ]
              <|
                text
                    (if viewportWidth < 600 then
                        ""

                     else if viewportWidth <= 1280 then
                        "Perf."

                     else
                        "Performance"
                    )
            , el
                [ width <| fillPortion 1
                , Font.center
                , pointer
                , onClick <| ClickedChangeSort (MobileScore A11y)
                , paddingEach { noPadding | bottom = 10 }
                ]
              <|
                text
                    (if viewportWidth <= 1280 then
                        "A11Y"

                     else
                        "Accessibility"
                    )
            , el
                [ width <| fillPortion 1
                , Font.center
                , pointer
                , onClick <| ClickedChangeSort (MobileScore BP)
                , paddingEach { noPadding | bottom = 10 }
                ]
              <|
                text
                    (if viewportWidth <= 1280 then
                        "BP"

                     else
                        "Best Practices"
                    )
            , el
                [ width <| fillPortion 1
                , Font.center
                , pointer
                , onClick <| ClickedChangeSort (MobileScore SEO)
                , paddingEach { noPadding | bottom = 10 }
                , alignTop
                ]
              <|
                text "SEO"
            ]
    in
    [ { header =
            tableHeader [] <|
                row [ width fill ]
                    (if viewportWidth < 600 then
                        scoreHeadings |> List.take 1

                     else
                        scoreHeadings
                    )
      , width =
            maximum
                (if viewportWidth <= 1280 then
                    550

                 else
                    600
                )
                fill
      , view =
            \index site ->
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
                        tableCell (expandedSite == site.url) viewportWidth [] <| scoreLabel [ width shrink, scoreColor -1 ] <| Styled.textWith [ centerX, centerY ] "Pending"

                    Failed ->
                        tableCell (expandedSite == site.url) viewportWidth [] <| scoreLabel [ width shrink, scoreColor 0 ] <| Styled.textWith [ centerX, centerY, paddingXY 20 0 ] "Failed"

                    Success score ->
                        let
                            scoreData =
                                [ el [ width fill ] <| scoreLabel [ scoreColor score.performance ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.performance
                                , el [ width fill ] <| scoreLabel [ scoreColor score.accessibility ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.accessibility
                                , el [ width fill ] <| scoreLabel [ scoreColor score.bestPractices ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.bestPractices
                                , el [ width fill ] <| scoreLabel [ scoreColor score.seo ] <| Styled.textWith [ centerX, centerY ] <| formatScore score.seo
                                ]
                        in
                        tableCell (expandedSite == site.url)
                            viewportWidth
                            []
                        <|
                            row [ width fill, centerY ]
                                (if viewportWidth < 600 then
                                    scoreData |> List.take 1

                                 else
                                    scoreData
                                )
      }
    ]


tableCell : Bool -> Float -> List (Element.Attribute Msg) -> Element.Element Msg -> Element.Element Msg
tableCell expanded viewportWidth atts content =
    el
        [ height <|
            if expanded then
                px
                    (if viewportWidth > 600 then
                        116

                     else
                        200
                    )

            else
                px 44
        , transition "height 0.1s ease-out"
        , Border.color <| Styles.color.lightGrey
        , Border.solid
        , Border.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
        ]
    <|
        el
            ([ padding 5
             , height <| px 44
             , width fill
             ]
                ++ atts
            )
        <|
            content


tableHeader atts content =
    tableCell False
        0
        ([ Font.bold
         , paddingEach { tableCellPadding | bottom = 10 }
         , pointer
         , Border.color <| Styles.color.grey
         , Border.solid
         , Border.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
         ]
            ++ atts
        )
        content


tableCellPadding =
    { top = 5, bottom = 5, left = 5, right = 5 }


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
