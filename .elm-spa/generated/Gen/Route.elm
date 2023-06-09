module Gen.Route exposing
    ( Route(..)
    , fromUrl
    , toHref
    )

import Gen.Params.AddSite
import Gen.Params.Admin
import Gen.Params.Home_
import Gen.Params.Login
import Gen.Params.NotFound
import Gen.Params.Register
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = AddSite
    | Admin
    | Home_
    | Login
    | NotFound
    | Register


fromUrl : Url -> Route
fromUrl =
    Parser.parse (Parser.oneOf routes) >> Maybe.withDefault NotFound


routes : List (Parser (Route -> a) a)
routes =
    [ Parser.map Home_ Gen.Params.Home_.parser
    , Parser.map AddSite Gen.Params.AddSite.parser
    , Parser.map Admin Gen.Params.Admin.parser
    , Parser.map Login Gen.Params.Login.parser
    , Parser.map NotFound Gen.Params.NotFound.parser
    , Parser.map Register Gen.Params.Register.parser
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
    
        Login ->
            joinAsHref [ "login" ]
    
        NotFound ->
            joinAsHref [ "not-found" ]
    
        Register ->
            joinAsHref [ "register" ]

