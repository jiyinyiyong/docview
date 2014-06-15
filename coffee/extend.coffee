
window.$ = React.DOM
window.$$ = $$ = {}

$$.switch = (name, registry) ->
  registry[name]()

$$.if = (cond, a, b) ->
  if cond then a() else b?()