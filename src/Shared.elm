port module Shared exposing (Flags, Model, Msg(..), init, subscriptions, update, view)

import Api.Site exposing (Category, Direction(..), FrontendLang, ScoreType(..), Site, Sort(..))
import Api.User exposing (User)
import Bridge exposing (ToBackend(..), sendToBackend)
import Browser.Dom exposing (Viewport, getViewport)
import Dict exposing (Dict)
import Element exposing (alignLeft, alignRight, centerX, centerY, column, el, fill, height, html, htmlAttribute, image, layout, link, maximum, minimum, mouseOver, padding, paddingXY, pointer, px, rgb, rgba, row, shrink, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Html exposing (..)
import Html.Attributes exposing (class, href, src, style)
import Html.Events
import Request exposing (Request)
import Task
import UI.Styled as Styled
import UI.Styles as Styles exposing (borderShadow, footerStyle, pageStyles)
import Utils.Element.Extra as Element exposing (..)
import Utils.If exposing (viewIf)
import Utils.List as List
import Utils.Maybe as Maybe
import Utils.String as String
import View exposing (View)


port resize : (() -> msg) -> Sub msg



-- INIT


type alias Flags =
    ()


type alias Model =
    { user : Maybe User
    , sites : Dict String Site
    , sort : ( Sort, Direction )
    , categories : List Category
    , frontendLangs : List FrontendLang
    , viewportWidth : Float
    , menuOpen : Bool
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { user = Nothing
      , sites = Dict.empty
      , sort = ( MobileScore Perf, Desc )
      , categories = []
      , frontendLangs = []
      , viewportWidth = 0
      , menuOpen = False
      }
    , Task.perform GotViewport getViewport
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
    | GotViewport Viewport
    | ResizedViewport ()
    | ClickedMenu
    | CloseMenu


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        ResizedViewport _ ->
            ( model, Task.perform GotViewport getViewport )

        GotViewport viewport ->
            ( { model | viewportWidth = viewport.viewport.width }, Cmd.none )

        SignedInUser user ->
            ( { model | user = Just user }, Cmd.none )

        SignedOutUser ->
            ( { model | user = Nothing, menuOpen = False }, Cmd.none )

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

                    else if sort == Domain || sort == Category || sort == FrontendLang then
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

        ClickedMenu ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )

        CloseMenu ->
            ( { model | menuOpen = False }, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.batch [ resize ResizedViewport ]



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
        [ div [ class "layout" ]
            [ navbarContainer
                [ (if model.viewportWidth > 768 then
                    navbarDesktop

                   else
                    navbarMobile model.menuOpen
                  )
                    (Maybe.toBool <| model.user)
                    (model.user
                        |> Maybe.map (\u -> u.isAdmin)
                        |> Maybe.boolToBool
                    )
                    toMsg
                ]
            , div pageStyles page.body
            , footer model.viewportWidth
            ]
        ]
    }



-- NAVBAR


navbarContainer =
    div
        [ style "position" "sticky"
        , style "top" "0"
        , style "z-index" "1"
        ]


navbarMobile menuOpen userIsSignedIn userIsAdmin toMsg =
    layout [ width fill ] <|
        column
            ([ width fill
             , position relative
             , Background.color Styles.color.white
             ]
                |> List.withIf
                    (not menuOpen)
                    [ borderShadow ]
            )
            [ row [ width fill, height <| px 75 ]
                [ link [ padding 10 ]
                    { url = "/"
                    , label =
                        image [ height <| px 55 ]
                            { src = "/images/logo.jpeg"
                            , description = "Logo"
                            }
                    }
                , el [ alignRight, centerY, padding 24 ] <| burgerMenu menuOpen toMsg
                ]
            , column
                [ height <|
                    maximum
                        (if menuOpen then
                            240

                         else
                            0
                        )
                        fill
                , position absolute
                , overflow hidden
                , top 75
                , htmlAttribute <| style "transition" "max-height 0.1s ease-out"
                , htmlAttribute <| style "min-height" "0"
                , width fill
                , Border.shadow { offset = ( 0, 20 ), size = 0, blur = 20, color = rgba 0 0 0 0.15 }
                , Background.color <| Styles.color.white
                , Border.solid
                , Border.color Styles.color.lightGrey
                , Border.width 1
                ]
                [ navbarMobileLinkItem { url = "/", label = "Leaderboard" }
                , navbarMobileLinkItem { url = "/add-site", label = "Add Site" }
                , navbarMobileLinkItem { url = "/admin", label = "Admin" } |> viewIf userIsAdmin
                , el
                    [ onClick <| toMsg ClickedSignOut
                    , padding 10
                    , height <| px 50
                    ]
                    (Styled.textWith [ centerY, centerX ] "Sign Out")
                    |> viewIf userIsSignedIn
                ]
            ]


burgerMenu open toMsg =
    html <|
        div
            [ class ("burger-menu-container" |> String.withIf open " open")
            , Html.Events.onClick <| toMsg ClickedMenu
            ]
            [ img
                [ src "/vectors/bar.svg"
                , class ("burger-menu-bar top" |> String.withIf open " open")
                ]
                []
            , img
                [ src "/vectors/bar.svg"
                , class ("burger-menu-bar middle" |> String.withIf open " open")
                ]
                []
            , img
                [ src "/vectors/bar.svg"
                , class ("burger-menu-bar bottom" |> String.withIf open " open")
                ]
                []
            ]


navbarDesktop : Bool -> Bool -> (Msg -> msg) -> Html msg
navbarDesktop userIsSignedIn userIsAdmin toMsg =
    layout [ width fill ] <|
        row
            [ width fill
            , height <| px Styles.navbarHeight
            , Styles.borderShadow
            , Background.color <| rgb 1 1 1
            ]
            [ link [ padding 10 ]
                { url = "/"
                , label =
                    image [ height <| px 55 ]
                        { src = "/images/logo.jpeg"
                        , description = "Logo"
                        }
                }
            , navbarDesktopLinkItem [ alignRight ] { url = "/", label = "Leaderboard" }
            , navbarDesktopLinkItem [ alignRight ] { url = "/admin", label = "Admin" } |> viewIf userIsAdmin
            , navbarDesktopLinkItem [ alignRight ] { url = "/add-site", label = "Add Site" }
            , el
                [ width <| px 100
                , alignRight
                , height fill
                , mouseOver [ Background.color Styles.color.lightBlue ]
                , pointer
                , onClick <| toMsg ClickedSignOut
                ]
                (Styled.textWith [ centerY, centerX ] "Sign Out")
                |> viewIf userIsSignedIn
            ]


navbarDesktopLinkItem styles { url, label } =
    link
        ([ height fill
         , mouseOver [ Background.color Styles.color.lightBlue ]
         ]
            ++ styles
        )
        { url = url
        , label =
            el
                [ centerY
                , width <| minimum 100 shrink
                , padding 20
                , Font.center
                ]
            <|
                Element.text label
        }


navbarMobileLinkItem { url, label } =
    link
        [ height <| px 50 ]
        { url = url
        , label =
            el
                [ centerY
                , width fill
                , padding 10
                ]
            <|
                Element.text label
        }


footer viewportWidth =
    div footerStyle
        [ div []
            [ if viewportWidth > 480 then
                Html.text "Contact: "

              else
                div [] []
            , a
                [ href "mailto:hello@swiftcom.app"
                , style "text-decoration" "none"
                ]
                [ text "SwiftCom" ]
            ]
        , a
            [ href "https://elm-lang.org/"
            , style "text-decoration" "none"
            ]
            [ Html.text "Made with ♥ using Elm" ]
        ]
