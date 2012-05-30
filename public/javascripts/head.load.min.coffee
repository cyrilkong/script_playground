((a) ->
  z = ->
    d or (d = not 0
    s(e, (a) ->
      p a
    )
    )
  y = (c, d) ->
    e = a.createElement("script")
    e.type = "text/" + (c.type or "javascript")
    e.src = c.src or c
    e.async = not 1
    e.onreadystatechange = e.onload = ->
      a = e.readyState
      not d.done and (not a or /loaded|complete/.test(a)) and (d.done = not 0
      d()
      )

    (a.body or b).appendChild(e)
  x = (a, b) ->
    return b and b()  if a.state is o
    return k.ready(a.name, b)  if a.state is n
    if a.state is m
      return a.onpreload.push(->
        x a, b
      )
    a.state = n
    y(a.url, ->
      a.state = o
      b and b()
      s(g[a.name], (a) ->
        p a
      )
      u() and d and s(g.ALL, (a) ->
        p a
      )
    )
  w = (a, b) ->
    a.state is `undefined` and (a.state = m
    a.onpreload = []
    y(
      src: a.url
      type: "cache"
    , ->
      v a
    )
    )
  v = (a) ->
    a.state = l
    s(a.onpreload, (a) ->
      a.call()
    )
  u = (a) ->
    a = a or h
    b = undefined
    for c of a
      return not 1  if a.hasOwnProperty(c) and a[c].state isnt o
      b = not 0
    b
  t = (a) ->
    Object::toString.call(a) is "[object Function]"
  s = (a, b) ->
    unless not a
      typeof a is "object" and (a = [].slice.call(a))
      c = 0

      while c < a.length
        b.call a, a[c], c
        c++
  r = (a) ->
    b = undefined
    if typeof a is "object"
      for c of a
        a[c] and (b =
          name: c
          url: a[c]
        )
    else
      b =
        name: q(a)
        url: a
    d = h[b.name]
    return d  if d and d.url is b.url
    h[b.name] = b
    b
  q = (a) ->
    b = a.split("/")
    c = b[b.length - 1]
    d = c.indexOf("?")
    (if d isnt -1 then c.substring(0, d) else c)
  p = (a) ->
    a._done or (a()
    a._done = 1
    )
  b = a.documentElement
  c = undefined
  d = undefined
  e = []
  f = []
  g = {}
  h = {}
  i = a.createElement("script").async is not 0 or "MozAppearance" of a.documentElement.style or window.opera
  j = window.head_conf and head_conf.head or "head"
  k = window[j] = window[j] or ->
    k.ready.apply null, arguments_

  l = 1
  m = 2
  n = 3
  o = 4
  (if i then k.js = ->
    a = arguments_
    b = a[a.length - 1]
    c = {}
    t(b) or (b = null)
    s(a, (d, e) ->
      d isnt b and (d = r(d)
      c[d.name] = d
      x(d, (if b and e is a.length - 2 then ->
        u(c) and p(b)
       else null))
      )
    )

    k
   else k.js = ->
    a = arguments_
    b = [].slice.call(a, 1)
    d = b[0]
    unless c
      f.push ->
        k.js.apply null, a

      return k
    (if d then (s(b, (a) ->
      t(a) or w(r(a))
    )
    x(r(a[0]), (if t(d) then d else ->
      k.js.apply null, b
    ))
    ) else x(r(a[0])))
    k
  )
  k.ready = (b, c) ->
    if b is a
      (if d then p(c) else e.push(c))
      return k
    t(b) and (c = b
    b = "ALL"
    )
    return k  if typeof b isnt "string" or not t(c)
    f = h[b]
    if f and f.state is o or b is "ALL" and u() and d
      p c
      return k
    i = g[b]
    (if i then i.push(c) else i = g[b] = [ c ])
    k

  k.ready(a, ->
    u() and s(g.ALL, (a) ->
      p a
    )
    k.feature and k.feature("domloaded", not 0)
  )

  if window.addEventListener
    a.addEventListener("DOMContentLoaded", z, not 1)
    window.addEventListener("load", z, not 1)
  else if window.attachEvent
    a.attachEvent "onreadystatechange", ->
      a.readyState is "complete" and z()

    A = 1
    try
      A = window.frameElement
    not A and b.doScroll and ->
      try
        b.doScroll("left")
        z()
      catch a
        setTimeout arguments_.callee, 1
        return
    ()
    window.attachEvent("onload", z)
  not a.readyState and a.addEventListener and (a.readyState = "loading"
  a.addEventListener("DOMContentLoaded", handler = ->
    a.removeEventListener("DOMContentLoaded", handler, not 1)
    a.readyState = "complete"
  , not 1)
  )
  setTimeout(->
    c = not 0
    s(f, (a) ->
      a()
    )
  , 300)
) document
