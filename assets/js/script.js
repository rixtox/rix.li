(function() {
  var Loader, base, bottom, covers, currentImage, images, nextImage, timeInterval, top, total, transition;

  base = 'https://imageshack.com/a/img';

  covers = ["" + base + "89/1258/vbxb.jpg", "" + base + "822/6477/6zzm.jpg", "" + base + "600/3735/bxdt.jpg", "" + base + "546/7725/mqw3.jpg", "" + base + "31/7246/0cwv.jpg", "" + base + "594/843/scsr.jpg", "" + base + "401/5414/zdao.jpg", "" + base + "855/8475/9hab.jpg", "" + base + "36/9311/uxij.jpg", "" + base + "577/7841/2ljc.jpg", "" + base + "842/4782/58i4.jpg", "" + base + "841/4355/3hn9.jpg", "" + base + "37/6219/mmk2.jpg"];

  timeInterval = 8000;

  transition = 1.5;

  images = [];

  currentImage = -1;

  total = covers.length;

  top = bottom = null;

  covers.every(function(url) {
    return $('<img>').attr('src', url).load(function() {
      $(this).remove();
      images.push(url);
      if (currentImage < 0) {
        return nextImage();
      }
    });
  });

  nextImage = function() {
    var l, next, toHide, toShow, url, _ref, _ref1;
    if (bottom.shown) {
      _ref = [bottom, top], toHide = _ref[0], toShow = _ref[1];
    } else {
      _ref1 = [top, bottom], toHide = _ref1[0], toShow = _ref1[1];
    }
    if (l = images.length) {
      if (l > (next = currentImage + 1)) {
        url = images[next];
      } else if (l === total) {
        url = images[next = 0];
      } else {
        return nextImage();
      }
      toShow.load(url, function() {
        return toHide.hide();
      });
      currentImage = next;
    }
    return setTimeout(nextImage, timeInterval);
  };

  Loader = (function() {
    function Loader(el, transition) {
      this.el = el;
      this.transition = transition;
      this.loaded = this.shown = false;
      this.css({
        transition: "opacity " + this.transition + "s"
      });
    }

    Loader.prototype.css = function() {
      var _ref;
      return (_ref = $(this.el)).css.apply(_ref, arguments);
    };

    Loader.prototype.hide = function() {
      this.shown = false;
      return this.css({
        opacity: 0
      });
    };

    Loader.prototype.load = function(url, callback) {
      this.css({
        'background-image': "url(" + url + ")",
        opacity: 1
      });
      this.loaded = this.shown = true;
      return setTimeout(callback, this.transition);
    };

    return Loader;

  })();

  $(document).ready(function() {
    top = new Loader('.header .top', transition);
    return bottom = new Loader('.header .bottom', transition);
  });

}).call(this);

(function() {
  var $ajaxContainer, History, loading;

  History = window.History;

  loading = false;

  $ajaxContainer = null;

  $(document).ready(function() {
    return $ajaxContainer = $('#ajax-container');
  });

  if (!History.enabled) {
    return;
  }

  History.Adapter.bind(window, 'statechange', function() {
    var State, url;
    State = History.getState();
    loading = url = decodeURIComponent(State.url);
    return $.get(url, function(result) {
      var $newContent, title;
      if (loading !== url) {
        return;
      }
      $newContent = $(result).filter('#ajax-container').html();
      title = $(result).filter('title').text();
      window.disqus_identifier = $(result).filter('meta[name=disqus_identifier]').attr('content');
      History.replaceState({}, title, decodeURIComponent(location.href));
      $('html, body').animate({
        scrollTop: 0
      });
      return $ajaxContainer.fadeOut(500, function() {
        $ajaxContainer.html($newContent);
        $ajaxContainer.fadeIn(500);
        if (typeof initContent === "function") {
          initContent();
        }
        if (disqus_identifier) {
          reloadDisqus();
        }
        NProgress.done();
        return loading = false;
      });
    });
  });

  $('body').on('click', 'a', function(e) {
    var baseURL, currentState, title, url;
    url = decodeURIComponent($(this).attr('href'));
    baseURL = window.location.origin.replace('/', '\\/').replace(':', '\\:');
    if ((new RegExp("^(\.?\.?\/)|" + baseURL)).test(url) && !$(this).hasClass('no-ajax') && !($(this).attr('target') === '_blank')) {
      e.preventDefault();
      currentState = History.getState();
      title = $(this).attr('title' || blog_title);
      NProgress.start();
      return History.pushState({}, title, url);
    }
  });

}).call(this);

(function() {
  window.initContent = function() {
    MathJax.Hub.queue.Push(["Typeset", MathJax.Hub]);
    $('pre').addClass('prettyprint linenums');
    prettyPrint();
    return $('.postcontent a').attr('target', '_blank');
  };

  window.reloadDisqus = function() {
    return (typeof DISQUS !== "undefined" && DISQUS !== null) && DISQUS.reset({
      reload: true,
      config: function() {
        this.page.identifier = disqus_identifier;
        this.page.title = document.title;
        return this.page.url = decodeURIComponent(location.href);
      }
    });
  };

  $(document).ready(function() {
    MathJax.Hub.Config({
      messageStyle: 'none',
      tex2jax: {
        inlineMath: [['$', '$'], ['\\(', '\\)']]
      }
    });
    return initContent();
  });

}).call(this);
