module Pages.Home_ exposing (Model, Msg(..), page)

import Api.Site exposing (Score(..), Site)
import Dict
import Element exposing (centerX, column, el, fill, fillPortion, layout, padding, paddingXY, rgb, rgba, row, shrink, spacing, table, text, width)
import Element.Border as Border
import Element.Font as Font exposing (Font)
import Html.Attributes exposing (class)
import Page
import Request exposing (Request)
import Shared
import String exposing (fromFloat, fromInt)
import UI.Table exposing (siteScoresTable)
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
    = NoOp


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


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
        [ layout [ width fill, paddingXY 50 20 ] <|
            column [ width fill, spacing 50 ]
                [ el [ centerX ] <| text "A list of sites with Core Web Vitals scores."
                , siteScoresTable siteList
                ]
        ]
    }
