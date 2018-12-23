module Page exposing
    ( Markdown
    , Page
    , Section
    , Image
    , page
    )

import Slug exposing (Slug)
import Time


type alias Page =
    { title : String
    , slug : Slug
    , description : String
    , image : Image
    , date : Time.Posix
    , sections : List Section
    }


page : String -> String -> Image -> Int -> List Section -> Page
page title description image milliseconds sections =
    Page
        title
        (Slug.fromString title)
        description
        image
        (Time.millisToPosix milliseconds)
        sections


type alias Markdown =
    String


type alias Image =
    { src : String
    , alt : String
    }


type Section
    = Hero
    | Content Markdown
