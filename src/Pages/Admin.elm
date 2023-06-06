module Pages.Admin exposing (Model, Msg(..), page)

import Api.Site as Site exposing (Score(..), ScoreType(..), Site, Sort(..))
import Bridge exposing (ToBackend(..))
import Dict
import Effect exposing (Effect)
import Element
    exposing
        ( centerX
        , column
        , el
        , fill
        , fillPortion
        , layout
        , mouseOver
        , padding
        , paddingEach
        , paddingXY
        , pointer
        , rgb
        , rgba
        , row
        , table
        , text
        , width
        )
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Lamdera exposing (sendToBackend)
import Page
import Request exposing (Request)
import Shared
import String exposing (fromInt)
import Styles exposing (noPadding)
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init shared
        , update = update req
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    ()


init : Shared.Model -> ( Model, Effect Msg )
init shared =
    ( ()
    , Effect.none
    )



-- UPDATE


type Msg
    = DeleteSite String
    | ChangeSort Sort


update : Request -> Msg -> Model -> ( Model, Effect Msg )
update req msg model =
    case msg of
        DeleteSite siteUrl ->
            ( model, Effect.fromCmd <| sendToBackend <| Bridge.DeleteSite siteUrl )

        ChangeSort sort ->
            ( model, Effect.fromShared <| Shared.ChangeSort sort )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    let
        siteList =
            shared.siteList |> Dict.values |> Site.sort shared.sort
    in
    { title = ""
    , body =
        [ layout [ width fill, paddingXY 50 20 ] <| siteScoresTable siteList ]
    }


siteScoresTable : List Site -> Element.Element Msg
siteScoresTable siteList =
    table [ centerX, Border.shadow { offset = ( 0, 0 ), size = 0, blur = 20, color = rgba 0 0 0 0.15 } ]
        { data = siteList
        , columns =
            [ { header = tableCell [ Font.bold, pointer, onClick <| ChangeSort Domain ] <| text "Domain"
              , width = fillPortion 2
              , view = \site -> tableCell [] <| text site.url
              }
            , { header = tableCell [ Font.center, Font.bold, pointer, onClick <| ChangeSort Category ] <| text "Category"
              , width = fillPortion 2
              , view = \site -> tableCell [ Font.center ] <| text "..."
              }
            , { header = tableCell [ Font.center, Font.bold, pointer, onClick <| ChangeSort FrontendLang ] <| text "Frontend Language"
              , width = fillPortion 2
              , view = \site -> tableCell [ Font.center ] <| text "..."
              }
            ]
                ++ tableScoreColumns
                ++ [ { header = tableCell [ Font.center, Font.bold ] <| text ""
                     , width = fillPortion 1
                     , view =
                        \site ->
                            tableCell
                                [ Font.center
                                ]
                            <|
                                el
                                    [ pointer
                                    , mouseOver [ Font.color <| rgb 1 0 0 ]
                                    , centerX
                                    , onClick <| DeleteSite site.url
                                    ]
                                <|
                                    text "✘"
                     }
                   ]
        }


tableScoreColumns : List (Element.Column Site Msg)
tableScoreColumns =
    [ { header =
            tableCell [ Font.bold, width fill ] <|
                column [ width fill, centerX, Font.center ]
                    [ el [ centerX ] <| text "Mobile Score"
                    , row [ width fill, paddingEach { noPadding | top = 10 } ]
                        [ el [ width fill, pointer, onClick <| ChangeSort (MobileScore Perf) ] <| text "perf"
                        , el [ width fill, pointer, onClick <| ChangeSort (MobileScore A11y) ] <| text "a11y"
                        , el [ width fill, pointer, onClick <| ChangeSort (MobileScore BP) ] <| text "bp"
                        , el [ width fill, pointer, onClick <| ChangeSort (MobileScore SEO) ] <| text "seo"
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
                        [ el [ width fill, pointer, onClick <| ChangeSort (DesktopScore Perf) ] <| text "perf"
                        , el [ width fill, pointer, onClick <| ChangeSort (DesktopScore A11y) ] <| text "a11y"
                        , el [ width fill, pointer, onClick <| ChangeSort (DesktopScore BP) ] <| text "bp"
                        , el [ width fill, pointer, onClick <| ChangeSort (DesktopScore SEO) ] <| text "seo"
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
