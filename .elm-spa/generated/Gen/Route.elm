module Gen.Route exposing
    ( Route(..)
    , fromUrl
    , toHref
    )

import Gen.Params.AddSite
import Gen.Params.Admin
import Gen.Params.Home_
import Gen.Params.NotFound
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = AddSite
    | Admin
    | Home_
    | NotFound


fromUrl : Url -> Route
fromUrl =
    Parser.parse (Parser.oneOf routes) >> Maybe.withDefault NotFound


routes : List (Parser (Route -> a) a)
routes =
    [ Parser.map Home_ Gen.Params.Home_.parser
    , Parser.map AddSite Gen.Params.AddSite.parser
    , Parser.map Admin Gen.Params.Admin.parser
    , Parser.map NotFound Gen.Params.NotFound.parser
    ]


toHref : Route -> String
toHref route =
    let
        joinAsHref : List String -> String
        joinAsHref segments =
            "/" ++ String.join "/" segments
    in
    case route of
        AddSite ->
            joinAsHref [ "add-site" ]
    
        Admin ->
            joinAsHref [ "admin" ]
    
        Home_ ->
            joinAsHref []
    
        NotFound ->
            joinAsHref [ "not-found" ]

