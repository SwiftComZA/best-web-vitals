module Pages.Admin exposing (Model, Msg(..), page)

import Api.Site exposing (Score(..), Site)
import Bridge exposing (ToBackend(..))
import Dict
import Element
    exposing
        ( centerX
        , el
        , fill
        , fillPortion
        , layout
        , mouseOver
        , padding
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
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.element
        { init = init shared
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    ()


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( ()
    , Cmd.none
    )



-- UPDATE


type Msg
    = DeleteSite String


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        DeleteSite siteUrl ->
            ( model, sendToBackend <| Bridge.DeleteSite siteUrl )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    let
        siteList =
            shared.siteList |> Dict.values
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
            [ { header = tableCell [ Font.bold ] <| text "Domain"
              , width = fillPortion 2
              , view = \site -> tableCell [] <| text site.url
              }
            , { header = tableCell [ Font.center, Font.bold ] <| text "Category"
              , width = fillPortion 2
              , view = \site -> tableCell [ Font.center ] <| text "..."
              }
            , { header = tableCell [ Font.center, Font.bold ] <| text "Frontend Language"
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


tableScoreColumns : List (Element.Column Site msg)
tableScoreColumns =
    [ { header = tableCell [ Font.center, Font.bold ] <| text "Mobile Score"
      , width = fillPortion 4
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
    , { header = tableCell [ Font.center, Font.bold ] <| text "Desktop Score"
      , width = fillPortion 4
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
