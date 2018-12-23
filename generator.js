const fs = require('fs')
const path = require('path')
const read = require('fs-readdir-recursive')

// The main program
const start = _ =>
  Promise.resolve(getPageMetaFromElm())
    .then(pages => pages[0])
    .then(console.log)
    .catch(console.error)

// Utilities
const map = fn => list => list.map(fn)

// Get page information from Elm
const getPageMetaFromElm = _ => {
  const { Elm } = require('./generator.elm.js')
  const app = Elm.Generator.init()
  return new Promise(app.ports.outgoing.subscribe)
}

// Warn about missing pages by scanning pages folder.
const readFiles = _ =>
  Promise.resolve(read(path.join(__dirname, 'src', 'Page')))
    .then(map(toUrl))

const isHomepage = filepath => filepath === 'Home.elm'
const sluggify = pascalCaseWord =>
  pascalCaseWord.split('').reduce((slug, letter, i) =>
    i !== 0 && letter.toUpperCase() === letter
      ? slug + '-' + letter.toLowerCase()
      : slug + letter.toLowerCase(),
  '')

const toUrl = filepath =>
  isHomepage(filepath)
    ? 'index.html'
    : filepath
      .split('.elm').join('')
      .split('/')
      .map(sluggify)
      .join('/') + '.html'

start()
