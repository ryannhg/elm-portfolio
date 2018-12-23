module Page.Thoughts.YourFirstWebsite exposing (page)

import Page


page : Page.Page
page =
    Page.page
        "Your first website."
        "Coding isn't just for mega nerds. You can do this!"
        (Page.Image
            "https://images.unsplash.com/photo-1502900476531-ca62d0f2b679?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&q=80&w=1200"
            "Some coffee, a laptop with some code on it, and a plant."
        )
        1545542278411
        []
