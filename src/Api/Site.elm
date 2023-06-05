module Api.Site exposing (..)


type alias Site =
    { url : String
    , mobileScore : Score
    , desktopScore : Score
    }


type alias ScoreValue =
    { performance : Float
    , accessibility : Float
    , bestPractices : Float
    , seo : Float
    }


type SiteScoreType
    = Mobile
    | Desktop


type Score
    = Failed
    | Pending
    | Success ScoreValue
