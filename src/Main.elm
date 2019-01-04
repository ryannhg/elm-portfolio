port module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Css exposing (..)
import Css.Global
    exposing
        ( body
        , children
        , each
        , global
        , html
        , id
        , typeSelector
        )
import Html
import Html.Attributes
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
    exposing
        ( class
        , css
        , href
        , placeholder
        , type_
        )
import Markdown
import Page exposing (Page, Section(..))
import Page.About
import Page.Home
import Page.NotFound
import Page.Thoughts
import Page.Thoughts.CurryingInJS
import Page.Thoughts.ElmExpressJS
import Page.Work
import Route exposing (Route(..))
import Url exposing (Url)


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


type alias Flags =
    ()


type alias Model =
    { route : Route
    , key : Key
    }


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest


port outgoing : String -> Cmd msg


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model
        (Route.fromUrl url)
        key
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlChange url ->
            ( { model | route = Route.fromUrl url }
            , outgoing "URL_CHANGE"
            )

        OnUrlRequest urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , outgoing url
                    )


view : Model -> Document Msg
view model =
    let
        page : Page
        page =
            case model.route of
                Home ->
                    Page.Home.page

                About ->
                    Page.About.page

                Work ->
                    Page.Work.page

                Thought tag ->
                    Page.Thoughts.page

                ThoughtDetail slug_ ->
                    case slug_ of
                        "currying-in-js" ->
                            Page.Thoughts.CurryingInJS.page

                        "elm-expressjs" ->
                            Page.Thoughts.ElmExpressJS.page

                        _ ->
                            Page.NotFound.page

                NotFound ->
                    Page.NotFound.page
    in
    { title = page.title
    , body =
        List.map toUnstyled
            [ globalStyles
            , viewPage page
            ]
    }


globalStyles =
    global
        [ body
            [ height (pct 100)
            , margin zero
            ]
        , html
            [ height (pct 100)
            , fontSize (px 20)
            , fontWeight (num 300)
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
        , Css.Global.class "rich-text"
            [ padding2 (rem 4) (rem 1)
            , boxSizing borderBox
            , margin2 zero auto
            , width (pct 100)
            , maxWidth (rem 30)
            , children
                [ typeSelector "*"
                    [ marginTop (rem 1)
                    , firstChild
                        [ marginTop zero
                        ]
                    ]
                , typeSelector "hr"
                    [ margin2 (rem 1) zero
                    , border zero
                    ]
                , typeSelector "h1"
                    [ fontWeight semibold
                    , marginTop (rem 2)
                    , fontSize (rem 2)
                    ]
                , typeSelector "h2"
                    [ fontWeight semibold
                    , marginTop (rem 2)
                    , fontSize (rem 2)
                    ]
                , typeSelector "h3"
                    [ fontWeight semibold
                    , fontSize (rem 1.5)
                    ]
                , typeSelector "h4"
                    [ fontWeight semibold
                    , fontSize (rem 1.25)
                    ]
                , typeSelector "h5"
                    [ fontWeight semibold
                    , fontSize (rem 1)
                    ]
                , typeSelector "h6"
                    [ fontWeight semibold
                    , fontSize (rem 1)
                    , marginTop (rem 0.5)
                    ]
                , each
                    [ typeSelector "p"
                    , typeSelector "ol"
                    , typeSelector "ul"
                    ]
                    [ lineHeight (num 1.3)
                    ]
                , each
                    [ typeSelector "ol"
                    , typeSelector "ul"
                    ]
                    [ padding zero
                    , paddingLeft (rem 1)
                    ]
                , typeSelector "pre"
                    [ width (calc (pct 100) plus (rem 2))
                    , margin2 (rem 1) (rem -1)
                    , overflowX auto
                    , fontSize (px 18)
                    , lineHeight (num 1.4)
                    , children
                        [ typeSelector "code"
                            [ padding (rem 1)
                            , fontSize (px 16)
                            ]
                        ]
                    ]
                ]
            , Css.Global.descendants
                [ typeSelector "a"
                    [ color colors.orange
                    , textDecoration underline
                    , fontWeight semibold
                    ]
                , typeSelector "li"
                    [ marginTop (rem 0.5)
                    ]
                , typeSelector "img"
                    [ maxWidth (pct 100)
                    , display block
                    , margin2 zero auto
                    ]
                , typeSelector "code"
                    [ fontSize (px 18)
                    ]
                ]
            ]
        ]


type alias Post =
    { title : String
    , date : String
    , tags : List String
    }


posts : List Post
posts =
    []


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


viewPage page =
    div [ css [ position relative ] ]
        [ navbar
        , hero page.title page.description page.image.src
        , div
            [ css
                [ position relative
                , zIndex (int 1)
                , marginBottom (rem 4)
                , backgroundColor colors.white
                ]
            ]
            (List.map viewSection page.sections)
        , myFooter
        ]


navbar =
    header []
        [ div
            [ css
                [ backgroundColor colors.orange
                , position fixed
                , top zero
                , left zero
                , right zero
                , height (px 60)
                , zIndex (int 2)
                ]
            ]
            []
        , div
            [ css
                [ position fixed
                , top zero
                , left zero
                , right zero
                , zIndex (int 5)
                , padding (rem 1)
                , color colors.white
                ]
            ]
            [ div
                [ css
                    [ displayFlex
                    , justifyContent spaceBetween
                    , maxWidth (px 960)
                    , width (pct 100)
                    , margin2 zero auto
                    , boxSizing borderBox
                    ]
                ]
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
        ]


searchbar =
    div
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
                    , width (px 60)
                    , backgroundColor colors.white
                    , textAlign center
                    ]
                ]
                [ span [ class "fa fa-search" ] []
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
                , justifyContent center
                ]
            ]
            [ text ""
            , nav [ css [ displayFlex, fontSize (rem 1.5) ] ] <|
                List.map
                    (\( icon, url ) ->
                        a
                            [ href url
                            , Attr.target "_blank"
                            , Attr.rel "noopener"
                            , Attr.attribute "aria-label" icon
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


hero title description image =
    section
        [ css
            [ padding2 (rem 6) (rem 1)
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
                , backgroundImage (url image)
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
            [ text title
            ]
        , h2
            [ css
                [ fontSize (rem 1.5)
                , lineHeight (num 1.1)
                , textAlign center
                , paddingTop (rem 0.5)
                , maxWidth (rem 30)
                , margin2 zero auto
                ]
            ]
            [ text description ]

        -- , searchbar
        ]


viewSection : Section -> Html Msg
viewSection section =
    case section of
        Content markdown ->
            fromUnstyled <|
                Markdown.toHtml
                    [ Html.Attributes.class "rich-text" ]
                    markdown

        LatestPosts ->
            latestPosts


latestPosts =
    section
        [ css
            [ padding2 (rem 4) (rem 1)
            , position relative
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
