module Page.Thoughts exposing (page)

import Page


page : Page.Page
page =
    Page.page
        "Thoughts"
        "ideas from my very stable brain."
        (Page.Image
            "https://images.unsplash.com/photo-1519419166318-4f5c601b8e6c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&q=80&w=1200"
            "A notepad, glasses, and a pencil."
        )
        1545542278411
        [ Page.Content """
## Latest posts
---

### [Elm ExpressJS](/thoughts/elm-expressjs)
###### December 2018

Using Elm's ports to make a web server!

---

### [Currying in JS](/thoughts/currying-in-js)
###### December 2018

When your functions return other functions, you can do some pretty neat stuff.

"""
        ]


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
