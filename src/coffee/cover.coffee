base = 'http://ppcdn.500px.org/'
covers =
[ "#{base}63559649/2baa04dfa5899a7c7f2a76199b51f3f9f3e312fe/2048.jpg",
  "#{base}63607741/a5cbcc640c26d0c5fe8c21c64538869187481492/2048.jpg",
  "#{base}63335885/ea697ecf79669c84018a2db9600fc3f9012efaae/5.jpg",
  "#{base}63532399/250a50702c9a93e47979d29be04da6a0eefa3300/2048.jpg",
  "#{base}63632263/7c0d20d69b7a882ca64f9e707859b43c7d8ac21e/2048.jpg",
  "#{base}63577787/f953782d9fed42eca490e7ed72da1dfa155506ca/2048.jpg",
  "#{base}63050437/2050a6b9fadb25256169efda064c16465ac0ab1e/2048.jpg",
  "#{base}63559187/410c09a378bc4cb329a28f145b7b2926902c82c5/2048.jpg",
  "#{base}63565367/5e6f81a4fde3561a4806280945242b33a340420f/2048.jpg",
  "#{base}63547837/610d8328581ae05d5d4971aeef25feb934ee685d/5.jpg",
  "#{base}63346985/0c3be0e558a123921e31321c675ef3c7600597ca/2048.jpg",
  "#{base}63265959/72b775d55bbc29258a1670d22bd4788b116a3fd1/2048.jpg",
  "#{base}63214935/b02f28888c4566ba256b21bc61ef9142e9bb2b1f/2048.jpg"]

timeInterval = 8000
transition = 1.5

images = []
currentImage = -1
total = covers.length
top = bottom = pageLoaded = null

covers.every (url) ->
  $ '<img>'
  .attr 'src', url
  .load ->
    $(@).remove()
    images.push url
    if pageLoaded
      unless top.loaded
        top.load url

nextImage = ->
  if top.shown
    [toHide, toShow] = [top, bottom]
  else
    [toHide, toShow] = [bottom, top]
  if l = images.length
    if l > next = currentImage + 1
      url = images[next]
    else if l == total
      url = images[next = 0]
    else
      return nextImage()
    toShow.load url, ->
      toHide.hide()
    currentImage = next
  setTimeout nextImage, timeInterval

class Loader
  constructor: (@el, @transition) ->
    @el = [].concat @el
    @loaded = @shown = no
    @addStyle "transition: opacity #{@transition}s;"
  addStyle: (style) ->
    index = document.styleSheets.length - 1
    for el in @el
      document.styleSheets[index]
      .addRule @el, style
  hide: ->
    @shown = no
    @addStyle "opacity: 0;"
  load: (url, callback) ->
    @addStyle "background-image: url(#{url}); opacity: 1;"
    @loaded = @shown = yes
    setTimeout callback, @transition

$(document).ready ->
  pageLoaded = yes
  top = new Loader '.header:after', transition
  bottom = new Loader '.header:before', transition
  setTimeout nextImage, timeInterval

