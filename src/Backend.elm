module Backend exposing (..)

import Api.Data
import Api.Site exposing (Platform(..), Score(..))
import Api.User
import Bridge exposing (..)
import Crypto.Hash
import Dict
import Env
import Gen.Msg
import Http
import Json.Auto.SpeedrunResult
import Lamdera exposing (..)
import Pages.Login
import Pages.Register
import Random
import Random.Char
import Random.String
import Set
import Task
import Time as Time
import Time.Extra as Time
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \_ -> onConnect OnConnect
        }


subscriptions : Model -> Sub BackendMsg
subscriptions _ =
    Sub.none


init : ( Model, Cmd BackendMsg )
init =
    ( { users = Dict.empty
      , authenticatedSessions = Dict.empty
      , sites = Dict.empty
      , categories = Set.empty
      , frontendLangs = Set.empty
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        OnConnect sessionId clientId ->
            ( model, Time.now |> Task.perform (VerifySession sessionId clientId) )

        AuthenticateSession sessionId clientId user now ->
            ( { model
                | authenticatedSessions =
                    model.authenticatedSessions
                        |> Dict.insert sessionId
                            { user = user.email
                            , expires = now |> Time.add Time.Hour 24 Time.utc
                            }
              }
            , sendToFrontend clientId <| SignInUser <| user
            )

        VerifySession sessionId clientId now ->
            let
                maybeUser =
                    model.authenticatedSessions
                        |> Dict.get sessionId
                        |> Maybe.andThen
                            (\session ->
                                if session.expires |> sessionExpired now then
                                    Nothing

                                else
                                    model.users |> Dict.get session.user
                            )
            in
            case maybeUser of
                Nothing ->
                    ( model, sendToFrontend clientId <| SignOutUser )

                Just user ->
                    ( model, sendToFrontend clientId <| SignInUser <| Api.User.toUser user )

        GotSiteStats clientId siteUrl device result ->
            let
                maybeSite =
                    model.sites |> Dict.get siteUrl

                newSiteScores =
                    { url = siteUrl
                    , category =
                        case maybeSite of
                            Just siteScores ->
                                siteScores.category

                            Nothing ->
                                ""
                    , frontendLang =
                        case maybeSite of
                            Just siteScores ->
                                siteScores.frontendLang

                            Nothing ->
                                ""
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
                            case maybeSite of
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
                            case maybeSite of
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
            , sendToFrontend clientId <| SendSites newModel.sites
            )

        RegisterUser sessionId clientId user salt ->
            let
                newUser =
                    { username = user.username
                    , email = user.email
                    , isAdmin = Api.User.adminUsers |> List.member user.email
                    , passwordHash = hashPassword user.password salt
                    , salt = salt
                    }
            in
            ( { model | users = model.users |> Dict.insert user.email newUser }
            , Cmd.batch
                [ sendToPage clientId <|
                    Gen.Msg.Register <|
                        Pages.Register.GotUser <|
                            Api.Data.Success <|
                                Api.User.toUser newUser
                , Time.now |> Task.perform (AuthenticateSession sessionId clientId <| Api.User.toUser newUser)
                ]
            )

        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> Types.ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        AttemptSignOut ->
            ( { model | authenticatedSessions = model.authenticatedSessions |> Dict.remove sessionId }, sendToFrontend clientId <| SignOutUser )

        FetchSites ->
            ( model, sendToFrontend clientId <| SendSites model.sites )

        FetchCategories ->
            ( model, sendToFrontend clientId <| SendCategories <| Set.toList <| model.categories )

        FetchFrontendLangs ->
            ( model, sendToFrontend clientId <| SendFrontendLangs <| Set.toList <| model.frontendLangs )

        RequestSiteStats siteUrl category frontendLang ->
            let
                newModel =
                    { model
                        | sites =
                            model.sites
                                |> Dict.insert siteUrl
                                    { url = siteUrl
                                    , mobileScore = Pending
                                    , desktopScore = Pending
                                    , category = category
                                    , frontendLang = frontendLang
                                    }
                    }
            in
            ( newModel
            , Cmd.batch
                [ requestSiteStats clientId siteUrl
                , sendToFrontend clientId <| SendSites newModel.sites
                ]
            )

        AddCategory category ->
            let
                newModel =
                    if isAdminSession model sessionId then
                        { model | categories = model.categories |> Set.insert category }

                    else
                        model
            in
            ( newModel
            , sendToFrontend clientId <| SendCategories <| Set.toList <| newModel.categories
            )

        AddFrontendLang frontendLang ->
            let
                newModel =
                    if isAdminSession model sessionId then
                        { model | frontendLangs = model.frontendLangs |> Set.insert frontendLang }

                    else
                        model
            in
            ( newModel
            , sendToFrontend clientId <| SendFrontendLangs <| Set.toList <| newModel.frontendLangs
            )

        DeleteSite siteUrl ->
            let
                newModel =
                    if isAdminSession model sessionId then
                        { model | sites = model.sites |> Dict.remove siteUrl }

                    else
                        model
            in
            ( newModel
            , sendToFrontend clientId <| SendSites newModel.sites
            )

        DeleteCategory category ->
            let
                newModel =
                    if isAdminSession model sessionId then
                        { model | categories = model.categories |> Set.remove category }

                    else
                        model
            in
            ( newModel
            , sendToFrontend clientId <| SendCategories <| Set.toList <| newModel.categories
            )

        DeleteFrontendLang frontendLang ->
            let
                newModel =
                    if isAdminSession model sessionId then
                        { model | frontendLangs = model.frontendLangs |> Set.remove frontendLang }

                    else
                        model
            in
            ( newModel
            , sendToFrontend clientId <| SendFrontendLangs <| Set.toList <| newModel.frontendLangs
            )

        AttemptSignIn user ->
            case model.users |> Dict.get user.email of
                Just existingUser ->
                    let
                        passwordHash =
                            hashPassword user.password existingUser.salt
                    in
                    if passwordHash == existingUser.passwordHash then
                        ( model
                        , Cmd.batch
                            [ sendToPage clientId <|
                                Gen.Msg.Login <|
                                    Pages.Login.GotUser <|
                                        Api.Data.Success <|
                                            Api.User.toUser existingUser
                            , Time.now |> Task.perform (AuthenticateSession sessionId clientId <| Api.User.toUser existingUser)
                            ]
                        )

                    else
                        ( model
                        , sendToPage clientId <|
                            Gen.Msg.Login <|
                                Pages.Login.GotUser <|
                                    Api.Data.Failure "Incorrect email or password."
                        )

                Nothing ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Login <|
                            Pages.Login.GotUser <|
                                Api.Data.Failure "Incorrect email or password."
                    )

        AttemptRegistration user ->
            let
                ( validUsername, validEmail, validPass ) =
                    Api.User.validateUser user
            in
            case ( validUsername, validEmail, validPass ) of
                ( True, True, True ) ->
                    case model.users |> Dict.get user.email of
                        Just _ ->
                            ( model
                            , sendToPage clientId <|
                                Gen.Msg.Register <|
                                    Pages.Register.GotUser <|
                                        Api.Data.Failure "This email address is already taken"
                            )

                        Nothing ->
                            ( model
                            , Random.generate (RegisterUser sessionId clientId user) randomSalt
                            )

                ( False, _, _ ) ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Register <|
                            Pages.Register.GotUser <|
                                Api.Data.Failure "Please enter a valid username"
                    )

                ( _, False, _ ) ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Register <|
                            Pages.Register.GotUser <|
                                Api.Data.Failure "Please enter a valid email address"
                    )

                ( _, _, False ) ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Register <|
                            Pages.Register.GotUser <|
                                Api.Data.Failure "Please enter a valid password"
                    )



-- CRYPTO


randomSalt : Random.Generator String
randomSalt =
    Random.String.string 10 Random.Char.english


hashPassword password salt =
    Crypto.Hash.sha256 <| password ++ salt



-- HELPERS


isAdminSession : Model -> SessionId -> Bool
isAdminSession model sessionId =
    let
        maybeUser =
            model.authenticatedSessions
                |> Dict.get sessionId
                |> Maybe.map .user
                |> Maybe.andThen (\user -> model.users |> Dict.get user)
    in
    case maybeUser of
        Nothing ->
            False

        Just user ->
            user.isAdmin


sendToPage clientId page =
    sendToFrontend clientId <| PageMsg <| page



-- REQUEST


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


sessionExpired : Time.Posix -> Time.Posix -> Bool
sessionExpired now expiration =
    Time.posixToMillis now >= Time.posixToMillis expiration
