const fs = require('fs')
const path = require('path')
const pug = require('pug')

// The main program
const start = _ =>
  Promise.resolve(getPageMetaFromElm())
    .then(map(toHtml([])))
    .then(reduce(flattenChildren, []))
    .then(pages => Promise.all(pages.map(generateFile)))
    .then(console.log)
    .catch(console.error)

// Utilities
const map = fn => list => list.map(fn)
const reduce = (fn, initial) => list => list.reduce(fn, initial)

// Get page information from Elm
const getPageMetaFromElm = _ => {
  const { Elm } = require('./generator.elm.js')
  const app = Elm.Generator.init()
  return new Promise(app.ports.outgoing.subscribe)
}

// Pug rendering stuff
const publicDir = path.join(__dirname, 'public')

const toHtml = (parentSlugs) => (page) => {
  const slugs = parentSlugs.concat([ page.slug ])
  const path_ = slugs.filter(a => a).join('/')
  return {
    file: path.join(publicDir, (path_ || 'index') + '.html'),
    url: '/' + path_,
    html: pug.renderFile('index.pug', { page }),
    children: page.children.map(toHtml(slugs))
  }
}

const flattenChildren = (pages, { file, url, html, children }) => {
  pages = pages.concat([ { file, url, html } ])
  pages = pages.concat(children.reduce(flattenChildren, []))
  return pages
}

const dirOfFile = filename => {
  const pieces = filename.split('/')
  return pieces.slice(0, pieces.length - 1).join('/')
}

const generateFile = ({ file, url, html }) =>
  new Promise(resolve => {
    var dir = dirOfFile(file)
    if (dir && !fs.existsSync(dir)) {
      fs.mkdirSync(dir)
    }
    fs.writeFile(file, html, { encoding: 'utf8' }, _ =>
      resolve(url)
    )
  })

start()
