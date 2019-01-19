module Page.Thoughts.ElmExpressJSPartTwo exposing (page)

import Page
import Slug


page : Page.Page
page =
    Page.page
        "Elm ExpressJS: Part Two"
        "The epic web server saga continues..."
        (Page.Image
            "https://images.unsplash.com/photo-1543450251-7c0d0512be8a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&q=80&w=1200"
            "Some ports on the water."
        )
        1547919981710
        [ Page.Content """
## Don't forget part one!

If you haven't read [part one](/thoughts/elm-expressjs) yet, you might want to
so that the following things make sense.

Unless you're a badass, then hop in now. Lesgoooo!!

## Where we left off

Last time, we were able to get Elm communicating with our NodeJS Express
app using ports!

All it did was send "Elm is ready!", which was pretty neat. To make things interesting,
we can send more than just text from Elm to JS.

In fact, for this to work, Elm is going to send NodeJS a list of routes!

## Defining routes as data

Ultimately, only our NodeJS app will be able to call `app.get` to set up our routes.

And Elm will only be able to send JS messages of data (not code). This means we'll
need to represent our ExpressJS routes __as data__.

Let's refactor the existing Express app to make routes from data:

```js
const express = require('express')
const app = express()

app.get('/', (req, res) =>
  res.send('Hello from homepage!')
)

app.get('/people', (req, res) =>
  res.send('Hello from people page!')
)

app.get('/offices', (req, res) =>
  res.send('Hello from offices page!')
)

app.listen(3000, () =>
  console.info('Ready at http://localhost:3000')
)
```

For this simple example, it's clear that there are only two differences between
each of the three express routes:

- The path (`/`, `/people`, or `/offices`)
- The content (`Hello from...`)

Let's move that information into a list we can loop through:

```js
const express = require('express')
const app = express()

const routes = [
  {
    path: '/',
    content: 'Hello from homepage!'
  },
  {
    path: '/people',
    content: 'Hello from people page!'
  },
  {
    path: '/offices',
    content: 'Hello from offices page!'
  }
]

routes.forEach(route => {
  app.get(route.path, (req, res) =>
    res.send(route.content)
  )
})

app.listen(3000, () =>
  console.info('Ready at http://localhost:3000')
)
```

If we run this code, we'll see that our routes are still working:

![Homepage screenshot](/images/thoughts/elmexpress/home.jpg)

![People page screenshot](/images/thoughts/elmexpress/people.jpg)

![Offices page screenshot](/images/thoughts/elmexpress/offices.jpg)

## Getting routes from Elm

Now that we are representing our routes as data, we can define them in Elm, and
send them over the ports instead of that boring "Elm is ready!" message.

Let's start by adding a new `Route` type in `src/Main.elm`:

```elm
port module Main exposing (main)

type alias Route =
    { path : String
    , content : String
    }

-- The rest of our code
```

We define `Route` just like we used it in the ExpressJS app above.

Now, we'll need to make our Elm app return a `List` of `Route` back to our JS
with the outgoing port.

We can do this by defining our routes in Elm:

```elm
port module Main exposing (main)

type alias Route =
    { path : String
    , content : String
    }

routes : List Route
routes =
  [ Route "/" "Elm says 'Hello from home!'"
  , Route "/people" "Elm says 'Hello from people!'"
  , Route "/offices" "Elm says 'Hello from offices!'"
  ]

-- The rest of our code
```

Using `Route` as a "type constructor", we can associate the first String with
`path` and the second String with `content`.

To help visualize what is in `routes`, here's its value:

```elm
  [ { path = "/", content = "Elm says 'Hello from home!'" }
  , { path = "/people", content = "Elm says 'Hello from people!'" }
  , { path = "/offices", content = "Elm says 'Hello from offices!'" }
  ]
```

That's the data we want to pass to ExpressJS, so let's update the `outgoing`
port to take in `List Route` instead of `String`:

```elm
port outgoing : List Route -> Cmd msg
```

And let's call that port on initialization, by updating our `init` function from
before:

```elm
init : Flags -> (Model, Cmd Msg)
init flags =
    ( ""
    , outgoing routes
    )
```

The full file should look like this:

```elm
port module Main exposing (main)


type alias Route =
    { path : String
    , content : String
    }


routes : List Route
routes =
    [ Route "/" "Elm says 'Hello from home!'"
    , Route "/people" "Elm says 'Hello from people!'"
    , Route "/offices" "Elm says 'Hello from offices!'"
    ]


type alias Flags =
    ()


type alias Model =
    String


type Msg
    = NoOp


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> (Model, Cmd Msg)
init flags =
    ( ""
    , outgoing routes
    )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


port outgoing : List Route -> Cmd msg
```


## Updating the Express app

Let's replace the routes we made in JS with the ones we just defined in Elm:

```js
const express = require('express')
const { Elm } = require('./elm.js')
const elmApp = Elm.Main.init()
const app = express()

elmApp.ports.outgoing.subscribe((routes) => {
  routes.forEach(route => {
    app.get(route.path, (req, res) =>
      res.send(route.content)
    )
  })

  app.listen(3000, () =>
    console.info('Ready at http://localhost:3000')
  )
})
```

Note the `app.listen` call needs to wait until we receive our routes from
the outgoing before starting the server.

If we run:

```
npm run build
npm start
```

We'll see that our routes are actually coming from Elm:

![Offices page screenshot](/images/thoughts/elmexpress/offices-elm.jpg)


## Hooray!

If we update the routes in our Elm app (and rebuild it), you'll see our web
server is serving the routes we define.

There's still more to do before this is a useful thing to use (like maybe sending
HTML instead of a string), so stay tuned for part three, where we generate our
response with something like Elm's `Html` library.
"""
        ]
