History = window.History
loading = no
$ajaxContainer = null

$(document).ready ->
  $ajaxContainer = $ '#ajax-container'

return unless History.enabled

History.Adapter.bind window, 'statechange', ->
  State = History.getState()
  loading = url = decodeURIComponent State.url
  $.get url, (result) ->
    return unless loading is url
    $newContent = $(result).filter('#ajax-container').html()
    title = $(result).filter('title').text()
    window.disqus_identifier = $(result).filter('meta[name=disqus_identifier]').attr 'content'
    History.replaceState {}, title
    , decodeURIComponent location.href

    $('html, body').animate
      scrollTop: 0

    $ajaxContainer.fadeOut 500, ->
      $ajaxContainer.html $newContent
      $ajaxContainer.fadeIn 500

      initContent?()

      if disqus_identifier
        reloadDisqus()

      NProgress.done()
      loading = no

$('body').on 'click', 'a', (e) ->
  url = decodeURIComponent $(@).attr 'href'
  baseURL = window.location.origin
    .replace '/', '\\/'
    .replace ':', '\\:'
  if url.match(new RegExp("^(\.?\.?\/)|#{baseURL}")) and
  not $(@).hasClass 'no-ajax' and
  not $(@).attr('target') is '_blank'
    e.preventDefault()
    currentState = History.getState()
    title = $(@).attr 'title' || blog_title
    NProgress.start()
    History.pushState {}, title, url
