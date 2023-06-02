module Pages.AddListing exposing (Model, Msg(..), page)

import Bridge
import Dict
import Html exposing (..)
import Html.Attributes exposing (checked, placeholder, type_, value)
import Html.Events as Events
import Lamdera
import Page
import Request exposing (Request)
import Shared
import String exposing (fromInt, toInt)
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
    Bridge.Site


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { domain = ""
      , category = ""
      , frontendLang = ""
      , approved = False
      , mobileScore = 0
      , desktopScore = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateDomain String
    | UpdateCategory String
    | UpdateFrontendLang String
    | UpdateMobileScore String
    | UpdateDesktopScore String
    | Submit


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        UpdateDomain domain ->
            ( { model | domain = domain }, Cmd.none )

        UpdateCategory category ->
            ( { model | category = category }, Cmd.none )

        UpdateFrontendLang frontendLang ->
            ( { model | frontendLang = frontendLang }, Cmd.none )

        UpdateMobileScore score ->
            ( { model | mobileScore = score |> toInt |> Maybe.withDefault 0 }, Cmd.none )

        UpdateDesktopScore score ->
            ( { model | desktopScore = score |> toInt |> Maybe.withDefault 0 }, Cmd.none )

        Submit ->
            ( { domain = ""
              , category = ""
              , frontendLang = ""
              , approved = False
              , mobileScore = 0
              , desktopScore = 0
              }
            , Lamdera.sendToBackend <| Bridge.SendSiteToBackend model
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = ""
    , body =
        [ input
            [ value model.domain
            , placeholder "Domain"
            , Events.onInput UpdateDomain
            ]
            []
        , input
            [ value model.category
            , placeholder "Category"
            , Events.onInput UpdateCategory
            ]
            []
        , input
            [ value model.frontendLang
            , placeholder "Frontend Language"
            , Events.onInput UpdateFrontendLang
            ]
            []
        , input
            [ value (model.mobileScore |> fromInt)
            , placeholder "Mobile Score"
            , Events.onInput UpdateMobileScore
            , type_ "number"
            ]
            []
        , input
            [ value (model.desktopScore |> fromInt)
            , placeholder "Desktop Score"
            , Events.onInput UpdateDesktopScore
            , type_ "number"
            ]
            []
        , button [ Events.onClick Submit ] [ text "Submit" ]
        ]
    }
