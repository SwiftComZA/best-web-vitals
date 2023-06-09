module Shared exposing (Flags, Model, Msg(..), init, subscriptions, update, view)

import Api.Site exposing (Category, Direction(..), FrontendLang, ScoreType(..), Site, Sort(..))
import Api.User exposing (User)
import Bridge exposing (ToBackend(..), sendToBackend)
import Dict exposing (Dict)
import Element exposing (alignLeft, alignRight, centerX, centerY, el, fill, height, layout, link, mouseOver, paddingEach, pointer, px, rgb255, rgba, row, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Html exposing (..)
import Html.Attributes exposing (class, href, id, rel, src, style, type_)
import Request exposing (Request)
import UI.Styled as Styled
import UI.Styles exposing (footerStyle, noPadding)
import Utils.If exposing (viewIf)
import Utils.Maybe as Maybe
import View exposing (View)



-- INIT


type alias Flags =
    ()


type alias Model =
    { user : Maybe User
    , sites : Dict String Site
    , sort : ( Sort, Direction )
    , categories : List Category
    , frontendLangs : List FrontendLang
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( Model
        Nothing
        Dict.empty
        ( MobileScore Perf, Desc )
        []
        []
    , Cmd.none
    )



-- UPDATE


type Msg
    = SignedInUser User
    | SignedOutUser
    | ChangedSort Sort
    | GotSites (Dict String Site)
    | GotCategories (List Category)
    | GotFrontendLangs (List FrontendLang)
    | ClickedSignOut


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        SignedInUser user ->
            ( { model | user = Just user }, Cmd.none )

        SignedOutUser ->
            ( { model | user = Nothing }, Cmd.none )

        ChangedSort sort ->
            let
                ( currentSort, currentDir ) =
                    model.sort

                sort_ =
                    if currentSort == sort then
                        if currentDir == Asc then
                            ( sort, Desc )

                        else
                            ( sort, Asc )

                    else if sort == Domain then
                        ( sort, Asc )

                    else
                        ( sort, Desc )
            in
            ( { model | sort = sort_ }, Cmd.none )

        GotSites sites ->
            ( { model | sites = sites }
            , Cmd.none
            )

        GotCategories categories ->
            ( { model | categories = categories }, Cmd.none )

        GotFrontendLangs frontendLangs ->
            ( { model | frontendLangs = frontendLangs }, Cmd.none )

        ClickedSignOut ->
            ( { model | user = Nothing }, sendToBackend <| AttemptSignOut )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none



-- VIEW


view :
    Request
    -> { page : View msg, toMsg : Msg -> msg }
    -> Model
    -> View msg
view _ { page, toMsg } model =
    { title =
        page.title
    , body =
        css
            ++ [ div [ class "layout" ]
                    [ navbar (Maybe.toBool <| model.user)
                        (model.user
                            |> Maybe.map (\u -> u.isAdmin)
                            |> Maybe.boolToBool
                        )
                        toMsg
                    , div [ class "page", style "height" "calc(100vh - 125px)" ] page.body
                    , div footerStyle
                        [ div []
                            [ Html.text "Contact: "
                            , a
                                [ href "mailto:chris@swiftcom.app"
                                , style "text-decoration" "none"
                                ]
                                [ text "SwiftCom" ]
                            ]
                        , div [] [ Html.text "Built with ♥ and Elm" ]
                        ]

                    -- , footer
                    ]
               ]
    }



-- NAVBAR


navbar : Bool -> Bool -> (Msg -> msg) -> Html msg
navbar userIsSignedIn userIsAdmin toMsg =
    layout [ width fill ] <|
        row
            [ width fill
            , height <| px 75
            , Border.shadow
                { offset = ( 0, 0 )
                , size = 0
                , blur = 20
                , color = rgba 0 0 0 0.15
                }
            ]
            ([ navbarLinkItem [ alignLeft ] { url = "/", label = "Home" }
             , navbarLinkItem [ alignLeft ] { url = "/admin", label = "Admin" } |> viewIf userIsAdmin
             , navbarLinkItem [ alignLeft ] { url = "/add-site", label = "Add Site" }
             ]
                ++ (if userIsSignedIn then
                        [ el
                            [ width <| px 100
                            , alignRight
                            , height fill
                            , mouseOver [ Background.color <| rgb255 173 216 230 ]
                            , pointer
                            , onClick <| toMsg ClickedSignOut
                            ]
                          <|
                            Styled.textWith [ centerY, centerX ] "Sign Out"
                        ]

                    else
                        [ navbarLinkItem [ alignRight ] { url = "/login", label = "Login" }
                        , navbarLinkItem [ alignRight ] { url = "/register", label = "Register" }
                        ]
                   )
            )


navbarLinkItem styles { url, label } =
    link
        ([ height fill
         , mouseOver [ Background.color <| rgb255 173 216 230 ]
         ]
            ++ styles
        )
        { url = url
        , label =
            el
                [ centerY
                , width <| px 100
                , Font.center
                ]
            <|
                Element.text label
        }


css =
    [ Html.node "link" [ rel "stylesheet", href "/style.css" ] [] ]
