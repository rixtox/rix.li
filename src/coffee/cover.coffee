base = '//imageshack.com/a/img'
covers =
[ "#{base}89/1258/vbxb.jpg",
  "#{base}822/6477/6zzm.jpg",
  "#{base}600/3735/bxdt.jpg",
  "#{base}546/7725/mqw3.jpg",
  "#{base}31/7246/0cwv.jpg",
  "#{base}594/843/scsr.jpg",
  "#{base}401/5414/zdao.jpg",
  "#{base}855/8475/9hab.jpg",
  "#{base}36/9311/uxij.jpg",
  "#{base}577/7841/2ljc.jpg",
  "#{base}842/4782/58i4.jpg",
  "#{base}841/4355/3hn9.jpg",
  "#{base}37/6219/mmk2.jpg"]

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

