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
        [ Page.Content """
## Denton Design
##### November 2018

![Nate's homepage, featuring a confident chicken](/images/dentondesign.jpg)

I had the pleasure of helping Nathan Denton build his brand new portfolio website
in late 2018. The design reflects his bold and fun personality in the form of chickens.

Built with __NuxtJS__ and hosted on __Netlify__, this site has already received
several awards:

- [CSS Winner - Site of the Day](https://www.csswinner.com/details/denton-design/13119)
- [Mindsparkle - Site of the Day](https://mindsparklemag.com/website/denton-design)
- [Awwards - Honorable Mention](https://www.awwwards.com/sites/denton-design)

You can check out the site here: [Denton Design](https://natedentondesign.com/)

---

## Lucky Day Gaming
##### May 2018

![Lucky Day Gaming homepage](/images/luckydaygaming.jpg)

Lucky Day Gaming was looking for a new site redesign, so my friend and I paired
with a great designer and UX strategist to provide a full site experience.

This site was built using __KeystoneJS__ and __NuxtJS__, and hosted on __Heroku__.
KeystoneJS allowed the client to create their own page templates and easily swap
out content when they had some new information to share!

Check out the full site here: [Lucky Day Gaming](https://www.luckydaygaming.com/)

---

## Michael Correy
##### January 2018

![Mike's homepage](/images/michaelcorrey.jpg)

Michael Correy is a talented art director and an overall awesome dude. I was able
to help him create and host his new portfolio site to showcase the excellent work
he has created during his career.

This site was built with __NuxtJS__ and hosted for free on __Netlify__.

The result was an award-winning mobile experience:

- [Awwwards - Mobile Site of the Week](https://www.awwwards.com/mobile-sites/michael-correy)

Check out Mike's site here: [Michael Correy](https://www.michaelcorrey.com)


"""
        ]
