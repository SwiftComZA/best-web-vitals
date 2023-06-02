module Gen.Route exposing
    ( Route(..)
    , fromUrl
    , toHref
    )

import Gen.Params.AddListing
import Gen.Params.Admin
import Gen.Params.Home_
import Gen.Params.NotFound
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = AddListing
    | Admin
    | Home_
    | NotFound


fromUrl : Url -> Route
fromUrl =
    Parser.parse (Parser.oneOf routes) >> Maybe.withDefault NotFound


routes : List (Parser (Route -> a) a)
routes =
    [ Parser.map Home_ Gen.Params.Home_.parser
    , Parser.map AddListing Gen.Params.AddListing.parser
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
        AddListing ->
            joinAsHref [ "add-listing" ]
    
        Admin ->
            joinAsHref [ "admin" ]
    
        Home_ ->
            joinAsHref []
    
        NotFound ->
            joinAsHref [ "not-found" ]

