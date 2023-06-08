module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Api.Site exposing (Category, Direction(..), FrontendLang, ScoreType(..), Site, Sort(..))
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
    { sites : Dict String Site
    , sort : ( Sort, Direction )
    , categories : List Category
    , frontendLangs : List FrontendLang
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { sites = Dict.empty
      , sort = ( MobileScore Perf, Desc )
      , categories = []
      , frontendLangs = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeSort Sort
    | GotSites (Dict String Site)
    | GotCategories (List Category)
    | GotFrontendLangs (List FrontendLang)


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        ChangeSort sort ->
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
