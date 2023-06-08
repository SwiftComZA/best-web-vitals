module Evergreen.V1.Api.Site exposing (..)


type alias Url =
    String


type alias ScoreValue =
    { performance : Float
    , accessibility : Float
    , bestPractices : Float
    , seo : Float
    }


type Score
    = Failed
    | Pending
    | Success ScoreValue


type alias Site =
    { url : Url
    , mobileScore : Score
    , desktopScore : Score
    , category : String
    , frontendLang : String
    }


type ScoreType
    = Perf
    | A11y
    | BP
    | SEO


type Sort
    = Domain
    | Category
    | FrontendLang
    | MobileScore ScoreType
    | DesktopScore ScoreType


type Direction
    = Asc
    | Desc


type alias Category =
    String


type alias FrontendLang =
    String


type ScoreDevice
    = Mobile
    | Desktop
