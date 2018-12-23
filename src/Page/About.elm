module Page.About exposing (page)

import Page


page : Page.Page
page =
    Page.page
        "About"
        "i like coding things."
        (Page.Image
            "https://images.unsplash.com/photo-1533658280853-e4a10c25a30d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&q=80&w=1200"
            "A view of Chicago from Lake Michigan."
        )
        1545542563046
        []
