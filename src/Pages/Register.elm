module Pages.Register exposing (Model, Msg(..), page)

import Api.Data exposing (Data(..))
import Api.User exposing (User, validateUser)
import Bridge exposing (ToBackend(..), sendToBackend)
import Effect exposing (Effect)
import Element exposing (centerX, centerY, column, fill, height, htmlAttribute, layout, maximum, paddingXY, spacing, width)
import Element.Input as Input
import Gen.Params.Register exposing (Params)
import Gen.Route as Route
import Html.Attributes exposing (style)
import Page
import Request exposing (Request)
import Shared
import String exposing (fromInt)
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
    { username : String
    , email : String
    , password : String
    , message : Maybe ( String, Bool )
    }


init : ( Model, Effect Msg )
init =
    ( Model "" "" "" Nothing
    , Effect.none
    )



-- UPDATE


type Msg
    = Updated Field String
    | ClickedSubmit
    | GotUser (Data User)


type Field
    = Username
    | Email
    | Password


update : Request -> Msg -> Model -> ( Model, Effect Msg )
update req msg model =
    case msg of
        Updated Username username ->
            ( { model | username = username }, Effect.none )

        Updated Email email ->
            ( { model | email = email }, Effect.none )

        Updated Password password ->
            ( { model | password = password }, Effect.none )

        ClickedSubmit ->
            let
                newUser =
                    { username = model.username
                    , email = model.email
                    , password = model.password
                    }

                ( validUsername, validEmail, validPass ) =
                    validateUser newUser
            in
            case ( validUsername, validEmail, validPass ) of
                ( True, True, True ) ->
                    ( { model | message = Nothing }, Effect.fromCmd <| sendToBackend <| AttemptRegistration <| newUser )

                ( False, _, _ ) ->
                    ( { model | message = Just ( "Please enter a valid username", True ) }, Effect.none )

                ( _, False, _ ) ->
                    ( { model | message = Just ( "Please enter a valid email address", True ) }, Effect.none )

                ( _, _, False ) ->
                    ( { model | message = Just ( "Please enter a valid password", True ) }, Effect.none )

        GotUser userData ->
            case userData of
                Success user ->
                    ( Model ""
                        ""
                        ""
                        (Just
                            ( "You have successfully registered!", False )
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
        [ layout
            [ width fill
            , paddingXY 20 75
            , height fill
            , htmlAttribute <|
                style "min-height"
                    ("calc(100vh - "
                        ++ fromInt (Styles.navbarHeight + Styles.footerHeight)
                        ++ "px)"
                    )
            ]
          <|
            column [ centerX, centerY, width <| maximum 500 fill ]
                [ column [ centerX, spacing 20, width fill ]
                    [ Input.username
                        (Styles.inputStyle ++ [ onEnter ClickedSubmit ])
                        { onChange = Updated Username
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Username"
                        , text = model.username
                        , label = Input.labelHidden ""
                        }
                    , Input.email
                        (Styles.inputStyle ++ [ onEnter ClickedSubmit ])
                        { onChange = Updated Email
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Email"
                        , text = model.email
                        , label = Input.labelHidden ""
                        }
                    , Input.newPassword
                        (Styles.inputStyle ++ [ onEnter ClickedSubmit ])
                        { onChange = Updated Password
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Password"
                        , text = model.password
                        , label = Input.labelHidden ""
                        , show = False
                        }
                    , Styled.submitButtonWith Styles.buttonStyle
                        { label = Element.text "Register"
                        , onPress = Just ClickedSubmit
                        , disabled = False
                        }
                    , Styled.message model.message
                    ]
                ]
        ]
    }
