module Page.Thoughts.ElmExpressJSPartThree exposing (page)

import Page
import Slug


page : Page.Page
page =
    Page.page
        "Elm ExpressJS: Part Three"
        "Make HTML, not war."
        (Page.Image
            "https://images.unsplash.com/photo-1543450251-7c0d0512be8a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&q=80&w=1200"
            "Some ports on the water."
        )
        1547929735518
        [ Page.Content """
## This is a series, man!

If you haven't read [part one](/thoughts/elm-expressjs) or
[part two](/thoughts/elm-expressjs-part-two) yet, the context might be helpful.

Also, this is going to use a slight variation on Elm's normal `Html` module. If
you want to read more about why / how that is, I'll be sure to write about it in
another blog post.

## What's next?

Last time, we were able to send NodeJS a list of routes, but those routes were
just strings, so our web server was kinda boring...

This time around, we're going to make our routes look more like this:

```elm
homepage : Html msg
homepage =
    html [ lang "en" ]
        [ head []
            [ title "Homepage"
            , meta
                [ name "description"
                , content "This is the homepage."
                ]
            , link
                [ href "https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css"
                , rel "stylesheet"
                ]
            ]
        , body []
            [ div [ class "hero is-fullheight has-text-centered is-info" ]
                [ div [ class "hero-body" ]
                    [ div [ class "container" ]
                        [ h1 [ class "title is-1" ]
                            [ text "Elm ExpressJS" ]
                        , h2 [ class "subtitle is-4" ]
                            [ text "A web server built with elm!" ]
                        , a 
                            [ href "/people"
                            , class "button is-info is-inverted is-outlined"
                            ]
                            [ text "To the people page!" ]
                        ]
                    ]
                ]
            ]
        ]
```

And then get something like this:

![Screenshot of HTML homepage](/images/thoughts/elmexpress/home-bulma.jpg)

and be able to navigate to this:

![Screenshot of HTML people page](/images/thoughts/elmexpress/people-bulma.jpg)

because our server is __actually rendering HTML__ and sending that as a response:

```html
<html lang="en">
<head>
  <title>People</title>
  <meta name="description" content="This is the people page." />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css" rel="stylesheet" />
  <link rel="icon" href="https://seeklogo.com/images/E/elm-logo-9DEF2A830B-seeklogo.com.png" />
</head>
<body>
  <div class="hero is-fullheight has-text-centered is-success">
    <div class="hero-body">
      <div class="container">
        <h1 class="title is-1">People Page</h1>
        <h2 class="subtitle is-4">Look at all those humans!</h2>
        <a href="/" class="button is-success is-inverted is-outlined">Back to homepage</a>
      </div>
    </div>
  </div>
</body>
</html>
```

Kinda neat, right?

Let's dive into how we can make this possible by updating our Elm app!


## Updating `Route`

Javascript gets information from Elm by receiving a list of routes. Last time,
our `Route` records looked like this:

```elm
type alias Route =
    { path : String
    , response : String
    }
```

Let's tweak that data structure, so we can support more than just a `String` in our
Elm code.

```elm
type alias Route =
    { path : String
    , response : Response
    }
```

We'll still have to turn it back to a `String` before sending things over to
Javascript, but that's a problem for our port logic, not our `Route`!

Let's define what the `Response` type looks like.

### So I've got good news and bad news...

#### Bad news:

Unfortunately (and for good reason), the native Elm `Html`
package doesn't expose a `toString` function.

We can't convert `Html -> String` that easily.

#### Good news:

Representing HTML isn't that complicated. And I've already mocked up a
simpler version that we'll be referring to as `Ssr.Html` for the rest of the app.

(It doesn't have all the cool JS event stuff in it, but the server doesn't
run client-side JS, so no worries).

### Let's make a custom type!

Elm has a language feature called "custom types" that we'll use here to cover
all the possible ways we can make the `response` string for our ExpressJS app.

Let's make one now:

```elm
type Response
    = PlainText String
    | Html Ssr.Html
```

`Response` is the type of thing we'll be making, and `PlainText` and
`Html` both act as ways to create `Response` types.

Those two words are also called "type constructors", because they construct
things of type `Response`.

Let's take a quick look at the types to understand how they work:

#### `PlainText`

```elm
PlainText : String -> Response
```

`PlainText` just needs a `String` to make a `Response`.

```elm
response : Response
response =
    PlainText "Hello!"
```

#### `Html`

```elm
Html : Ssr.Html -> Response
```

`Html` just needs an `Ssr.Html` value to make a `Response`.

```elm
response : Response
response =
    Html (h1 [ class "title" ] [ text "Hello!" ])
```

#### Why a "custom type" though?

By using a custom type, we will be able to make one `toString` function that
turns a `Response` into a `String`:

```elm
toString : Response -> String
toString response =
    case response of
        PlainText someString ->
            someString
        Html someHtml ->
            Ssr.Html.toString someHtml
```

Using the custom type will let us extract out the values. (A `String` in the
first case, and a `Ssr.Html` in the second).

For the `PlainText` case, we can return the `String` directly.

For the `Html` case, we can use `Ssr.Html.toString`, which will convert our `Ssr.Html`
into a `String` for us!

__Another bonus__: if we add more options to `Response` later, Elm's compiler will
bring us back to this `case of` expression and remind us to add the new case.

### Updating our app to use `Response`

First, let's change our `routes` to use the new type:

```elm
import Ssr.Html exposing (h1, text)
import Ssr.Html.Attributes exposing (class)


type Response
    = PlainText String
    | Html Ssr.Html


routes =
    [ Route "/"
        (Html
            ( h1 [ class "title" ]
                 [ text "This is the homepage!" ]
            )
        )
    , Route "/people"
        (PlainText "This is the people page!")
    ]
```

We should create a new type, and update `outgoing` port to talk to our
ExpressJS app.

This is necessary because JS doesn't know what "custom types" are!

```elm
type alias JsRoute =
    { path : String
    , response : String
    }


port outgoing : List JsRoute -> Cmd msg
```

If we make a simple function that turns `Route -> JsRoute`, using the
`toString` defined above:

```elm
toString : Response -> String
toString response =
    case response of
        PlainText someString ->
            someString
        Html someHtml ->
            Ssr.Html.toString someHtml


toJsRoute : Route -> JsRoute
toJsRoute route =
    JsRoute
        route.path
        (toString route.response)
```

Finally, our `init` function needs to use that function to convert our
`List Route` to `List JSRoute` before calling `outgoing`:

```elm
init : Flags -> (Model, Cmd Msg)
init flags =
    ( ""
    , outgoing (List.map toJsRoute routes)
    )
```

### Did it work?

Let's rebuild our app:

```bash
npm run build
npm run start
```

Head over to http://localhost:3000 look at that `h1` tag!

![An h1 tag actually showing up](/images/thoughts/elmexpress/home-h1.jpg)

And check out that page source:

```html
<h1>This is the homepage!</h1>
```

We can use the `html`, `body`, and other functions in `Ssr.Html` to make a full
web page with actual CSS and JS too

## Hooray!

Looks like we did it again! HTML coming from Elm? Is this the _future_??

There's still a lot of interesting areas to explore before this is complete:

1. Passing `Request` information to Elm.

    - Parsing URLs for dynamic routes (maybe something like [Url.Parser](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser)?)

1. Reusing Elm HTML on client and server.

1. Extending `Response` to make `JSON` or `XML` api endpoints?

1. Where are the cat GIFs?


If you'd like to play around with the project, it's source code is available on 
Github [over here](https://github.com/ryannhg/elm-express).

Thanks for reading, maybe I'll continue this exploration further later on!

"""
        ]
