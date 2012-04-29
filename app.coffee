
ll = console.log
fs = require 'fs'
path = require 'path'
url = require 'url'

head_type =
  'js':     'text/javascript'
  'coffee': 'text/coffeescript'
  'html':   'text/html'
  'css':    'text/css'
  'png':    'image/png'
  'jpg':    'image/jpg'

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
          font-size: 13px;
          letter-spacing: 1px;
          box-sizing: border-box;
        }
        body>*{
          padding: 2px auto;
        }
        body>nav>span{
          color: hsl(0,90%,90%);
        }
        body>div{
          margin: 20px auto 100px;
        }
        .navigation{
          text-align: center;
        }
      </style><!--
      <link rel='stylesheet'
        href='http://softwaremaniacs.org/media/style/style.css'>
      <script 
        src='http://softwaremaniacs.org/media/js/highlight.pack.js'>
      </script>
      <script>hljs.initHighlightingOnLoad();</script>-->
    </head>
    <body>
      <nav class='navigation'>#{places}</nav>
      <div>#{main}</div>
    </body>
  </html>
  "

table_style = "
  table{
    border-width: 0px;
    border-collapse: collapse;
    margin: 0px auto;
  }
  td{
    border-width: 0px;
    min-width: 300px;
    padding: 0px 20px 0px 0px;
  }
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
    tr{
      line-height: 22px;
    }
    pre{
      margin: 0px;
    }
  "
  lines = data.split('\n').map (x) ->
    if x is '' then ' ' else x
  line_count = lines.length
  line_index =''
  for num in [1..line_count]
    line_index+= "<span>#{num}</span><br>"
  code_paint = data.replace(/>/g,'&gt;').replace(/</g,'&lt;')
    .replace(/\s/,'&nbsp;')
  code_paint = "<pre><code>#{code_paint}</code></pre>"
  main = "<tr><td class='index'><code>#{line_index}</code></td><td>#{code_paint}</td></tr>"
  return "<style>#{table_style+src_style}</style><table>#{main}</table>"

render_page =
  'lx':   (require './libs/liuxian').lx
  'note': (require './libs/codeNotes').render
  'src':   render_src
  'md': (data) ->
    arr = data.split '\n'
    arr = arr.map (line) ->
      while line[-1..-1][0] is ' '
        line = line[...-1]
      return line
    data = arr.join '\n'
    return (require './libs/showdown').makeHtml data

render_dir = (long_path, pathname, dir_list) ->
  dir_style = "
    *{
      font-size: 14px;
    }
    tr>*:nth-child(2){
      color: hsl(0,80%,80%);
    }
    tr{
      height: 26px;
    }
    td{
      min-width: 300px;
      padding: 0px 10px;
    }
    tr:hover{background-color: hsl(200,90%,90%);}
  "
  main = ''
  for filename in dir_list.sort()
    if filename[0] is '.' then continue
    file_path = path.join pathname, filename
    fstat = fs.statSync path.join(long_path, filename)
    if fstat.isDirectory()
      filename += '/'
      default_view = '?dir'
    else
      default_view = '?src'
    m = fstat.mtime
    mtime = "#{m.getMonth()+1}/#{m.getDate()} #{m.getHours()}:#{m.getMinutes()}"
    subfix = ''
    find_subfix = filename.match /\.(\w+)(\?\w*)?$/
    if find_subfix?
      if find_subfix[1] in 'md note js coffee lx html png jpg'.split(' ')
        subfix = "<a href='/#{file_path}?#{find_subfix[1]}'>#{find_subfix[1]}</a>"
    main += "
      <tr>
        <td><a href='/#{file_path}#{default_view}'>#{filename}</a></td>
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
  long_path = path.join __dirname, pathname
  # add this line for NAE
  if pathname is '' then long_path += '/'
  # if there's no type to judge, add one if possible
  if path.existsSync(long_path)
    if (type is '' or not type?)
      find_subfix = pathname.match /\.(\w+)$/
      if find_subfix?
        if find_subfix[1] in 'js coffee html css png jpg'.split(' ')
          type = find_subfix[1]
    fstat = fs.statSync long_path
    if fstat.isDirectory()
      type = 'dir'
    if type in ['md', 'lx', 'note', 'src']
      fs.readFile long_path, 'utf-8', (err, data) ->
        main = render_page[type] data
        res.writeHead 200, 'Content-Type': 'text/html'
        res.end (page title, places, main)
    else if type in ['js', 'coffee', 'html','css']
      fs.readFile long_path, 'utf-8', (err, data) ->
        res.writeHead 200, 'Content-Type': head_type[type]
        res.end data
    else if type in ['jpg' ,'png']
      fs.readFile long_path, 'binary', (err, data) ->
        res.writeHead 200, 'Content-Type': head_type[type]
        res.write data, 'binary'
        res.end()
    else if type is 'dir'
      fs.readdir long_path, (err, dir_list) ->
        if err then dir_list = String err
        main = render_dir long_path, pathname, dir_list
        res.writeHead 200, 'Content-Type': 'text/html'
        res.end (page title, places, main)
    else
      res.writeHead 404, 'Content-Type': 'text/html'
      res.end '<title>= 404</title>sum (map (\\x -> (2^x+1)^2) [1..4])'
  else res.end '<title>404</title>file not exsit'
.listen if process.argv[2]? then Number process.argv[2] else 80
