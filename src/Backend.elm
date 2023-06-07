module Backend exposing (..)

import Api.Site exposing (Score(..), ScoreDevice(..))
import Bridge exposing (..)
import Dict
import Env
import Http
import Json.Auto.SpeedrunResult
import Lamdera exposing (..)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.none


init : ( Model, Cmd BackendMsg )
init =
    ( { message = "stub"
      , sites = Dict.empty
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        GotSiteStats clientId siteUrl device result ->
            let
                maybeSiteScores =
                    model.sites |> Dict.get siteUrl

                newSiteScores =
                    { url = siteUrl
                    , mobileScore =
                        if device == Mobile then
                            case result of
                                Ok r ->
                                    Success
                                        { performance = r.lighthouseResult.categories.performance.score
                                        , accessibility = r.lighthouseResult.categories.accessibility.score
                                        , bestPractices = r.lighthouseResult.categories.bestPractices.score
                                        , seo = r.lighthouseResult.categories.seo.score
                                        }

                                Err _ ->
                                    Failed

                        else
                            case maybeSiteScores of
                                Just siteScores ->
                                    siteScores.mobileScore

                                Nothing ->
                                    Failed
                    , desktopScore =
                        if device == Desktop then
                            case result of
                                Ok r ->
                                    Success
                                        { performance = r.lighthouseResult.categories.performance.score
                                        , accessibility = r.lighthouseResult.categories.accessibility.score
                                        , bestPractices = r.lighthouseResult.categories.bestPractices.score
                                        , seo = r.lighthouseResult.categories.seo.score
                                        }

                                Err _ ->
                                    Failed

                        else
                            case maybeSiteScores of
                                Just siteScores ->
                                    siteScores.desktopScore

                                Nothing ->
                                    Failed
                    }

                newModel =
                    { model
                        | sites = model.sites |> Dict.insert siteUrl newSiteScores
                    }
            in
            ( newModel
            , sendToFrontend clientId <| UpdateSiteList newModel.sites
            )

        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> Types.ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        FetchSites ->
            ( model, sendToFrontend clientId <| UpdateSiteList model.sites )

        RequestSiteStats siteUrl ->
            let
                newModel =
                    { model
                        | sites =
                            model.sites
                                |> Dict.insert siteUrl
                                    { url = siteUrl
                                    , mobileScore = Pending
                                    , desktopScore = Pending
                                    }
                    }
            in
            ( newModel
            , Cmd.batch
                [ requestSiteStats clientId siteUrl
                , sendToFrontend clientId <| UpdateSiteList newModel.sites
                ]
            )

        DeleteSite siteUrl ->
            let
                newModel =
                    { model | sites = model.sites |> Dict.remove siteUrl }
            in
            ( newModel
            , sendToFrontend clientId <| UpdateSiteList newModel.sites
            )


proxy : String
proxy =
    case Env.mode of
        Env.Development ->
            "http://localhost:8001/"

        Env.Production ->
            ""


requestSiteStats : ClientId -> String -> Cmd BackendMsg
requestSiteStats clientId siteUrl =
    let
        url =
            proxy
                ++ "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="
                ++ siteUrl
                ++ "&category=performance&category=accessibility&category=best-practices&category=seo"
                ++ "&key="
                ++ Env.pageSpeedApiKey

        urlMobile =
            url ++ "&strategy=mobile"

        urlDesktop =
            url ++ "&strategy=desktop"

        mobileCmd =
            Http.get
                { url = urlMobile
                , expect = Http.expectJson (GotSiteStats clientId siteUrl Mobile) Json.Auto.SpeedrunResult.rootDecoder
                }

        desktopCmd =
            Http.get
                { url = urlDesktop
                , expect = Http.expectJson (GotSiteStats clientId siteUrl Desktop) Json.Auto.SpeedrunResult.rootDecoder
                }
    in
    Cmd.batch
        [ mobileCmd
        , desktopCmd
        ]
