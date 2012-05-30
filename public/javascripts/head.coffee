((doc) ->
  pushClass = (name) ->
    klass[klass.length] = name
  removeClass = (name) ->
    re = new RegExp("\\b" + name + "\\b")
    html.className = html.className.replace(re, "")
  each = (arr, fn) ->
    i = 0
    arr_length = arr.length

    while i < arr_length
      fn.call arr, arr[i], i
      i++
  screenSize = ->
    w = window.outerWidth or html.clientWidth
    html.className = html.className.replace(RegExp(" (w|lt)-\\d+", "g"), "")
    pushClass "w-" + Math.round(w / 100) * 100
    each conf.screens, (width) ->
      pushClass "lt-" + width  if w <= width

    api.feature()
  html = doc.documentElement
  conf =
    screens: [ 320, 480, 640, 768, 1024, 1280, 1440, 1680, 1920 ]
    section: "-section"
    page: "-page"
    head: "head"

  klass = []
  if window.head_conf
    for key of head_conf
      conf[key] = head_conf[key]  if head_conf[key] isnt `undefined`
  api = window[conf.head] = ->
    api.ready.apply null, arguments_

  api.feature = (key, enabled, queue) ->
    unless key
      html.className += " " + klass.join(" ")
      klass = []
      return
    enabled = enabled.call()  if Object::toString.call(enabled) is "[object Function]"
    pushClass (if enabled then "" else "no-") + key
    api[key] = !!enabled
    unless queue
      removeClass "no-" + key
      removeClass key
      api.feature()
    api

  ua = navigator.userAgent.toLowerCase()
  ua = /(webkit)[ \/]([\w.]+)/.exec(ua) or /(opera)(?:.*version)?[ \/]([\w.]+)/.exec(ua) or /(msie) ([\w.]+)/.exec(ua) or not /compatible/.test(ua) and /(mozilla)(?:.*? rv:([\w.]+))?/.exec(ua) or []
  if ua[1] is "msie"
    ua[1] = "ie"
    ua[2] = document.documentMode or ua[2]
  pushClass ua[1]
  api.browser = version: ua[2]
  api.browser[ua[1]] = true
  if api.browser.ie
    pushClass "ie" + parseFloat(ua[2])
    ver = 3

    while ver < 11
      pushClass "lt-ie" + ver  if parseFloat(ua[2]) < ver
      ver++
    each "abbr|article|aside|audio|canvas|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video".split("|"), (el) ->
      doc.createElement el
  each location.pathname.split("/"), (el, i) ->
    if @length > 2 and this[i + 1] isnt `undefined`
      pushClass @slice(1, i + 1).join("-") + conf.section  if i
    else
      id = el or "index"
      index = id.indexOf(".")
      id = id.substring(0, index)  if index > 0
      html.id = id + conf.page
      pushClass "root" + conf.section  unless i

  screenSize()
  window.onresize = screenSize
  api.feature("js", true).feature()
) document
(->
  testProps = (props) ->
    for i of props
      return true  if style[props[i]] isnt `undefined`
  testAll = (prop) ->
    camel = prop.charAt(0).toUpperCase() + prop.substr(1)
    props = (prop + " " + domPrefs.join(camel + " ") + camel).split(" ")
    !!testProps(props)
  el = document.createElement("i")
  style = el.style
  prefs = " -o- -moz- -ms- -webkit- -khtml- ".split(" ")
  domPrefs = "Webkit Moz O ms Khtml".split(" ")
  head_var = window.head_conf and head_conf.head or "head"
  api = window[head_var]
  tests =
    gradient: ->
      s1 = "background-image:"
      s2 = "gradient(linear,left top,right bottom,from(#9f9),to(#fff));"
      s3 = "linear-gradient(left top,#eee,#fff);"
      style.cssText = (s1 + prefs.join(s2 + s1) + prefs.join(s3 + s1)).slice(0, -s1.length)
      !!style.backgroundImage

    rgba: ->
      style.cssText = "background-color:rgba(0,0,0,0.5)"
      !!style.backgroundColor

    opacity: ->
      el.style.opacity is ""

    textshadow: ->
      style.textShadow is ""

    multiplebgs: ->
      style.cssText = "background:url(//:),url(//:),red url(//:)"
      new RegExp("(url\\s*\\(.*?){3}").test style.background

    boxshadow: ->
      testAll "boxShadow"

    borderimage: ->
      testAll "borderImage"

    borderradius: ->
      testAll "borderRadius"

    cssreflections: ->
      testAll "boxReflect"

    csstransforms: ->
      testAll "transform"

    csstransitions: ->
      testAll "transition"

    fontface: ->
      ua = navigator.userAgent
      parsed = undefined
      return true  if 0
      return parsed[1] >= "4.0.249.4" or 1 * parsed[1].split(".")[0] > 5  if parsed = ua.match(/Chrome\/(\d+\.\d+\.\d+\.\d+)/)
      return parsed[1] >= "525.13"  if (parsed = ua.match(/Safari\/(\d+\.\d+)/)) and not /iPhone/.test(ua)
      return opera.version() >= "10.00"  if /Opera/.test({}.toString.call(window.opera))
      return parsed[1] >= "1.9.1"  if parsed = ua.match(/rv:(\d+\.\d+\.\d+)[^b].*Gecko\//)
      false

  for key of tests
    api.feature key, tests[key].call(), true  if tests[key]
  api.feature()
)()
((doc) ->
  one = (fn) ->
    return  if fn._done
    fn()
    fn._done = 1
  toLabel = (url) ->
    els = url.split("/")
    name = els[els.length - 1]
    i = name.indexOf("?")
    (if i isnt -1 then name.substring(0, i) else name)
  getScript = (url) ->
    script = undefined
    if typeof url is "object"
      for key of url
        if url[key]
          script =
            name: key
            url: url[key]
    else
      script =
        name: toLabel(url)
        url: url
    existing = scripts[script.name]
    return existing  if existing and existing.url is script.url
    scripts[script.name] = script
    script
  each = (arr, fn) ->
    return  unless arr
    arr = [].slice.call(arr)  if typeof arr is "object"
    i = 0

    while i < arr.length
      fn.call arr, arr[i], i
      i++
  isFunc = (el) ->
    Object::toString.call(el) is "[object Function]"
  allLoaded = (els) ->
    els = els or scripts
    loaded = undefined
    for name of els
      return false  if els.hasOwnProperty(name) and els[name].state isnt LOADED
      loaded = true
    loaded
  onPreload = (script) ->
    script.state = PRELOADED
    each script.onpreload, (el) ->
      el.call()
  preload = (script, callback) ->
    if script.state is `undefined`
      script.state = PRELOADING
      script.onpreload = []
      scriptTag
        src: script.url
        type: "cache"
      , ->
        onPreload script
  load = (script, callback) ->
    return callback and callback()  if script.state is LOADED
    return api.ready(script.name, callback)  if script.state is LOADING
    if script.state is PRELOADING
      return script.onpreload.push(->
        load script, callback
      )
    script.state = LOADING
    scriptTag script.url, ->
      script.state = LOADED
      callback()  if callback
      each handlers[script.name], (fn) ->
        one fn

      if allLoaded() and isDomReady
        each handlers.ALL, (fn) ->
          one fn
  scriptTag = (src, callback) ->
    s = doc.createElement("script")
    s.type = "text/" + (src.type or "javascript")
    s.src = src.src or src
    s.async = false
    s.onreadystatechange = s.onload = ->
      state = s.readyState
      if not callback.done and (not state or /loaded|complete/.test(state))
        callback.done = true
        callback()

    (doc.body or head).appendChild s
  fireReady = ->
    unless isDomReady
      isDomReady = true
      each domWaiters, (fn) ->
        one fn
  head = doc.documentElement
  isHeadReady = undefined
  isDomReady = undefined
  domWaiters = []
  queue = []
  handlers = {}
  scripts = {}
  isAsync = doc.createElement("script").async is true or "MozAppearance" of doc.documentElement.style or window.opera
  head_var = window.head_conf and head_conf.head or "head"
  api = window[head_var] = (window[head_var] or ->
    api.ready.apply null, arguments_
  )
  PRELOADED = 1
  PRELOADING = 2
  LOADING = 3
  LOADED = 4
  if isAsync
    api.js = ->
      args = arguments_
      fn = args[args.length - 1]
      els = {}
      fn = null  unless isFunc(fn)
      each args, (el, i) ->
        unless el is fn
          el = getScript(el)
          els[el.name] = el
          load el, (if fn and i is args.length - 2 then ->
            one fn  if allLoaded(els)
           else null)

      api
  else
    api.js = ->
      args = arguments_
      rest = [].slice.call(args, 1)
      next = rest[0]
      unless isHeadReady
        queue.push ->
          api.js.apply null, args

        return api
      if next
        each rest, (el) ->
          preload getScript(el)  unless isFunc(el)

        load getScript(args[0]), (if isFunc(next) then next else ->
          api.js.apply null, rest
        )
      else
        load getScript(args[0])
      api
  api.ready = (key, fn) ->
    if key is doc
      if isDomReady
        one fn
      else
        domWaiters.push fn
      return api
    if isFunc(key)
      fn = key
      key = "ALL"
    return api  if typeof key isnt "string" or not isFunc(fn)
    script = scripts[key]
    if script and script.state is LOADED or key is "ALL" and allLoaded() and isDomReady
      one fn
      return api
    arr = handlers[key]
    unless arr
      arr = handlers[key] = [ fn ]
    else
      arr.push fn
    api

  api.ready doc, ->
    if allLoaded()
      each handlers.ALL, (fn) ->
        one fn
    api.feature "domloaded", true  if api.feature

  if window.addEventListener
    doc.addEventListener "DOMContentLoaded", fireReady, false
    window.addEventListener "load", fireReady, false
  else if window.attachEvent
    doc.attachEvent "onreadystatechange", ->
      fireReady()  if doc.readyState is "complete"

    frameElement = 1
    try
      frameElement = window.frameElement
    if not frameElement and head.doScroll
      (->
        try
          head.doScroll "left"
          fireReady()
        catch e
          setTimeout arguments_.callee, 1
          return
      )()
    window.attachEvent "onload", fireReady
  if not doc.readyState and doc.addEventListener
    doc.readyState = "loading"
    doc.addEventListener "DOMContentLoaded", handler = ->
      doc.removeEventListener "DOMContentLoaded", handler, false
      doc.readyState = "complete"
    , false
  setTimeout (->
    isHeadReady = true
    each queue, (fn) ->
      fn()
  ), 300
) document
