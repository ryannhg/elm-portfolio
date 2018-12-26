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
        [ Page.Content """
## I wasn't always like this.

When I first started creating things, it was making video games.
In high school, my friend Scott and I would create video games together. He was (and still is) brilliant at
building things in Java, and I was the dude who made the character and world
art in Photoshop.

![One of the main menus for Veril 3](/images/veril/menu.png)

The game we created was called Veril 3, and we even [made a subreddit](https://reddit.com/r/veril) for it
at the time.

## Learning Java

Scott and I took an AP programming class in high school. My first programming language
was __Java__. I was making `SavingsAccount` classes extend `BankAccount` interfaces and it
was the most boring possible way to get a kid excited about code.

But we pushed through it! In no time, Scott and I were using what we learned to make
`Goblin` classes extend `Enemy` classes and life was good. We were able to apply
those intro object-oriented principles to the video games! Woohoo!

## Next up: college!

I was pretty into coding after helping out with Veril, so I went to U of I to learn
more about how to build video games for a living. Instead of majoring in Computer
Science, I ended up getting into the Computer Engineering program.

At first, my plan was to switch over to the Computer Science major asap.

But then I built a robotic car. And I fell in love. I stuck with it for four years.

Because Computer Engineering involved a lot of low-level programming, I was building
operating systems in __x86 assembly__, writing drivers in __C__, and learning data-structures in __C++__.

## My first website

Junior year, I took a class called Database Systems. It was about relational
data-modelling with __SQL__, but there was a project at the end of the semester that
involved making a fullstack website.

I was curious about responsive design, so I chose to be responsible for the frontend.
I was using __jQuery__, Foundation __CSS__, and just static __HTML__. My buddy Sam spun up a backend
in Python using Flask.

I was absolutely obsessed with idea that I could code something _once_ and have it
work on phone, tablet, and desktop. It didn't matter if my friends had Android or
iOS, PC, Mac, or Linux. I could build something once and share it everywhere.

That project inspired me to grow more as a web developer.

## Learning a framework.

Building the first website was neat, but there was _so much_ repitition. The following
year, my roommate Ben and I started trying to learn more about __AngularJS__. Supposedly,
it was this magical framework that made building applications in JS bearable.

Coming from jQuery, I had a really tough time wrapping my head around services,
factories, directives, controllers, and modules. My instinct was to grab a `div` and start
hacking the s&%! out of it.

I had a tricky time with AngularJS, so I actually jumped ahead to __Angular 2__.
I followed the __Typescript__ and __Dart__ tutorials and had a good time. After
wrapping my head around Angular 2 components, I was able to apply that understanding
towards AngularJS.

When I started working at Caterpillar with Ben that semester, I was able to lead
the frontend project with him. He built a Django backend while I built out an
AngularJS and __Bootstrap__ project. (I also had to learn about the build ecosystem:
using __gulp__ and __browserify__ and __sass__ to make life easy).

## More frontend things!

My experience with Angular 2 also made learning __React__ a breeze! I definitely
preferred the development experience, but missed Angular's ability to work without
a complex build pipeline. Plus I was able to use __React Native__ during my one
of my internships.

When I met __VueJS__, I was hooked. It was as easy to get started with as jQuery,
but the result was as easy to scale as Angular or React! Plus it didn't clutter
my head with "factories" or "transclusion".

It was simple and really fun to build apps with. It's still the framework I reach
for today with making Javascript applications.

## Becoming a backend boy.

Creating static frontend websites was neat, but I needed to be able to learn backend
web development if I wanted to tackle anything real. Because of my established comfort
with Javascript, and familiarity with NPM, __NodeJS__ was a great place to start.

After a few months of practice, and several side projects, I was able to build real
fullstack applications using __ExpressJS__ and __Mongoose__. I was deploying my own
applications to __Heroku__ and __mLab__.

To keep it all simple and straightforward, I started using __Docker__ to make
reproducing my development environment a breeze. Soon `docker-compose up` was all
I had to do to spin up my databases, gulp tasks, and web server!

## Unlearning everything.

A few months after starting my career in web development, I was taking a train ride
home. A medium article called "[So you want to be a functional programmer](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536)"
popped up on the top of my Medium feed.

I remember thinking: "I don't know what a functional programmer is... maybe?"

I read part one of that series. And then part two. And I kept reading until it was
over. The concepts were super interesting, and at the end of every article there
was a link to a Facebook group for a programming language called __Elm__.

I found a link to a video called "Let's be Mainstream!" and I have been happily
brainwashed ever sense.

[![Lets be Mainstream!](https://img.youtube.com/vi/oYk8CKH7OhE/0.jpg)](https://www.youtube.com/watch?v=oYk8CKH7OhE)

Elm gave me a fresh perspective on how to program. It has fundamentally impacted
the way I build applications. I'm incredibly grateful for the community and the
positive impact it has had on my career.

Meanwhile, my NodeJS applications are covered in `=>` functions and ES6 is casually
destroying the relationship I have with my coworkers.

## What's next?

Currently, I'm grappling between learning Elixir, Rust, Haskell, and Clojure. I'm 
trying to find a backend language that gave me the same level of personal growth that
Elm provided.

To check on my progress, you can head over to the [thoughts page](/thoughts) to look
for the latest stuff I've explored. Thanks for reading!
"""
        ]
