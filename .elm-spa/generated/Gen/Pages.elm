module Gen.Pages exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Navigation exposing (Key)
import Effect exposing (Effect)
import ElmSpa.Page
import Gen.Params.AddSite
import Gen.Params.Admin
import Gen.Params.Home_
import Gen.Params.Login
import Gen.Params.NotFound
import Gen.Params.Register
import Gen.Model as Model
import Gen.Msg as Msg
import Gen.Route as Route exposing (Route)
import Page exposing (Page)
import Pages.AddSite
import Pages.Admin
import Pages.Home_
import Pages.Login
import Pages.NotFound
import Pages.Register
import Request exposing (Request)
import Shared
import Task
import Url exposing (Url)
import View exposing (View)


type alias Model =
    Model.Model


type alias Msg =
    Msg.Msg


init : Route -> Shared.Model -> Url -> Key -> ( Model, Effect Msg )
init route =
    case route of
        Route.AddSite ->
            pages.addSite.init ()
    
        Route.Admin ->
            pages.admin.init ()
    
        Route.Home_ ->
            pages.home_.init ()
    
        Route.Login ->
            pages.login.init ()
    
        Route.NotFound ->
            pages.notFound.init ()
    
        Route.Register ->
            pages.register.init ()


update : Msg -> Model -> Shared.Model -> Url -> Key -> ( Model, Effect Msg )
update msg_ model_ =
    case ( msg_, model_ ) of
        ( Msg.AddSite msg, Model.AddSite params model ) ->
            pages.addSite.update params msg model
    
        ( Msg.Admin msg, Model.Admin params model ) ->
            pages.admin.update params msg model
    
        ( Msg.Home_ msg, Model.Home_ params model ) ->
            pages.home_.update params msg model
    
        ( Msg.Login msg, Model.Login params model ) ->
            pages.login.update params msg model
    
        ( Msg.Register msg, Model.Register params model ) ->
            pages.register.update params msg model

        _ ->
            \_ _ _ -> ( model_, Effect.none )


view : Model -> Shared.Model -> Url -> Key -> View Msg
view model_ =
    case model_ of
        Model.Redirecting_ ->
            \_ _ _ -> View.none
    
        Model.AddSite params model ->
            pages.addSite.view params model
    
        Model.Admin params model ->
            pages.admin.view params model
    
        Model.Home_ params model ->
            pages.home_.view params model
    
        Model.Login params model ->
            pages.login.view params model
    
        Model.NotFound params ->
            pages.notFound.view params ()
    
        Model.Register params model ->
            pages.register.view params model


subscriptions : Model -> Shared.Model -> Url -> Key -> Sub Msg
subscriptions model_ =
    case model_ of
        Model.Redirecting_ ->
            \_ _ _ -> Sub.none
    
        Model.AddSite params model ->
            pages.addSite.subscriptions params model
    
        Model.Admin params model ->
            pages.admin.subscriptions params model
    
        Model.Home_ params model ->
            pages.home_.subscriptions params model
    
        Model.Login params model ->
            pages.login.subscriptions params model
    
        Model.NotFound params ->
            pages.notFound.subscriptions params ()
    
        Model.Register params model ->
            pages.register.subscriptions params model



-- INTERNALS


pages :
    { addSite : Bundle Gen.Params.AddSite.Params Pages.AddSite.Model Pages.AddSite.Msg
    , admin : Bundle Gen.Params.Admin.Params Pages.Admin.Model Pages.Admin.Msg
    , home_ : Bundle Gen.Params.Home_.Params Pages.Home_.Model Pages.Home_.Msg
    , login : Bundle Gen.Params.Login.Params Pages.Login.Model Pages.Login.Msg
    , notFound : Static Gen.Params.NotFound.Params
    , register : Bundle Gen.Params.Register.Params Pages.Register.Model Pages.Register.Msg
    }
pages =
    { addSite = bundle Pages.AddSite.page Model.AddSite Msg.AddSite
    , admin = bundle Pages.Admin.page Model.Admin Msg.Admin
    , home_ = bundle Pages.Home_.page Model.Home_ Msg.Home_
    , login = bundle Pages.Login.page Model.Login Msg.Login
    , notFound = static Pages.NotFound.view Model.NotFound
    , register = bundle Pages.Register.page Model.Register Msg.Register
    }


type alias Bundle params model msg =
    ElmSpa.Page.Bundle params model msg Shared.Model (Effect Msg) Model Msg (View Msg)


bundle page toModel toMsg =
    ElmSpa.Page.bundle
        { redirecting =
            { model = Model.Redirecting_
            , view = View.none
            }
        , toRoute = Route.fromUrl
        , toUrl = Route.toHref
        , fromCmd = Effect.fromCmd
        , mapEffect = Effect.map toMsg
        , mapView = View.map toMsg
        , toModel = toModel
        , toMsg = toMsg
        , page = page
        }


type alias Static params =
    Bundle params () Never


static : View Never -> (params -> Model) -> Static params
static view_ toModel =
    { init = \params _ _ _ -> ( toModel params, Effect.none )
    , update = \params _ _ _ _ _ -> ( toModel params, Effect.none )
    , view = \_ _ _ _ _ -> View.map never view_
    , subscriptions = \_ _ _ _ _ -> Sub.none
    }
    
