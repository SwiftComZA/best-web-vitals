module Evergreen.V3.Json.Auto.SpeedrunResult exposing (..)


type alias RootLighthouseResultCategoriesAccessibility =
    { score : Float
    }


type alias RootLighthouseResultCategoriesBestPractices =
    { score : Float
    }


type alias RootLighthouseResultCategoriesPerformance =
    { score : Float
    }


type alias RootLighthouseResultCategoriesSeo =
    { score : Float
    }


type alias RootLighthouseResultCategories =
    { accessibility : RootLighthouseResultCategoriesAccessibility
    , bestPractices : RootLighthouseResultCategoriesBestPractices
    , performance : RootLighthouseResultCategoriesPerformance
    , seo : RootLighthouseResultCategoriesSeo
    }


type alias RootLighthouseResult =
    { categories : RootLighthouseResultCategories
    , fetchTime : String
    , finalDisplayedUrl : String
    , finalUrl : String
    , lighthouseVersion : String
    , mainDocumentUrl : String
    , requestedUrl : String
    , userAgent : String
    }


type alias RootLoadingExperience =
    { initialUrl : String
    }


type alias Root =
    { captchaResult : String
    , id : String
    , kind : String
    , lighthouseResult : RootLighthouseResult
    , loadingExperience : RootLoadingExperience
    }
