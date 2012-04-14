
ll = console.log
fs = require 'fs'
at = __dirname

head_type =
  'js':     'text/javascript'
  'coffee': 'text/javascript'
  'html':   'text/html'

page = (title, places, main) ->
  "<html>
    <head>
      <meta charset='utf-8'/>
      <title> #{title} </title>
      <style>
        a{
          text-decoration: none;
          color: hsl(240,80%,80%);
        }
        *{
          font-family: Monospace;
          font-size: 14px;
          letter-spacing: 0px;
          box-sizing: border-box;
        }
        body>nav>span{
          color: hsl(0,90%,90%);
        }
        body>div{
          margin: 20px auto 100px;
        }
      </style>
    </head>
    <body>
      <nav>#{places}</nav>
      <div>#{main}</div>
    </body>
  </html>
  "

table_style = "
  table{
    border-width: 0px;
    border-collapse:collapse
  }
  tr{
    height: 20px;
  }
  td{
    border-width: 0px;
    padding: 0px 20px 0px 0px;
  }
"

render_src = (data) ->
  src_style = "
    tr>*:nth-child(1){
      min-width: 80px;
      background-color: hsl(80,10%,92%);
      color: hsl(12,85%,70%);
      text-align: right;
    }
    tr>*:nth-child(2){
      min-width: 900px;
      background-color: hsl(80,10%,96%);
    }
  "
  main = ''
  lines = data.split '\n'
  for line, index in lines
    line = line.replace(/>/g,'&gt;')
      .replace(/</g,'&lt;')
      .replace(/\s/g, '&nbsp;')
    main += "<tr><td>#{index}</td><td><code>#{line}</code></td></tr>"
  return "<style>#{table_style+src_style}</style><table>#{main}</table>"

render_page =
  'lx':   (require './libs/liuxian').lx
  'md':   (require 'markdown').markdown.toHTML
  'note': (require './libs/codeNotes').render
  'src':   render_src

render_dir = (pathname) ->
  return 'nothing yet'

navigation = (pathname) ->
  # pathname supposed to be like 'path_a/path_b'
  folders = pathname.split('/').filter (folder) ->
    if folder.length > 0 then true else false
  places = '<a href="/">Home</a> <span>/</span> '
  part_range = if folders.length<1 then 0 else folders.length-1
  for index in [0...part_range]
    part_path_arr = folders[0..index]
    part_path = '/' + part_path_arr.join('/')
    places += "<a href='#{part_path}'>#{folders[index]}</a> <span>/</span> "
  # if '/' path called, the '/' behined  'home' should be removed
  title = folders[-1..-1][0]
  if folders.length > 0
    places += title
  else places = places[...-16]
  return [places, title]

url = require 'url'

path = require 'path'
require('http').createServer (req, res) ->
  parse = url.parse req.url
  pathname  = (decodeURI parse.pathname)[1..]
  type  = parse.query
  [places, title] = navigation pathname
  if pathname is '' then pathname = '.'
  # if there's no type to judge, add one if possible
  if type is '' or not type? and  path.existsSync(pathname)
    stat = fs.statSync pathname
    if stat.isDirectory
      type = 'dir'
    else type = 'src'
  if type in ['md', 'lx', 'note', 'src']
    fs.readFile pathname, 'utf-8', (err, data) ->
      main = render_page[type] data
      res.writeHead 200, 'Content-Type': 'text/html'
      res.end (page title, places, main)
  else if type in ['js', 'coffee', 'html']
    fs.readFile pathname, 'utf-8', (err, data) ->
      res.writeHead 200, head_type[type]
      res.end data
  else if type is 'dir'
    main = render_dir pathname
    res.writeHead 200, 'text/html'
    res.end (page title, places, main)
  else
    res.writeHead 404, 'Content-Type': 'text/html'
    res.end '<title>= 404</title>sum (map (\\x -> (2^x+1)^2) [1..4])'
.listen if process.argv[2]? then Number process.argv[2] else 80