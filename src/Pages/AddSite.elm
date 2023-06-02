module Pages.AddSite exposing (Model, Msg, page)

import Lamdera
import Effect exposing (Effect)
import Element
import Element.Input as Input
import Gen.Params.AddSite exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Bridge exposing (ToBackend)


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
    }


init : ( Model, Effect Msg )
init =
    ( { site = "" }
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
            ( { model | site = site }, Effect.fromCmd <| Lamdera.sendToBackend <| Bridge.QueueSiteForRetrieval site)

        FetchSite ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Add Site"
    , body =
        [ Element.column []
            [ Input.text
                []
                { onChange = UpdateSite
                , placeholder = Just <| Input.placeholder [] <| Element.text "Site"
                , text = model.site
                , label = Input.labelHidden ""
                }
            , Input.button
                []
                { label = Element.text "Add Site"
                , onPress = Just FetchSite
                }
            ]
            |> Element.layout []
        ]
    }
