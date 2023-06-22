module Pages.Admin exposing (Field(..), Model, Msg(..), page)

import Api.Site as Site exposing (Score(..), ScoreType(..), Site, Sort(..))
import Bridge exposing (..)
import Dict
import Effect exposing (Effect)
import Element exposing (centerX, column, el, fill, fillPortion, layout, maximum, minimum, mouseOver, padding, paddingEach, paddingXY, pointer, rgb, row, spacing, table, text, width)
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Page
import Request exposing (Request)
import Shared
import String exposing (fromInt)
import UI.Styled as Styled
import UI.Styles as Styles exposing (noPadding)
import Utils.If exposing (viewIfElse)
import Utils.Maybe exposing (boolToBool)
import Utils.Misc exposing (onEnter)
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.advanced
        { init = init shared
        , update = update
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    { category : Site.Category
    , frontendLang : Site.FrontendLang
    }


init : Shared.Model -> ( Model, Effect Msg )
init _ =
    ( Model "" ""
    , Effect.batch
        [ Effect.fromCmd <| sendToBackend <| FetchCategories
        , Effect.fromCmd <| sendToBackend <| FetchFrontendLangs
        ]
    )



-- UPDATE


type Msg
    = ClickedDeleteSite String
    | ClickedDelete Field String
    | ClickedChangeSort Sort
    | Updated Field String
    | ClickedSubmit Field


type Field
    = Category
    | FrontendLang


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedChangeSort sort ->
            ( model, Effect.fromShared <| Shared.ChangedSort sort )

        Updated Category category ->
            ( { model | category = category }, Effect.none )

        Updated FrontendLang frontendLang ->
            ( { model | frontendLang = frontendLang }, Effect.none )

        ClickedSubmit Category ->
            ( { model | category = "" }, Effect.fromCmd <| sendToBackend <| AddCategory model.category )

        ClickedSubmit FrontendLang ->
            ( { model | frontendLang = "" }, Effect.fromCmd <| sendToBackend <| AddFrontendLang model.frontendLang )

        ClickedDeleteSite siteUrl ->
            ( model, Effect.fromCmd <| sendToBackend <| DeleteSite siteUrl )

        ClickedDelete Category siteUrl ->
            ( model, Effect.fromCmd <| sendToBackend <| DeleteCategory siteUrl )

        ClickedDelete FrontendLang siteUrl ->
            ( model, Effect.fromCmd <| sendToBackend <| DeleteFrontendLang siteUrl )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    let
        sites =
            shared.sites |> Dict.values |> Site.sort shared.sort
    in
    { title = "Admin"
    , body =
        [ layout [ width fill, paddingXY 20 75 ] <|
            viewIfElse (shared.user |> Maybe.map (\user -> user.isAdmin) |> boolToBool)
                (column [ width fill, spacing 50 ]
                    [ Styled.textWith [ centerX ] "Websites"
                    , el [ width fill ] <| siteScoresTable sites
                    , Styled.textWith [ centerX ] "Categories"
                    , categoriesTable model shared.categories
                    , Styled.textWith [ centerX ] "Frontend Languages"
                    , frontendLangsTable model shared.frontendLangs
                    ]
                )
                (text "You are not authorized to view this page.")
        ]
    }



-- TABLES
-- Still figuring out how to elegantly handle these tables


siteScoresTable : List Site -> Element.Element Msg
siteScoresTable siteList =
    table [ centerX, Styles.borderShadow, width <| minimum 1240 fill ]
        { data = siteList
        , columns =
            [ { header = tableCell [ Font.bold, pointer, onClick <| ClickedChangeSort Domain ] <| text "Domain"
              , width = fillPortion 2
              , view =
                    \site -> tableCell [] <| text site.url
              }
            , { header = tableCell [ Font.center, Font.bold, pointer, onClick <| ClickedChangeSort Site.Category ] <| text "Category"
              , width = fillPortion 2
              , view = \site -> tableCell [ Font.center ] <| text site.category
              }
            , { header = tableCell [ Font.center, Font.bold, pointer, onClick <| ClickedChangeSort Site.FrontendLang ] <| text "Frontend Language"
              , width = fillPortion 2
              , view = \site -> tableCell [ Font.center ] <| text site.frontendLang
              }
            ]
                ++ tableScoreColumns
                ++ [ { header = tableCell [ Font.center, Font.bold ] <| text ""
                     , width = fillPortion 1
                     , view =
                        \site ->
                            tableCell
                                [ Font.center
                                ]
                            <|
                                el
                                    [ pointer
                                    , mouseOver [ Font.color <| rgb 1 0 0 ]
                                    , centerX
                                    , onClick <| ClickedDeleteSite site.url
                                    ]
                                <|
                                    text "✘"
                     }
                   ]
        }


tableScoreColumns : List (Element.Column Site Msg)
tableScoreColumns =
    [ { header =
            tableCell [ Font.bold, width fill ] <|
                column [ width fill, centerX, Font.center ]
                    [ el [ centerX ] <| text "Mobile Score"
                    , row [ width fill, paddingEach { noPadding | top = 10 } ]
                        [ el [ width fill, pointer, onClick <| ClickedChangeSort (MobileScore Perf) ] <| text "perf"
                        , el [ width fill, pointer, onClick <| ClickedChangeSort (MobileScore A11y) ] <| text "a11y"
                        , el [ width fill, pointer, onClick <| ClickedChangeSort (MobileScore BP) ] <| text "bp"
                        , el [ width fill, pointer, onClick <| ClickedChangeSort (MobileScore SEO) ] <| text "seo"
                        ]
                    ]
      , width = fillPortion 2
      , view =
            \site ->
                case site.mobileScore of
                    Pending ->
                        tableCell [ Font.center ] <| text "Pending"

                    Failed ->
                        tableCell [ Font.center ] <| text "Failed"

                    Success score ->
                        tableCell [] <|
                            row [ width fill ]
                                [ el [ width fill, Font.center ] <| text <| fromInt <| round <| score.performance * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.accessibility * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.bestPractices * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.seo * 100
                                ]
      }
    , { header =
            tableCell [ Font.bold, width fill ] <|
                column [ width fill, centerX, Font.center ]
                    [ el [ centerX ] <| text "Desktop Score"
                    , row [ width fill, paddingEach { noPadding | top = 10 } ]
                        [ el [ width fill, pointer, onClick <| ClickedChangeSort (DesktopScore Perf) ] <| text "perf"
                        , el [ width fill, pointer, onClick <| ClickedChangeSort (DesktopScore A11y) ] <| text "a11y"
                        , el [ width fill, pointer, onClick <| ClickedChangeSort (DesktopScore BP) ] <| text "bp"
                        , el [ width fill, pointer, onClick <| ClickedChangeSort (DesktopScore SEO) ] <| text "seo"
                        ]
                    ]
      , width = fillPortion 2
      , view =
            \site ->
                case site.desktopScore of
                    Pending ->
                        tableCell [ Font.center ] <| text "Pending"

                    Failed ->
                        tableCell [ Font.center ] <| text "Failed"

                    Success score ->
                        tableCell [] <|
                            row [ width fill ]
                                [ el [ width fill, Font.center ] <| text <| fromInt <| round <| score.performance * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.accessibility * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.bestPractices * 100
                                , el [ width fill, Font.center ] <| text <| fromInt <| round <| score.seo * 100
                                ]
      }
    ]


tableCell : List (Element.Attribute msg) -> Element.Element msg -> Element.Element msg
tableCell atts content =
    el (atts ++ [ padding 10 ]) <| content


categoriesTable : Model -> List Site.Category -> Element.Element Msg
categoriesTable model categories =
    table [ centerX, Styles.borderShadow, width <| maximum 500 fill ]
        { data = (categories |> List.map (\cat -> Data cat)) ++ [ Input ]
        , columns =
            [ { header = tableCell [ Font.bold ] <| text "Category"
              , width = fillPortion 8
              , view = categoryRow model <| \cat -> tableCell [] <| text cat
              }
            , { header = tableCell [ Font.center, Font.bold ] <| text ""
              , width = fillPortion 1
              , view =
                    \cat ->
                        case cat of
                            Data data ->
                                tableCell
                                    [ Font.center
                                    ]
                                <|
                                    el
                                        [ pointer
                                        , mouseOver [ Font.color <| rgb 1 0 0 ]
                                        , centerX
                                        , onClick <| ClickedDelete Category data
                                        ]
                                    <|
                                        text "✘"

                            Input ->
                                Element.none
              }
            ]
        }


frontendLangsTable : Model -> List Site.FrontendLang -> Element.Element Msg
frontendLangsTable model frontendLangs =
    table [ centerX, Styles.borderShadow, width <| maximum 500 fill ]
        { data = (frontendLangs |> List.map (\flang -> Data flang)) ++ [ Input ]
        , columns =
            [ { header = tableCell [ Font.bold ] <| text "Frontend Languages"
              , width = fillPortion 8
              , view = frontendLangRow model <| \flang -> tableCell [] <| text flang
              }
            , { header = tableCell [ Font.center, Font.bold ] <| text ""
              , width = fillPortion 1
              , view =
                    \flang ->
                        case flang of
                            Data data ->
                                tableCell
                                    [ Font.center
                                    ]
                                <|
                                    el
                                        [ pointer
                                        , mouseOver [ Font.color <| rgb 1 0 0 ]
                                        , centerX
                                        , onClick <| ClickedDelete FrontendLang data
                                        ]
                                    <|
                                        text "✘"

                            Input ->
                                Element.none
              }
            ]
        }


type TableRow data
    = Data data
    | Input


categoryRow : Model -> (a -> Element.Element Msg) -> TableRow a -> Element.Element Msg
categoryRow model func row =
    case row of
        Data data ->
            func data

        Input ->
            tableCell [] <|
                Element.row [ width fill, spacing 50 ]
                    [ Input.text (Styles.inputStyle ++ [ onEnter (ClickedSubmit Category) ])
                        { onChange = Updated Category
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Category"
                        , text = model.category
                        , label = Input.labelHidden ""
                        }
                    , Styled.submitButtonWith []
                        { label = Element.text "Add"
                        , onPress = Just (ClickedSubmit Category)
                        , disabled = False
                        }
                    ]


frontendLangRow : Model -> (a -> Element.Element Msg) -> TableRow a -> Element.Element Msg
frontendLangRow model func row =
    case row of
        Data data ->
            func data

        Input ->
            tableCell [] <|
                Element.row [ width fill, spacing 50 ]
                    [ Input.text (Styles.inputStyle ++ [ onEnter (ClickedSubmit FrontendLang) ])
                        { onChange = Updated FrontendLang
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Language"
                        , text = model.frontendLang
                        , label = Input.labelHidden ""
                        }
                    , Styled.submitButtonWith []
                        { label = Element.text "Add"
                        , onPress = Just (ClickedSubmit FrontendLang)
                        , disabled = False
                        }
                    ]
