module Backend exposing (..)

import Bridge exposing (..)
import Dict
import Gen.Msg
import Lamdera exposing (..)
import Pages.Home_
import Task
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { message = "stub"
      , siteList =
            Dict.singleton "swiftcom.app"
                { domain = "swiftcom.app"
                , category = "Software Development"
                , frontendLang = "Elm"
                , approved = False
                , mobileScore = 100
                , desktopScore = 101
                }
      , sitesQueuedForRetrieval = []
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> Types.ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        SendSiteToBackend site ->
            ( { model | siteList = model.siteList |> Dict.insert site.domain site }, Cmd.none )

        FetchSites ->
            ( model, sendToFrontend clientId <| UpdateSiteList model.siteList )

        ApproveSiteToBackend site bool ->
            let
                newModel =
                    { model
                        | siteList =
                            model.siteList
                                |> Dict.update site
                                    (\maybeSite ->
                                        maybeSite
                                            |> Maybe.andThen (\s -> Just { s | approved = bool })
                                    )
                    }
            in
            ( newModel
            , sendToFrontend clientId <| UpdateSiteList newModel.siteList
            )

        QueueSiteForRetrieval site ->
            ( { model | sitesQueuedForRetrieval = model.sitesQueuedForRetrieval |> List.append [ site ] }
            , Cmd.none
            )
