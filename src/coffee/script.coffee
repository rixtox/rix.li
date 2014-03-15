window.initContent = ->
  MathJax.Hub.queue.Push ["Typeset", MathJax.Hub]
  $ 'pre'
  .addClass 'prettyprint linenums'
  prettyPrint()
  $ '.postcontent a'
  .attr 'target', '_blank'

$(document).ready ->
  MathJax.Hub.Config
    messageStyle: 'none'
    tex2jax:
      inlineMath: [
        ['$', '$']
        ['\\(', '\\)']]
  initContent()