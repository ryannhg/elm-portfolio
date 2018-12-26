module Route exposing (Route(..), fromUrl, toString)

import Page exposing (Page)
import Url exposing (Url)
import Url.Parser exposing ((</>), (<?>), Parser, map, oneOf, s, string, top)
import Url.Parser.Query as Query


type Route
    = Home
    | About
    | Work
    | Thought (Maybe String)
    | ThoughtDetail String
    | NotFound


toString : Route -> String
toString route_ =
    case route_ of
        Home ->
            "/"

        About ->
            "/about"

        Work ->
            "/work"

        Thought tag ->
            case tag of
                Just tag_ ->
                    "/thoughts?tag=" ++ tag_

                Nothing ->
                    "/thoughts"

        ThoughtDetail slug ->
            "/thoughts/" ++ slug

        NotFound ->
            "/404"


fromUrl : Url -> Route
fromUrl =
    Url.Parser.parse
        (oneOf
            [ map Home top
            , map About (s "about")
            , map Work (s "work")
            , map Thought (s "thoughts" <?> Query.string "tag")
            , map ThoughtDetail (s "thoughts" </> string)
            ]
        )
        >> Maybe.withDefault NotFound
