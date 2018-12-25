module Page.NotFound exposing (page)

import Page
import Slug


page : Page.Page
page =
    Page.page
        "Not Found"
        "that link is a liar."
        (Page.Image
            "https://i.ytimg.com/vi/ZhPPjDb2ktE/maxresdefault.jpg"
            "Weird pirate dude, i dont even"
        )
        1545542278411
        []
