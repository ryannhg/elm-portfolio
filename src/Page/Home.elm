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
                [ Page.Content """
## Oh hey there!

That's right, I'm a geeky web boy. I love building things in Elm, and I'm
always trying to keep an eye out for a new language to stretch out my brain and make
me feel weird and insecure.

[Read my origin story](/about)

---


## My work.

I love building awesome websites in my free time. I've already made a couple
award-winning sites in my free time, and I've written about them so you can learn
more about them.

[Explore my work](/work)

---

## My latest thoughts.

In an attempt to share some of the neat stuff I've learned recently, I'm creating
a collection of articles on random tech topics.

You can browse the latest posts by checking it out

[Find something you like](/thoughts)

"""
                ]
    in
    { page_ | slug = Slug.fromString "" }
