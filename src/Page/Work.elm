module Page.Work exposing (page)

import Page


page : Page.Page
page =
    Page.page
        "Work"
        "projects and other fun stuff."
        (Page.Image
            "https://images.unsplash.com/photo-1522542550221-31fd19575a2d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&q=80&w=1200"
            "Some sketched-out site designs"
        )
        1545542278411
        []
