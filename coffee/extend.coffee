
window.$ = React.DOM
window.$$ = $$ = {}

$$.switch = (name, registry) ->
  registry[name]()

$$.if = (cond, a, b) ->
  if cond then a() else b?()

marked.setOptions
  renderer: new marked.Renderer()
  gfm: yes
  tables: yes
  breaks: yes
  pedantic: no
  sanitize: yes
  smartLists: yes
  smartypants: no
