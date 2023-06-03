module Backend exposing (..)

import Bridge exposing (..)
import Dict
import Fifo
import Gen.Msg
import Http
import Json.Auto.SpeedrunResult
import Json.Decode
import Lamdera exposing (..)
import Pages.Home_
import Task
import Types exposing (..)
import Time

type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    -- subscribe to a timer
    Time.every 5000 (\_ -> RequestSiteStats)

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
      , sitesQueuedForRetrieval = Fifo.empty
      , sitesRetrieved = Dict.empty
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        GotSiteStats siteReq device result ->
            let
                newSiteReq =
                    { siteReq
                        | attempts = siteReq.attempts + 1
                        , mobileResult =
                            if device == Mobile then
                                Just <|
                                    case result of
                                        Ok r ->
                                            Ok
                                                { performance = r.lighthouseResult.categories.performance.score
                                                , accessibility = r.lighthouseResult.categories.accessibility.score
                                                , bestPractices = r.lighthouseResult.categories.bestPractices.score
                                                , seo = r.lighthouseResult.categories.seo.score
                                                }

                                        Err err ->
                                            Err err

                            else
                                siteReq.mobileResult
                        , desktopResult =
                            if device == Desktop then
                                Just <|
                                    case result of
                                        Ok r ->
                                            Ok
                                                { performance = r.lighthouseResult.categories.performance.score
                                                , accessibility = r.lighthouseResult.categories.accessibility.score
                                                , bestPractices = r.lighthouseResult.categories.bestPractices.score
                                                , seo = r.lighthouseResult.categories.seo.score
                                                }

                                        Err err ->
                                            Err err

                            else
                                siteReq.desktopResult
                    }

                noErrors = 
                    case (newSiteReq.mobileResult, newSiteReq.desktopResult) of
                        (Just (Ok _), Just (Ok _)) ->
                            True

                        _ ->
                            False

                newFifo =
                    if noErrors then
                        model.sitesQueuedForRetrieval |> Fifo.remove |> Tuple.second

                    else
                        model.sitesQueuedForRetrieval

                newSitesRetrieved = 
                    if noErrors then
                        model.sitesRetrieved |> Dict.insert siteReq.url newSiteReq

                    else
                        model.sitesRetrieved

                newModel =
                    { model
                        | sitesQueuedForRetrieval = newFifo
                        , sitesRetrieved = newSitesRetrieved
                    }
                
            in
            ( newModel
            , Cmd.none
            )

        RequestSiteStats ->
            let
                siteReq =
                    model.sitesQueuedForRetrieval |> Fifo.remove |> Tuple.first
            in
            case siteReq of
                Just siteReq_ ->
                    ( model
                    , requestSiteStats siteReq_
                    )

                Nothing ->
                    ( model, Cmd.none )

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
            let
                siteRequest =
                    { url = site
                    , mobileResult = Nothing
                    , desktopResult = Nothing
                    , attempts = 0
                    }
            in
            ( { model | sitesQueuedForRetrieval = model.sitesQueuedForRetrieval |> Fifo.insert siteRequest }
            , Cmd.none
            )


requestSiteStats : SiteRequest -> Cmd BackendMsg
requestSiteStats siteReq =
    let
        url =
            "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="
                ++ siteReq.url
                ++ "&category=performance&category=accessibility&category=best-practices&category=seo"

        urlMobile =
            url ++ "&strategy=mobile"

        urlDesktop =
            url ++ "&strategy=desktop"

        mobileCmd =
            Http.get
                { url = urlMobile
                , expect = Http.expectJson (GotSiteStats siteReq Mobile) Json.Auto.SpeedrunResult.rootDecoder
                }

        desktopCmd =
            Http.get
                { url = urlDesktop
                , expect = Http.expectJson (GotSiteStats siteReq Desktop) Json.Auto.SpeedrunResult.rootDecoder
                }
    in
    Cmd.batch [ mobileCmd, desktopCmd ]
