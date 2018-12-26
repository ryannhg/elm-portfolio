module Page.Thoughts.CurryingInJS exposing (page)

import Page


page : Page.Page
page =
    Page.page
        "Currying in JS"
        "When your functions return other functions, you can do some pretty neat stuff."
        (Page.Image
            "https://images.unsplash.com/photo-1502900476531-ca62d0f2b679?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&q=80&w=1200"
            "Some coffee, a laptop with some code on it, and a plant."
        )
        1545797473203
        [ Page.Content """
## Lets make a thing.

It's a simple thing. It's just a module called `Checker` filled with functions that
check if a value is a certain type.

This is how people can use our module:

```js
const Checker = require('./checker.js')

Checker.isString('ryan') // true
Checker.isNumber('ryan') // false
Checker.isBoolean('ryan') // false

Checker.isString(123) // false
Checker.isNumber(123) // true
Checker.isBoolean(123) // false

Checker.isString(true) // false
Checker.isNumber(true) // false
Checker.isBoolean(true) // true
```

Our `Checker` should return three functions:

1. __`isString()`__ - returns `true` for things of type `string`
1. __`isNumber()`__ - returns `true` for things of type `number`
1. __`isBoolean()`__ - returns `true` for things of type `boolean`

## Getting started

The first attempt might look like this:

```js
var isString = function (thing) {
  return typeof thing === 'string'
}
var isNumber = function (thing) {
  return typeof thing === 'number'
}
var isBoolean = function (thing) {
  return typeof thing === 'boolean'
}

module.exports = {
  isString,
  isNumber,
  isBoolean
}
```

This code totally works, but there's a lot of repetition going on. Let's see if 
arrow functions help out at all:

```js
var isString = (thing) => {
  return typeof thing === 'string'
}
var isNumber = (thing) => {
  return typeof thing === 'number'
}
var isBoolean = (thing) => {
  return typeof thing === 'boolean'
}

module.exports = {
  isString,
  isNumber,
  isBoolean
}
```

We got rid of the word `function`, but since everything just returns a value, we
can actually omit the `{}` and `return` parts too!

```js
var isString = (thing) =>
  typeof thing === 'string'

var isNumber = (thing) =>
  typeof thing === 'number'

var isBoolean = (thing) =>
  typeof thing === 'boolean'


module.exports = {
  isString,
  isNumber,
  isBoolean
}
```

## Alright, not bad.

We removed the need to repeat keywords, so the "typing letters" part of the 
duplication has been addressed. That's about as small as we can reduce the
syntax.

But do you notice anything special about these functions?

They are all doing the same thing, but with a different string__!

Let's move out the shared code into a more general function:

```js
var isType = (thing, type) =>
  typeof thing === type

var isString = (thing) =>
  isType(thing, 'string')
var isNumber = (thing) =>
  isType(thing, 'number')
var isBoolean = (thing) =>
  isType(thing, 'boolean')

module.exports = {
  isString,
  isNumber,
  isBoolean
}
```

This refactor is _kinda_ nice, because we've pulled out the mechanical part of the
function (`typeof thing === ___`).

But we've actually introduced new boilerplate when we duplicate `isType(thing, ___)`

## Introducing currying

Currying is a functional-programming-fancy-boy trick where you make your functions
return functions that have some of their arguments already.

Let's go through a simple example before returning to the `Checker` problem.

Here's an `add` function in JS, using arrow syntax:

```js
var add = (a, b) => a + b
```

As you can see, we provide both inputs when we call `add`. Any missing inputs
will result in one of the values being `undefined`:

```js
add(1) // NaN
add(1, 2) // 3
```

What if we wrote the function like this instead?

```js
var add = (a) => (b) => a + b
```

This would be the result:
```js
add(1) // b => 1 + b
add(1)(2) // 3
```

Weird! When we call `add` the first time, we provide the value for `a`, and get back
a function waiting for the value of `b`.

Since functions are values too, we can even keep them in their own variable like this:

```js
var addHundred = add(100) // b => 100 + b
addHundred(200) // 300
addHundred(400) // 500
```

Magic! Let's see how that might be useful with our original `Checker` module:

## A more useful `isType`

The way we can prevent the repetition from before is by changing how `isType`
accepts its inputs.

Let's turn this:

```js
var isType = (thing, type) =>
  typeof thing === type
```

into this:

```js
var isType = (type) => (thing) =>
  typeof thing === type
```

Notice the body of our `isType` function hasn't changed, just the way we pass it
information. This new format allows us to pass in inputs one at a time.

Let's put it all the pieces together:

```js
var isType = (type) => (thing) =>
  typeof thing === type

var isString = isType('string')
var isNumber = isType('number')
var isBoolean = isType('boolean')

module.exports = {
  isString,
  isNumber,
  isBoolean
}
```

## Hooray!

We we're able to reduce the amount of visual boilerplate in our `Checker`
module by using the latest ES6 syntax and using currying.

Thanks for reading!

"""
        ]
