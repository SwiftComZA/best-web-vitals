module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Api.Site exposing (Direction(..), ScoreType(..), Site, Sort(..))
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
    , sort : ( Sort, Direction )
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { siteList = Dict.empty, sort = ( MobileScore Perf, Desc ) }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateSiteList (Dict String Site)
    | ChangeSort Sort


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        UpdateSiteList siteList ->
            ( { model | siteList = siteList }
            , Cmd.none
            )

        ChangeSort sort ->
            let
                newSort =
                    if Tuple.first model.sort == sort then
                        if Tuple.second model.sort == Asc then
                            ( sort, Desc )

                        else
                            ( sort, Asc )

                    else if sort == Domain then
                        ( sort, Asc )

                    else
                        ( sort, Desc )
            in
            ( { model | sort = newSort }, Cmd.none )


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
