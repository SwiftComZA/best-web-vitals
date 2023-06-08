module Pages.AddSite exposing (Model, Msg, page)

import Api.Site
import Bridge exposing (..)
import Effect exposing (Effect)
import Element exposing (centerX, fill, paddingXY, spacing, width)
import Element.Input as Input
import Gen.Params.AddSite exposing (Params)
import Html.Events
import Json.Decode as Decode
import Page
import Request
import Shared
import UI.Styled as Styled
import UI.Styles as Styles
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { site : String
    , category : Maybe Api.Site.Category
    , frontendLang : Maybe Api.Site.FrontendLang
    }


init : ( Model, Effect Msg )
init =
    ( { site = ""
      , category = Nothing
      , frontendLang = Nothing
      }
    , Effect.batch
        [ Effect.fromCmd <| sendToBackend <| FetchCategories
        , Effect.fromCmd <| sendToBackend <| FetchFrontendLangs
        ]
    )



-- UPDATE


type Msg
    = Updated Field String
    | SubmitSite


type Field
    = Site
    | Category
    | FrontendLang


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        Updated Site site ->
            ( { model | site = site }
            , Effect.none
            )

        Updated Category category ->
            ( { model | category = Just category }
            , Effect.none
            )

        Updated FrontendLang frontendLang ->
            ( { model | frontendLang = Just frontendLang }
            , Effect.none
            )

        SubmitSite ->
            let
                validSite =
                    case model.site |> String.split "://" of
                        [ "http", _ ] ->
                            model.site

                        [ "https", _ ] ->
                            model.site

                        _ ->
                            "https://" ++ model.site
            in
            case ( model.category, model.frontendLang ) of
                ( Just category, Just frontendLang ) ->
                    ( { model | site = "", category = Nothing, frontendLang = Nothing }
                    , Effect.fromCmd <| sendToBackend <| RequestSiteStats validSite category frontendLang
                    )

                _ ->
                    ( model, Effect.none )



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


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Add Site"
    , body =
        [ Element.layout [ width fill, paddingXY 50 100 ] <|
            Element.column [ centerX ]
                [ Element.column [ spacing 20 ]
                    [ Input.text
                        Styles.inputStyle
                        { onChange = Updated Site
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Website"
                        , text = model.site
                        , label = Input.labelHidden ""
                        }
                    , Styled.dropdownWith Styles.dropdownStyle
                        { label = "Category"
                        , onChange = Updated Category
                        }
                        shared.categories
                    , Styled.dropdownWith Styles.dropdownStyle
                        { label = "Frontend Language"
                        , onChange = Updated FrontendLang
                        }
                        shared.frontendLangs
                    , Styled.submitButtonWith Styles.buttonStyle
                        { label = Element.text "Add Site"
                        , onPress = Just SubmitSite
                        , disabled = model.category == Nothing || model.frontendLang == Nothing
                        }
                    ]
                ]
        ]
    }
