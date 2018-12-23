module Main exposing (main)

import Css exposing (..)
import Css.Global exposing (body, each, global, html, id, typeSelector)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (class, css, href, placeholder, type_)


semibold =
    int 600


colors =
    { white = hex "ffffff"
    , lightGray = hex "eaebed"
    , orange = hex "f46036"
    , blue = hex "006989"
    , lightBlue = hex "2b9eb3"
    , dark = hex "333333"
    , transparent = rgba 0 0 0 0
    }


main =
    toUnstyled (div [] [ globalStyles, view ])


globalStyles =
    global
        [ body
            [ height (pct 100)
            , margin zero
            ]
        , html
            [ height (pct 100)
            , fontSize (px 20)
            ]
        , each
            [ typeSelector "a"
            , typeSelector "button"
            , typeSelector "input"
            ]
            [ lineHeight (int 1)
            , margin zero
            , border zero
            , backgroundColor colors.transparent
            , fontSize inherit
            , fontFamily inherit
            , textAlign left
            , textDecoration none
            , color inherit
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


type Tag
    = Elm
    | Web
    | Functional
    | Javascript
    | ES6


type alias TagInfo =
    { slug : String
    , relatedTags : List Tag
    }


relatedTags : List ( Tag, Tag )
relatedTags =
    [ ( Javascript, Web )
    , ( Elm, Web )
    , ( Elm, Functional )
    , ( Javascript, ES6 )
    ]


relatedTagsFor : Tag -> List Tag
relatedTagsFor tag =
    relatedTags
        |> List.filterMap
            (\( left, right ) ->
                if left == tag then
                    Just right

                else if right == tag then
                    Just left

                else
                    Nothing
            )


tagInfo : Tag -> TagInfo
tagInfo tag =
    relatedTagsFor tag
        |> (case tag of
                Elm ->
                    TagInfo "elm"

                Javascript ->
                    TagInfo "javascript"

                Web ->
                    TagInfo "web"

                Functional ->
                    TagInfo "functional"

                ES6 ->
                    TagInfo "es6"
           )


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
    "/thoughts/" ++ slug post.title


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
            , backgroundColor colors.orange
            , color colors.white
            , zIndex (int 2)
            ]
        ]
        [ div [ css [ padding (rem 1), displayFlex, justifyContent spaceBetween ] ]
            [ a
                [ href "/"
                , css
                    [ fontWeight semibold
                    ]
                ]
                [ text "Ryan." ]
            , nav [ css [ displayFlex ] ] <|
                List.map
                    (\( label, url ) ->
                        a
                            [ href url
                            , css
                                [ marginRight (rem 1)
                                , lastChild [ marginRight zero ]
                                ]
                            ]
                            [ text label
                            ]
                    )
                    [ ( "work", "/work" )
                    , ( "thoughts", "/thoughts" )
                    , ( "about", "/about" )
                    ]
            ]
        ]


myFooter =
    footer
        [ css
            [ position fixed
            , bottom zero
            , left zero
            , right zero
            , zIndex (int 0)
            , backgroundColor colors.orange
            , color colors.white
            ]
        ]
        [ div
            [ css
                [ padding (rem 1)
                , displayFlex
                , alignItems center
                , justifyContent spaceBetween
                ]
            ]
            [ text "Stay Connected"
            , nav [ css [ displayFlex ] ] <|
                List.map
                    (\( icon, url ) ->
                        a
                            [ href url
                            , Attr.target "_blank"
                            , css
                                [ marginRight (rem 1)
                                , lastChild [ marginRight zero ]
                                ]
                            ]
                            [ span [ class ("fa fa-" ++ icon) ] []
                            ]
                    )
                    [ ( "twitter", "https://www.twitter.com/ryan_nhg" )
                    , ( "github", "https://www.github.com/ryannhg" )
                    ]
            ]
        ]


hero =
    section
        [ css
            [ padding2 (rem 6) zero
            , color colors.white
            , backgroundColor colors.orange
            , position relative
            , zIndex (int 3)
            , before
                [ property "content" "''"
                , position absolute
                , zIndex (int -1)
                , top zero
                , left zero
                , right zero
                , bottom zero
                , opacity (num 0.2)
                , backgroundImage (url "https://avatars2.githubusercontent.com/u/6187256")
                , backgroundPosition center
                , backgroundSize cover

                -- TODO: On desktop , backgroundAttachment fixed
                ]
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
                , padding2 zero (rem 1)
                , boxSizing borderBox
                , width (pct 100)
                , maxWidth (px 360)
                ]
            ]
            [ form
                [ css
                    [ boxShadow4 zero (rem 0.5) (rem 1.5) (rgba 0 0 0 0.25)
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
                        , padding2 (rem 0.75) (rem 1)
                        , border zero
                        , backgroundColor colors.white
                        , width (pct 100)
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
                        , textAlign center
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
            [ padding2 (rem 4) (rem 1)
            ]
        ]
        [ h3
            [ css
                [ fontSize (rem 1.75)
                , fontWeight semibold
                , textAlign center
                ]
            ]
            [ text "Latest thoughts" ]
        , div
            [ css [ marginTop (rem 2) ] ]
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
                [ display inlineBlock
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
                        [ href ("/thoughts?tag=" ++ slug tag)
                        , css
                            [ display inlineBlock
                            , textDecoration none
                            , fontSize (px 14)
                            , padding2 (px 2) (px 12)
                            , borderRadius (px 12)
                            , backgroundColor colors.blue
                            , color colors.white
                            , lineHeight (num 1.4)
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
