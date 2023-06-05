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


type SiteScoreType
    = Mobile
    | Desktop
