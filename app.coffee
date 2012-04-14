
ll = console.log
fs = require 'fs'
at = __dirname

head_type =
  'js':     'text/javascript'
  'coffee': 'text/javascript'
  'html':   'text/html'

page = (title, places, main) ->
  """
    <html>
      <head>
        <meta charset='utf-8'/>
        <title>#{title}</title>
        <style>
          a{text-decoration: none;}
          *{
            font-family: Monospace;
            font-size: 13px;
            line-height: 26px;
            letter-spacing: 1px;
          }
        </style>
      </head>
      <body>
        <nav>#{places}</nav>
        <div>#{main}</div>
      </body>
    </html>
  """

render_src = (data) ->
  return 'no source yet'

render_page =
  'lx':   (require './libs/liuxian').lx
  'md':   (require 'markdown').markdown.toHTML
  'note': (require './libs/codeNotes').render
  'src':  render_src

render_dir = (pathname) ->
  return 'nothing yet'

navigation = (pathname) ->
  return ['places', 'title']

url = require 'url'
require('http').createServer (req, res) ->
  parse = url.parse req.url
  pathname  = decodeURI parse.pathname
  type  = parse.query
  [places, title] = navigation pathname
  if type in ['md', 'lx', 'note', 'src']
    fs.readFile pathname[1..], 'utf-8', (err, data) ->
      main = render_page[type] data
      res.writeHead 200, 'text/html'
      res.end (page title, places, main)
  else if type in ['js', 'coffee', 'html']
    ll pathname
    fs.readFile pathname[1..], 'utf-8', (err, data) ->
      res.writeHead 200, head_type[type]
      res.end data
  else
    main = render_dir pathname[1..]
    res.writeHead 200, 'text/html'
    res.end (page title, places, main)
.listen if process.argv[2]? then Number process.argv[2] else 80