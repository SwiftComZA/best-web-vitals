module Pages.AddSite exposing (Model, Msg, page)

import Bridge exposing (ToBackend)
import Dict
import Effect exposing (Effect)
import Element exposing (fill, mouseDown, mouseOver, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Gen.Params.AddSite exposing (Params)
import Lamdera
import Page
import Request
import Shared
import Styles exposing (color)
import View exposing (View)
import Html 
import Html.Events
import Json.Decode as Decode

page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { site : String
    , queuedSites : List String
    }


init : ( Model, Effect Msg )
init =
    ( { site = ""
      , queuedSites = []
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = UpdateSite String
    | FetchSite


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        UpdateSite site ->
            ( { model | site = site }
            , Effect.none )

        FetchSite ->
            ( { model | queuedSites = model.site :: model.queuedSites, site = "" } 
            , Effect.fromCmd <| Lamdera.sendToBackend <| Bridge.QueueSiteForRetrieval model.site )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key"
                    )
            )
        )

view : Model -> View Msg
view model =
    { title = "Add Site"
    , body =
        [ Element.layout [] <|
            Element.column []
            [
            Element.row []
                [ Input.text
                    [onEnter FetchSite]
                    { onChange = UpdateSite
                    , placeholder = Just <| Input.placeholder [] <| Element.text "Site"
                    , text = model.site
                    , label = Input.labelHidden ""
                    }
                , Input.button
                    Styles.buttonStyle
                    { label = Element.text "Add Site"
                    , onPress = Just FetchSite
                    }
                ]
                , Element.table []
                    { data = model.queuedSites
                    , columns =
                        [ { header = Element.text "Queued Sites"
                          , width = fill
                          , view = \site -> Element.text site
                          }
                        ]
                    }
                ]
        ]
    }
