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

My name's Ryan, and I build things for the web. I _really_ love building things
in Elm, and I'm always trying learn new things that stretch out my brain and
make me feel weird and insecure.

[Read my origin story](/about)

---


## My work.

My friends and I create awesome websites. I've already been able to make a few
award-winning sites in my free time, and I've written about them so you can learn
check them out if you'd like.

[Explore my work](/work)

---

## My latest thoughts.

In an attempt to share some of the neat stuff I've learned recently, I'm creating
a collection of articles on random tech topics. I'm interested in a lot,
so the content covers a wide variety of things.

[Find something you like](/thoughts)

"""
                ]
    in
    { page_ | slug = Slug.fromString "" }
