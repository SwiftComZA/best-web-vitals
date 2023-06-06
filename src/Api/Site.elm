module Api.Site exposing (..)


type alias Site =
    { url : String
    , mobileScore : Score
    , desktopScore : Score
    }


type Score
    = Failed
    | Pending
    | Success ScoreValue


type alias ScoreValue =
    { performance : Float
    , accessibility : Float
    , bestPractices : Float
    , seo : Float
    }


type ScoreDevice
    = Mobile
    | Desktop


type Sort
    = Domain
    | Category
    | FrontendLang
    | MobileScore ScoreType
    | DesktopScore ScoreType


type ScoreType
    = Perf
    | A11y
    | BP
    | SEO


type Direction
    = Asc
    | Desc


sort : ( Sort, Direction ) -> List Site -> List Site
sort ( sorting, direction ) sites =
    let
        sorted =
            sites |> List.sortBy (sortingFunction sorting)
    in
    case direction of
        Asc ->
            sorted

        Desc ->
            sorted |> List.reverse


sortingFunction : Sort -> Site -> ( String, Float )
sortingFunction sorting =
    case sorting of
        Domain ->
            \site -> ( site.url, 0.0 )

        Category ->
            \site -> ( site.url, 0.0 )

        FrontendLang ->
            \site -> ( site.url, 0.0 )

        MobileScore type_ ->
            case type_ of
                Perf ->
                    \site ->
                        case site.mobileScore of
                            Success val ->
                                ( "", val.performance )

                            _ ->
                                ( "", 0.0 )

                A11y ->
                    \site ->
                        case site.mobileScore of
                            Success val ->
                                ( "", val.accessibility )

                            _ ->
                                ( "", 0.0 )

                BP ->
                    \site ->
                        case site.mobileScore of
                            Success val ->
                                ( "", val.bestPractices )

                            _ ->
                                ( "", 0.0 )

                SEO ->
                    \site ->
                        case site.mobileScore of
                            Success val ->
                                ( "", val.seo )

                            _ ->
                                ( "", 0.0 )

        DesktopScore type_ ->
            case type_ of
                Perf ->
                    \site ->
                        case site.desktopScore of
                            Success val ->
                                ( "", val.performance )

                            _ ->
                                ( "", 0.0 )

                A11y ->
                    \site ->
                        case site.desktopScore of
                            Success val ->
                                ( "", val.accessibility )

                            _ ->
                                ( "", 0.0 )

                BP ->
                    \site ->
                        case site.desktopScore of
                            Success val ->
                                ( "", val.bestPractices )

                            _ ->
                                ( "", 0.0 )

                SEO ->
                    \site ->
                        case site.desktopScore of
                            Success val ->
                                ( "", val.seo )

                            _ ->
                                ( "", 0.0 )
