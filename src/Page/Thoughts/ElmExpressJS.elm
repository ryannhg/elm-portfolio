module Page.Thoughts.ElmExpressJS exposing (page)

import Page
import Slug


page : Page.Page
page =
    Page.page
        "Elm ExpressJS"
        "Using Elm's ports to make a web server!"
        (Page.Image
            "https://images.unsplash.com/photo-1543450251-7c0d0512be8a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&q=80&w=1200"
            "Some ports on the water."
        )
        1545945325292
        [ Page.Content """
## What's ExpressJS?

If you're not familiar with [ExpressJS](https://expressjs.com/), it's just a
lightweight framework that makes building web applications really easy:

```js
const express = require('express')
const app = express()

app.get('/', (req, res) =>
  res.send('Hello from homepage!')
)

app.listen(3000, () =>
  console.info('Ready at http://localhost:3000')
)
```

This code example creates an Express `app`, registers a route for `/` using
`app.get`, and then starts the web server on port `3000`.

Since Elm compiles to JS, I was curious what it would be like to use Elm to define
my routes by using [`Platform.worker`] and ports.

Let's build it from scratch together!

## Starting simple

To understand how `Platform.worker` actually works, lets make a simple sample app

```
$ mkdir elm-express
$ cd elm-express
$ npm install -g elm
$ elm init
```

These commands will create a new folder called `elm-express`, enter that folder,
install the `elm` command line stuff, and then `elm init` will setup your project!

Your project should now look like this:

```shell
|- elm-express/
   |- src/
   |- elm.json
```

Let's create `src/Main.elm` and start coding!

### `src/Main.elm`

First we define our module:

```elm
module Main exposing (main)
```

The module is called `Main`, and it will expose a function called
`main`. That function will be the entrypoint to our Elm app.

Let's define `main` next:

```elm
module Main exposing (main)

main =
    Platform.worker
        { init = init -- TODO
        , update = update -- TODO
        , subscriptions = subscriptions -- TODO
        }
```

Our `main` function is going to define a `Platform.worker` program. This
program needs three functions to work:

- `init` - Called on startup to initialize the app.
- `update` - Called everytime we get a message. It returns the updated model.
- `subscriptions` - We can also register things to send us messages from JS.

Before defining each of these, we should define the types for the application so
things make a bit more sense later on:

```elm
module Main exposing (main)

type alias Flags = ()

type alias Model = String

type Msg = NoOp

main : Program Flags Model Msg
main =
    Platform.worker
        { init = init -- TODO
        , update = update -- TODO
        , subscriptions = subscriptions -- TODO
        }
```

Above, we're saying that we are going to receive no flags on startup. We use the
empty parentheses to let Elm know that it shouldn't expect any `Flags`.

Next, we are saying that our `Model` is just going to be a `String`. We'll update
that one later when we have something interesting to keep track of.

Finally, we defining all the possible messages our app can receive with `Msg`. For
now, we are just going to define one message called `NoOp` that has no effect.
(This will change soon too!)

#### Defining `init`

```elm
init : Flags -> (Model, Cmd Msg)
init flags =
    ( "", Cmd.none )
```

The `init` function expects our flags to come in as input, and will return a pair
of two things when it's done:

1. The initial model (just an empty string)

1. Any side effects we want to create on startup (`Cmd.none` means no side effects)


#### Defining `update`

The next function we should define is `update`, the thing that returns an update
`Model` when a new `Msg` comes in.

`update` also receives the current model as the second input (`model`) in case it
needs to use the current state to determine the new state:

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
```

Here we use a `case of` expression to match on all the possible `Msg` types we
might get. For now, we've only defined one type of `Msg` called `NoOp`.

When we receive a `NoOp` message, we simply return the `model` as it is, and use
`Cmd.none` to say we want no side effects also.

If we add more types of `Msg` later on, this `case of` will allow the Elm compiler
to bring us back to `update` so we don't forget how to handle the new `Msg`!

#### Defining `subscriptions`

The `subscriptions` function takes in the current `Model` and returns subscriptions
that should be able to send `Msg` later. For now, we don't need any subscriptions
at all.

We'll just return `Sub.none`, which says "we don't want any subscriptions, leave
me alone".

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
```

Altogether, our `src/Main.elm` file should look like this:


```elm
module Main exposing (main)


type alias Flags =
    ()

type alias Model =
    String

type Msg = NoOp


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> (Model, Cmd Msg)
init flags =
    ( "", Cmd.none )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions model =
    Sub.none
```

Let's use `elm make` in our terminal to compile this to JS:

```shell
$ elm make src/Main.elm --optimize --output server/elm.js
```

We should see `Success! Compiled 1 module.`, which means we are ready to use
`elm.js` in our NodeJS application!

### Creating the NodeJS app

To create a new ExpressJS app, we'll need to get a `package.json` using `npm init`

```shell
$ npm init -y
```

We use the `-y` option here so it doesn't ask us 10 questions, and just uses the
default stuff.

Now your folder should look something like this:

```shell
|- elm-express/
   |- elm-stuff/
   |- server/
      |- elm.js
   |- elm.json
   |- package.json
   |- src/
      |- Main.elm
```

with a `package.json` file that looks like this:

```json
{
  "name": "elm-express",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo "Error: no test specified" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

Let's update `main` from `index.js` to `server/index.js`. Then we should create
the `server/index.js` file and give it the content from the beginning of this post:

```js
const express = require('express')
const app = express()

app.get('/', (req, res) =>
  res.send('Hello from homepage!')
)

app.listen(3000, () =>
  console.info('Ready at http://localhost:3000')
)
```

We can't run this program until we install the express module from npm:

```shell
$ npm install --save express
```

While we are at it, let's install the `elm` package as a dev dependency, so people
who clone our repo don't have to globally install `elm` (like we did with `-g` at
the beginning of this post):

```shell
$ npm install --save-dev elm
```

In the scripts section, lets define two npm scripts to build and start our server.

Our `package.json` should look like this now:

```json
{
  "name": "elm-express",
  "version": "1.0.0",
  "description": "",
  "main": "server/index.js",
  "scripts": {
    "start": "node server/index.js",
    "build": "elm make src/Main.elm --optimize --output server/elm.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.16.4"
  },
  "devDependencies": {
    "elm": "^0.19.0-bugfix2"
  }
}
```

Now running we can run `npm run build` to recompile `server/elm.js` and `npm start`
to get our server up and running!

Let's see if our express server works:

```shell
$ npm start
```

Your console should say:

```shell
Ready at http://localhost:3000
```

And visiting that URL in your browser will display "Hello from homepage!"

## Including our elm code

Since `server/elm.js` is just a JS file, we can `require` it in our application
like this:

```js
const express = require('express')
const { Elm } = require('./elm.js')
console.log('Elm', Elm)
const app = express()

// ... the rest of the code
```

You'll see our program outputs this now:

```shell
Elm { Main: { init: [Function] } }
Ready at http://localhost:3000
```

The `Elm` variable has a property `Main`, which has a function called `init`.

Calling that function will start up the Elm app!

```js
const express = require('express')
const { Elm } = require('./elm.js')
const elmApp = Elm.Main.init()
console.log('elmApp', elmApp)
const app = express()

// ... the rest of the code
```

Hooray! We got this as the output:

```shell    
elmApp {}
Ready at http://localhost:3000
```

elmApp is an object containing all the ways NodeJS can interact with our Elm app.

And right now it's completely empty, because we didn't make any ports yet.

## Making ports!

In Elm, we don't share code with Javascript. The way we communicate with JS is with
a simple concept called "ports".

A port is basically a one-way channel of sending messages either:

- Outgoing (from Elm to JS)
- Incoming (from JS to Elm)

Let's update our `Main` Elm module to become a port module that sends a message
to JS when our Elm app is ready!

```elm
port module Main exposing (main)

-- The rest of our code
```

First we'll need update the first line of our code so the Main module is allowed
to use ports.

The next thing we'll do is define an outgoing port that will be able to send messages
(of type `String`) to JS as a side effect (thats what `Cmd` is for):

```elm
port module Main exposing (main)

port outgoing : String -> Cmd msg

-- The rest of our code
```

Finally, let's send JS a message on startup, by updating `init`:

```elm
init : Flags -> (Model, Cmd Msg)
init flags =
    ( "", outgoing "Elm is ready!" )
```

If we rebuild our Elm app now with that dope `build` script:

```shell
$ npm run build
```

And rerun our app with `npm start`, we'll see this:

```shell
elmApp { ports:
   { outgoing:
      { subscribe: [Function: subscribe],
        unsubscribe: [Function: unsubscribe] } } }
Ready at http://localhost:3000
```

Woohoo! Let's update `server/index.js` to subscribe to the outgoing port:

```js
const express = require('express')
const { Elm } = require('./elm.js')
const elmApp = Elm.Main.init()
elmApp.ports.outgoing.subscribe(function (message) {
  console.log(message)
})

const app = express()

// ... the rest of the code
```

Running `npm start` one more time:

```shell
Ready at http://localhost:3000
Elm is ready!
```

## Nice!

Our Elm app is sending messages to NodeJS. We're using Elm on the backend!

Next, we'll make Elm provide ExpressJS routes.

But that was a lot of stuff I threw at you. Take a break, grab some coffee,
I'll see you soon in part two!

"""
        ]
