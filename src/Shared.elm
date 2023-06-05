module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Api.Site exposing (Site)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (class, href, rel)
import Request exposing (Request)
import UI.Navbar as Navbar
import View exposing (View)



-- INIT


type alias Flags =
    ()


type alias Model =
    { siteList : Dict String Site
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { siteList = Dict.empty }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateSiteList (Dict String Site)


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        UpdateSiteList siteList ->
            ( { model | siteList = siteList }
            , Cmd.none
            )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none



-- VIEW


view :
    Request
    -> { page : View msg, toMsg : Msg -> msg }
    -> Model
    -> View msg
view req { page, toMsg } model =
    { title =
        page.title
    , body =
        css
            ++ [ div [ class "layout" ]
                    [ Navbar.view
                    , div [ class "page" ] page.body
                    ]
               ]
    }


css =
    [ Html.node "link" [ rel "stylesheet", href "/style.css" ] [] ]
