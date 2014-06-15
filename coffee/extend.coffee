
window.$ = React.DOM
window.$$ = $$ = {}

$$.switch = (name, registry) ->
  registry[name]()

$$.if = (cond, a, b) ->
  if cond then a() else b?()

$$.concat = (args...) ->
  list = []
  for arg in args
    list.push arg if arg?
  list.join(' ')

marked.setOptions
  renderer: new marked.Renderer()
  gfm: yes
  tables: yes
  breaks: yes
  pedantic: no
  sanitize: yes
  smartLists: yes
  smartypants: no
