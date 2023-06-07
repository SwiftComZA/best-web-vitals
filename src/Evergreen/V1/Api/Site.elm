module Evergreen.V1.Api.Site exposing (..)


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
    { url : String
    , mobileScore : Score
    , desktopScore : Score
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


type ScoreDevice
    = Mobile
    | Desktop
