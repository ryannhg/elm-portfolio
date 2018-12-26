port module Generator exposing (main)

-- Pages

import Json.Decode as D
import Json.Encode as E
import Page exposing (Page)
import Page.About
import Page.Home
import Page.Thoughts
import Page.Thoughts.YourFirstWebsite
import Page.Work
import Platform
import Slug


pages : List PageInfo
pages =
    [ pageInfo Page.Home.page
        [ pageInfo Page.About.page []
        , pageInfo Page.Thoughts.page
            [ pageInfo Page.Thoughts.YourFirstWebsite.page []
            ]
        , pageInfo Page.Work.page
            []
        ]
    ]



-- Actual program


type alias Flags =
    ()


type alias Model =
    ()


type Msg
    = Msg


type PageInfo
    = PageInfo
        { title : String
        , slug : String
        , description : String
        , image : String
        , children : List PageInfo
        }


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


port outgoing : E.Value -> Cmd msg


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( ()
    , outgoing (encodePages pages)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


pageInfo : Page -> List PageInfo -> PageInfo
pageInfo { title, slug, description, image } children =
    PageInfo
        { title = title
        , slug = Slug.toString slug
        , description = description
        , image = image.src
        , children = children
        }


encodePages : List PageInfo -> E.Value
encodePages =
    E.list encodePage


encodePage : PageInfo -> E.Value
encodePage (PageInfo page) =
    E.object
        [ ( "title", E.string page.title )
        , ( "slug", E.string page.slug )
        , ( "description", E.string page.description )
        , ( "image", E.string page.image )
        , ( "children", E.list encodePage page.children )
        ]
