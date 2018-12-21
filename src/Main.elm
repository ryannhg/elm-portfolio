module Main exposing (main)

import Css exposing (..)
import Css.Global exposing (body, each, global, html, id, typeSelector)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css, href, placeholder, type_)


semibold =
    int 600


colors =
    { white = hex "ffffff"
    , lightGray = hex "eaebed"
    , orange = hex "f46036"
    , blue = hex "006989"
    , lightBlue = hex "2b9eb3"
    , dark = hex "333333"
    }


main =
    toUnstyled (div [] [ globalStyles, view ])


globalStyles =
    global
        [ body
            [ height (pct 100)
            , fontFamilies [ "Source Sans Pro" ]
            , margin zero
            ]
        , html
            [ height (pct 100)
            , fontSize (px 20)
            ]
        , each
            [ typeSelector "h1"
            , typeSelector "h2"
            , typeSelector "h3"
            , typeSelector "h4"
            , typeSelector "h5"
            , typeSelector "h6"
            , typeSelector "p"
            ]
            [ margin zero
            , fontWeight (int 300)
            , fontSize (rem 1)
            ]
        ]


type alias Post =
    { title : String
    , date : String
    , tags : List String
    }


posts : List Post
posts =
    [ Post "Elm is dope!"
        "December 2018"
        [ "elm", "web", "functional" ]
    , Post "Clojure is dope!"
        "November 2018"
        [ "clojure", "functional", "simple", "functional", "simple", "functional", "simple", "functional", "simple" ]
    , Post "Docker is dope!"
        "October 2018"
        [ "docker", "containers", "whales" ]
    , Post "Clojure is dope!"
        "November 2018"
        [ "clojure", "functional", "simple" ]
    , Post "Docker is dope!"
        "October 2018"
        [ "docker", "containers", "whales" ]
    ]


link : Post -> String
link post =
    "/posts/" ++ slug post.title


slug : String -> String
slug =
    String.toLower
        >> replaceSpacesWithDashes
        >> keepOnlyAlphaNums


replaceSpacesWithDashes : String -> String
replaceSpacesWithDashes =
    String.words >> String.join "-"


keepOnlyAlphaNums : String -> String
keepOnlyAlphaNums =
    String.toList
        >> List.filter (\char -> char == '-' || Char.isAlphaNum char)
        >> String.fromList


view =
    div [ css [ position relative ] ]
        [ navbar
        , hero
        , div
            [ css
                [ position relative
                , zIndex (int 1)
                , marginBottom (rem 3)
                , backgroundColor colors.white
                ]
            ]
            [ latestPosts ]
        , myFooter
        ]


navbar =
    header
        [ css
            [ position fixed
            , top zero
            , left zero
            , right zero
            , padding (rem 1)
            , backgroundColor colors.orange
            , color colors.white
            , zIndex (int 2)
            ]
        ]
        [ text "Navbar"
        ]


myFooter =
    footer
        [ css
            [ position fixed
            , bottom zero
            , left zero
            , right zero
            , zIndex (int 0)
            , backgroundColor colors.blue
            , color colors.white
            , padding (rem 1)
            ]
        ]
        [ text "Copyright 2018" ]


hero =
    section
        [ css
            [ padding2 (rem 6) zero
            , color colors.dark
            , backgroundColor colors.lightGray
            , position relative
            , zIndex (int 3)
            ]
        ]
        [ h1
            [ css
                [ fontWeight semibold
                , fontSize (rem 2)
                , textAlign center
                ]
            ]
            [ text "Ryan Haskell-Glatz"
            ]
        , h2
            [ css
                [ fontSize (rem 1.5)
                , textAlign center
                ]
            ]
            [ text "a web developer." ]
        , div
            [ css
                [ position absolute
                , bottom zero
                , left (pct 50)
                , transform (translate2 (pct -50) (pct 50))
                ]
            ]
            [ form
                [ css
                    [ boxShadow4 zero (rem 0.5) (rem 1) (rgba 0 0 0 0.25)
                    , backgroundColor colors.white
                    , displayFlex
                    , borderRadius (px 4)
                    , borderColor colors.lightGray
                    , overflow hidden
                    , margin zero
                    ]
                ]
                [ input
                    [ type_ "search"
                    , placeholder "Search by topic..."
                    , css
                        [ fontFamily inherit
                        , property "-webkit-appearance" "none"
                        , fontSize inherit
                        , padding2 (rem 0.5) (rem 1)
                        , border zero
                        , backgroundColor colors.white
                        ]
                    ]
                    []
                , button
                    [ css
                        [ fontFamily inherit
                        , fontSize inherit
                        , color (rgba 0 0 0 0.25)
                        , padding zero
                        , border zero
                        , width (px 50)
                        , backgroundColor colors.white
                        ]
                    ]
                    [ span [ class "fa fa-search" ] []
                    ]
                ]
            ]
        ]


latestPosts =
    section
        [ css
            [ padding2 (rem 3) (rem 1)
            ]
        ]
        [ h3
            [ css
                [ fontSize (rem 1.5)
                , fontWeight semibold
                , marginBottom (px 32)
                ]
            ]
            [ text "Latest posts" ]
        , div
            [ css
                []
            ]
            (List.map viewPost posts)
        ]


viewPost : Post -> Html msg
viewPost post =
    div
        [ css
            [ marginBottom (px 32)
            , lastChild [ marginBottom zero ]
            ]
        ]
        [ a
            [ css
                [ display block
                , color inherit
                , textDecoration none
                , fontSize (rem 1.25)
                , fontWeight semibold
                , color colors.orange
                ]
            , href (link post)
            ]
            [ text post.title ]
        , p
            [ css [ fontSize (px 18) ]
            ]
            [ text post.date ]
        , div
            [ css
                [ displayFlex
                , flexWrap wrap
                , marginTop (px 16)
                , marginBottom (px -8)
                ]
            ]
            (List.map
                (\tag ->
                    a
                        [ href ("/posts?tag=" ++ slug tag)
                        , css
                            [ display inlineBlock
                            , textDecoration none
                            , fontSize (px 14)
                            , padding2 (px 2) (px 12)
                            , borderRadius (px 12)
                            , backgroundColor colors.lightBlue
                            , color colors.white
                            , marginRight (px 8)
                            , marginBottom (px 8)
                            , lastChild [ marginRight zero ]
                            ]
                        ]
                        [ text tag ]
                )
                post.tags
            )
        ]
