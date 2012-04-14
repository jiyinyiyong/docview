
ll = console.log
fs = require 'fs'
path = require 'path'
url = require 'url'
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
  td{
    border-width: 0px;
    padding: 0px 20px 0px 0px;
  }
  tr:hover{background-color: hsl(200,90%,90%);}
"

render_src = (data) ->
  src_style = "
    tr>*:nth-child(1){
      min-width: 80px;
      background-color: hsla(80,10%,92%,0.7);
      color: hsl(12,85%,70%);
      text-align: right;
    }
    tr>*:nth-child(2){
      min-width: 900px;
      background-color: hsla(80,10%,96%,0.7);
    }
    .indent{
      display: inline;
      background: -webkit-gradient(
        linear, 0 0, 100% 0,
        from(hsla(80,10%,97%,0.7)), to(hsla(80,10%,95%,0.7)));
    }
    tr{
      height: 20px;
    }
    tr:hover{background-color: hsl(200,90%,90%);}
  "
  main = ''
  lines = data.split '\n'
  for line, index in lines
    line = line.replace(/>/g,'&gt;')
      .replace(/</g,'&lt;')
      .replace(/\s\s/g, '<div class="indent">&nbsp;&nbsp;</div>')
    main += "<tr><td>#{index}</td><td>#{line}</td></tr>"
  return "<style>#{table_style+src_style}</style><table>#{main}</table>"

render_page =
  'lx':   (require './libs/liuxian').lx
  'md':   (require 'markdown').markdown.toHTML
  'note': (require './libs/codeNotes').render
  'src':   render_src

render_dir = (pathname, dir_list) ->
  dir_style = "
    tr>*:nth-child(1){
      min-width: 200px;
    }
    tr>*:nth-child(2){
      min-width: 130px;
      color: hsl(0,80%,80%);
    }
    tr{
      height: 26px;
    }
  "
  main = ''
  for filename in dir_list
    if filename[0] is '.' then continue
    file_path = path.join pathname, filename
    fstat = fs.statSync file_path
    if fstat.isDirectory() then filename += '/'
    m = fstat.mtime
    mtime = "#{m.getMonth()+1}/#{m.getDate()} #{m.getHours()}:#{m.getMinutes()}"
    subfix = ''
    find_subfix = filename.match /\.(\w+)$/
    if find_subfix?
      if find_subfix[1] in ['md', 'note', 'js', 'coffee', 'lx', 'html']
        subfix = "<a href='/#{file_path}?#{find_subfix[1]}'>#{find_subfix[1]}</a>"
    main += "
      <tr>
        <td><a href='/#{file_path}'>#{filename}</a></td>
        <td>#{mtime}</td>
        <td>#{subfix}</td>
      </tr>
    "
  return "<style>#{table_style+dir_style}</style><table>#{main}</table>"

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
  title = folders[-1..-1][0] or 'Home'
  if folders.length > 0
    places += title
  else places = places[...-16]
  return [places, title]

require('http').createServer (req, res) ->
  parse = url.parse req.url
  pathname  = (decodeURI parse.pathname)[1..]
  type  = parse.query
  [places, title] = navigation pathname
  if pathname is '' then pathname = '.'
  # if there's no type to judge, add one if possible
  if path.existsSync(pathname)
    if (type is '' or not type?)
      stat = fs.statSync pathname
      # ll stat
      if stat.isDirectory()
        type = 'dir'
      else type = 'src'
    # ll type
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
      fs.readdir pathname, (err, dir_list) ->
        if err then dir_list = String err
        main = render_dir pathname, dir_list
        res.writeHead 200, 'text/html'
        res.end (page title, places, main)
    else
      res.writeHead 404, 'Content-Type': 'text/html'
      res.end '<title>= 404</title>sum (map (\\x -> (2^x+1)^2) [1..4])'
  else res.end '<title>404</title>file not exsit'
.listen if process.argv[2]? then Number process.argv[2] else 80