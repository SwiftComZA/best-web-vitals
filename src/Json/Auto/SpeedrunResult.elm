module Json.Auto.SpeedrunResult exposing (..)

import Json.Decode
import Json.Encode



-- Required packages:
-- * elm/json


type alias Root =
    { captchaResult : String
    , id : String
    , kind : String
    , lighthouseResult : RootLighthouseResult
    , loadingExperience : RootLoadingExperience
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


type alias RootLighthouseResultCategories =
    { accessibility : RootLighthouseResultCategoriesAccessibility
    , bestPractices : RootLighthouseResultCategoriesBestPractices
    , performance : RootLighthouseResultCategoriesPerformance
    , seo : RootLighthouseResultCategoriesSeo
    }


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


type alias RootLoadingExperience =
    { initialUrl : String
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder =
    Json.Decode.map5 Root
        (Json.Decode.field "captchaResult" Json.Decode.string)
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "kind" Json.Decode.string)
        (Json.Decode.field "lighthouseResult" rootLighthouseResultDecoder)
        (Json.Decode.field "loadingExperience" rootLoadingExperienceDecoder)


rootLighthouseResultDecoder : Json.Decode.Decoder RootLighthouseResult
rootLighthouseResultDecoder =
    Json.Decode.map8 RootLighthouseResult
        (Json.Decode.field "categories" rootLighthouseResultCategoriesDecoder)
        (Json.Decode.field "fetchTime" Json.Decode.string)
        (Json.Decode.field "finalDisplayedUrl" Json.Decode.string)
        (Json.Decode.field "finalUrl" Json.Decode.string)
        (Json.Decode.field "lighthouseVersion" Json.Decode.string)
        (Json.Decode.field "mainDocumentUrl" Json.Decode.string)
        (Json.Decode.field "requestedUrl" Json.Decode.string)
        (Json.Decode.field "userAgent" Json.Decode.string)


rootLighthouseResultCategoriesDecoder : Json.Decode.Decoder RootLighthouseResultCategories
rootLighthouseResultCategoriesDecoder =
    Json.Decode.map4 RootLighthouseResultCategories
        (Json.Decode.field "accessibility" rootLighthouseResultCategoriesAccessibilityDecoder)
        (Json.Decode.field "best-practices" rootLighthouseResultCategoriesBestPracticesDecoder)
        (Json.Decode.field "performance" rootLighthouseResultCategoriesPerformanceDecoder)
        (Json.Decode.field "seo" rootLighthouseResultCategoriesSeoDecoder)


rootLighthouseResultCategoriesAccessibilityDecoder : Json.Decode.Decoder RootLighthouseResultCategoriesAccessibility
rootLighthouseResultCategoriesAccessibilityDecoder =
    Json.Decode.map RootLighthouseResultCategoriesAccessibility
        (Json.Decode.field "score" Json.Decode.float)


rootLighthouseResultCategoriesBestPracticesDecoder : Json.Decode.Decoder RootLighthouseResultCategoriesBestPractices
rootLighthouseResultCategoriesBestPracticesDecoder =
    Json.Decode.map RootLighthouseResultCategoriesBestPractices
        (Json.Decode.field "score" Json.Decode.float)


rootLighthouseResultCategoriesPerformanceDecoder : Json.Decode.Decoder RootLighthouseResultCategoriesPerformance
rootLighthouseResultCategoriesPerformanceDecoder =
    Json.Decode.map RootLighthouseResultCategoriesPerformance
        (Json.Decode.field "score" Json.Decode.float)


rootLighthouseResultCategoriesSeoDecoder : Json.Decode.Decoder RootLighthouseResultCategoriesSeo
rootLighthouseResultCategoriesSeoDecoder =
    Json.Decode.map RootLighthouseResultCategoriesSeo
        (Json.Decode.field "score" Json.Decode.float)


rootLoadingExperienceDecoder : Json.Decode.Decoder RootLoadingExperience
rootLoadingExperienceDecoder =
    Json.Decode.map RootLoadingExperience
        (Json.Decode.field "initial_url" Json.Decode.string)


encodedRoot : Root -> Json.Encode.Value
encodedRoot root =
    Json.Encode.object
        [ ( "captchaResult", Json.Encode.string root.captchaResult )
        , ( "id", Json.Encode.string root.id )
        , ( "kind", Json.Encode.string root.kind )
        , ( "lighthouseResult", encodedRootLighthouseResult root.lighthouseResult )
        , ( "loadingExperience", encodedRootLoadingExperience root.loadingExperience )
        ]


encodedRootLighthouseResult : RootLighthouseResult -> Json.Encode.Value
encodedRootLighthouseResult rootLighthouseResult =
    Json.Encode.object
        [ ( "categories", encodedRootLighthouseResultCategories rootLighthouseResult.categories )
        , ( "fetchTime", Json.Encode.string rootLighthouseResult.fetchTime )
        , ( "finalDisplayedUrl", Json.Encode.string rootLighthouseResult.finalDisplayedUrl )
        , ( "finalUrl", Json.Encode.string rootLighthouseResult.finalUrl )
        , ( "lighthouseVersion", Json.Encode.string rootLighthouseResult.lighthouseVersion )
        , ( "mainDocumentUrl", Json.Encode.string rootLighthouseResult.mainDocumentUrl )
        , ( "requestedUrl", Json.Encode.string rootLighthouseResult.requestedUrl )
        , ( "userAgent", Json.Encode.string rootLighthouseResult.userAgent )
        ]


encodedRootLighthouseResultCategories : RootLighthouseResultCategories -> Json.Encode.Value
encodedRootLighthouseResultCategories rootLighthouseResultCategories =
    Json.Encode.object
        [ ( "accessibility", encodedRootLighthouseResultCategoriesAccessibility rootLighthouseResultCategories.accessibility )
        , ( "best-practices", encodedRootLighthouseResultCategoriesBestPractices rootLighthouseResultCategories.bestPractices )
        , ( "performance", encodedRootLighthouseResultCategoriesPerformance rootLighthouseResultCategories.performance )
        , ( "seo", encodedRootLighthouseResultCategoriesSeo rootLighthouseResultCategories.seo )
        ]


encodedRootLighthouseResultCategoriesAccessibility : RootLighthouseResultCategoriesAccessibility -> Json.Encode.Value
encodedRootLighthouseResultCategoriesAccessibility rootLighthouseResultCategoriesAccessibility =
    Json.Encode.object
        [ ( "score", Json.Encode.float rootLighthouseResultCategoriesAccessibility.score )
        ]


encodedRootLighthouseResultCategoriesBestPractices : RootLighthouseResultCategoriesBestPractices -> Json.Encode.Value
encodedRootLighthouseResultCategoriesBestPractices rootLighthouseResultCategoriesBestPractices =
    Json.Encode.object
        [ ( "score", Json.Encode.float rootLighthouseResultCategoriesBestPractices.score )
        ]


encodedRootLighthouseResultCategoriesPerformance : RootLighthouseResultCategoriesPerformance -> Json.Encode.Value
encodedRootLighthouseResultCategoriesPerformance rootLighthouseResultCategoriesPerformance =
    Json.Encode.object
        [ ( "score", Json.Encode.float rootLighthouseResultCategoriesPerformance.score )
        ]


encodedRootLighthouseResultCategoriesSeo : RootLighthouseResultCategoriesSeo -> Json.Encode.Value
encodedRootLighthouseResultCategoriesSeo rootLighthouseResultCategoriesSeo =
    Json.Encode.object
        [ ( "score", Json.Encode.float rootLighthouseResultCategoriesSeo.score )
        ]


encodedRootLoadingExperience : RootLoadingExperience -> Json.Encode.Value
encodedRootLoadingExperience rootLoadingExperience =
    Json.Encode.object
        [ ( "initial_url", Json.Encode.string rootLoadingExperience.initialUrl )
        ]
