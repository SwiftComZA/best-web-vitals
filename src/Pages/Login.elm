module Pages.Login exposing (Model, Msg(..), page)

import Api.Data exposing (Data(..))
import Api.User exposing (User)
import Bridge exposing (ToBackend(..), sendToBackend)
import Effect exposing (Effect)
import Element exposing (centerX, column, fill, layout, paddingXY, px, spacing, width)
import Element.Input as Input
import Evergreen.V1.Pages.AddSite exposing (Field)
import Gen.Params.Register exposing (Params)
import Gen.Route as Route
import Page
import Request exposing (Request)
import Shared
import UI.Styled as Styled
import UI.Styles as Styles
import Utils.Misc exposing (onEnter)
import Utils.Route
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update req
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { email : String
    , password : String
    , message : Maybe ( String, Bool )
    }


init : ( Model, Effect Msg )
init =
    ( Model "" "" Nothing
    , Effect.none
    )



-- UPDATE


type Msg
    = Updated Field String
    | ClickedSubmit
    | GotUser (Data User)


type Field
    = Email
    | Password


update : Request -> Msg -> Model -> ( Model, Effect Msg )
update req msg model =
    case msg of
        Updated Email email ->
            ( { model | email = email }, Effect.none )

        Updated Password password ->
            ( { model | password = password }, Effect.none )

        ClickedSubmit ->
            let
                user =
                    { email = model.email
                    , password = model.password
                    }
            in
            ( { model | message = Nothing }, Effect.fromCmd <| sendToBackend <| AttemptSignIn <| user )

        GotUser maybeUser ->
            case maybeUser of
                Success user ->
                    ( Model ""
                        ""
                        (Just
                            ( "Welcome back " ++ user.username ++ "!", False )
                        )
                    , Effect.fromCmd
                        (Utils.Route.navigate req.key
                            (if user.isAdmin then
                                Route.Admin

                             else
                                Route.Home_
                            )
                        )
                    )

                Failure error ->
                    ( { model | message = Just ( error, True ) }, Effect.none )

                _ ->
                    ( { model | message = Just ( "Something went wrong", True ) }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view _ model =
    { title = "Register"
    , body =
        [ layout [ width fill, paddingXY 50 100 ] <|
            column [ centerX ]
                [ column [ spacing 20, width <| px 500 ]
                    [ Input.email
                        (Styles.inputStyle ++ [ onEnter ClickedSubmit ])
                        { onChange = Updated Email
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Email"
                        , text = model.email
                        , label = Input.labelHidden ""
                        }
                    , Input.currentPassword
                        (Styles.inputStyle ++ [ onEnter ClickedSubmit ])
                        { onChange = Updated Password
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Password"
                        , text = model.password
                        , label = Input.labelHidden ""
                        , show = False
                        }
                    , Styled.submitButtonWith Styles.buttonStyle
                        { label = Element.text "Sign In"
                        , onPress = Just ClickedSubmit
                        , disabled = False
                        }
                    , Styled.message model.message
                    ]
                ]
        ]
    }
