window.initContent = ->
  # MathJax Rerender
  MathJax.Hub.queue.Push ["Typeset", MathJax.Hub]

  # Syntax Hilighting
  $ 'pre'
  .addClass 'prettyprint linenums'
  prettyPrint()

  # Links Pointing
  $ '.postcontent a'
  .attr 'target', '_blank'

window.reloadDisqus = ->
  # Disqus Reload
  DISQUS? && DISQUS.reset
    reload: true
    config: ->
      @page.identifier = disqus_identifier
      @page.title = document.title
      @page.url = decodeURIComponent location.href

$(document).ready ->
  MathJax.Hub.Config
    messageStyle: 'none'
    tex2jax:
      inlineMath: [
        ['$', '$']
        ['\\(', '\\)']]
  initContent()