const fs = require('fs')
const path = require('path')
const pug = require('pug')

// The main program
const start = _ =>
  Promise.resolve(getPageMetaFromElm())
    .then(map(toHtml([])))
    .then(reduce(flattenChildren, []))
    .then(pages => Promise.all(pages.map(generateFile)))
    .then(makeSitemapFromUrls)
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
const publicDir = path.join(__dirname, '..', 'public')

const toHtml = (parentSlugs) => (page) => {
  const slugs = parentSlugs.concat([ page.slug ])
  const path_ = slugs.filter(a => a).join('/')
  return {
    file: path.join(publicDir, (path_ || 'index') + '.html'),
    url: '/' + path_,
    html: pug.renderFile(path.join(__dirname, 'index.pug'), { page: { ...page, url: 'https://www.ryannhg.com/' + path_ } }),
    children: page.children.map(toHtml(slugs))
  }
}

const flattenChildren = (pages, { file, url, html, children }) =>
  pages.concat(children.reduce(
    flattenChildren,
    [ { file, url, html } ])
  )

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

// Sitemap
const makeSitemapFromUrls = (urls) => {
  const sm = require('sitemap')

  const sitemap = sm.createSitemap({
    hostname: 'http://www.ryannhg.com',
    cacheTime: 600000, // 600 sec (10 min) cache purge period
    urls: urls.map(url => ({ url }))
  })

  fs.writeFileSync(path.join(publicDir, 'sitemap.xml'), sitemap.toString())
  return urls
}

start()
