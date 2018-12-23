module Page.Home exposing (page)

import Page
import Slug


page : Page.Page
page =
    let
        page_ : Page.Page
        page_ =
            Page.page
                "Ryan Haskell-Glatz"
                "a web developer."
                (Page.Image
                    "https://avatars2.githubusercontent.com/u/6187256"
                    "Ryan Haskell-Glatz"
                )
                1545542278411
                []
    in
    { page_ | slug = Slug.fromString "" }
