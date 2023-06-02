module Pages.Admin exposing (Model, Msg(..), page)

import Bridge
import Dict
import Html exposing (..)
import Html.Attributes exposing (checked, class, classList, type_)
import Html.Events as Events
import Lamdera
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
    = ApproveSite String Bool


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        ApproveSite site bool ->
            ( model, Lamdera.sendToBackend <| Bridge.ApproveSiteToBackend site bool )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = ""
    , body =
        [ table [ class "styled-table" ]
            (tr []
                [ th [] [ text "Domain" ]
                , th [] [ text "Category" ]
                , th [] [ text "Frontend Language" ]
                , th [] [ text "Mobile Score" ]
                , th [] [ text "Desktop Score" ]
                , th [] [ text "Approve" ]
                ]
                :: (shared.siteList
                        |> Dict.toList
                        |> List.map
                            (\( k, v ) ->
                                tr []
                                    [ td [] [ text v.domain ]
                                    , td [] [ text v.category ]
                                    , td [] [ text v.frontendLang ]
                                    , td [] [ text <| fromInt <| v.mobileScore ]
                                    , td [] [ text <| fromInt <| v.desktopScore ]
                                    , td []
                                        [ input
                                            [ type_ "checkbox"
                                            , checked v.approved
                                            , Events.onCheck (ApproveSite k)
                                            ]
                                            []
                                        ]
                                    ]
                            )
                   )
            )
        ]
    }
