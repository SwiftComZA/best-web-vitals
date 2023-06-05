module Pages.Admin exposing (Model, Msg(..), page)

import Bridge exposing (ToBackend(..))
import Dict exposing (Dict)
import Element exposing (fill, layout, paddingXY, width)
import Html exposing (..)
import Page
import Request exposing (Request)
import Shared
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
        [ layout [ width fill, paddingXY 50 20 ] <| siteScoresTable siteList ]
    }
