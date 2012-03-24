
compile = (require './libs/json2page').json2page
lx = (require './libs/liuxian').lx
makeHtml = (require './libs/showdown').makeHtml
make_note = (require './libs/codeNotes').render
o = console.log
fs = require 'fs'
url = require 'url'
port = if process.argv[2]? then Number process.argv[2] else 80

server = (require 'http').createServer (req, res) ->
  parse = url.parse req.url
  path = decodeURI parse.pathname
  type = parse.query
  page = render path, type, res
server.listen port

render = (path, type, res) ->
  fs.stat at+path, (err, stats) ->
    if stats
      if stats.isDirectory() then dirview   path, res
      else if type is 'raw'  then source    path, res
      else if type is 'lx'   then liuxian   path, res
      else if type is 'md'   then gfm       path, res
      else if type is 'html' then viewhtml  path, res
      else if type is 'note' then note_page path, res
      else if type is 'js'   then give_raw  path, res
      else give_raw path, res
    else give_raw path, res

template = (dir, main) ->
  $html:
    $head:
      $title: dir.own
      $meta:
        charset: 'utf-8'
      $style:
        '*':
          'font-family': 'Monospace'
          'font-size': 13
          'line-height': 26
          'letter-spacing': 1
        pre:
          margin: '0px 0px'
          padding: '0px 3px'
        'body>code, p>code':
          margin: '0px 3px'
          padding: '0px 3px'
          background: 'hsl(300,95%,95%)'
        a:
          'text-decoration': 'none'
        'body>pre, p>code':
          background: 'hsl(300,95%,95%)'
        '.modified_time':
          margin: '0px 10px'
          color: '#daa'
        table:
          '-webkit-border-vertical-spacing': 0
          '-webkit-border-horizontal-spacing': 0
        '.current':
          'margin-left': 100
        'tr:nth-child(2n)':
          background: 'hsl(340,98%,98%)'
        '.index':
          width: 66
          background: 'hsla(60,70%,80%,0.5)'
          color: 'hsl(0,70%,80%)'
    $body:
      $p:
        $a:
          href: dir.parent
          $text: 'Home' + dir.parent
        $span:
          class: 'current'
          $text: dir.own
      $pipe: main

at = __dirname
home = new RegExp (__dirname.replace /\//g, '\\/')

source = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
    if err then data = (String err).replace home, 'Home'
    dir = parent path
    data = data
      .replace(/>/g,'&gt;')
      .replace(/</g,'&lt;')
    main = $pre:
      $code: data
    sub = {}
    for line, index in data.split '\n'
      piece =
        $td:
          class: 'index'
          $text: "#{index}"
        $td1:
          $pre:
            $code: line
      sub["$tr#{index}"] = piece
    html = template dir, $table: sub
    res.end (compile html)

liuxian = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
    dir = parent path
    data = lx data
    html = template dir, data
    res.writeHead 200, 'Content-Type': 'text/html'
    res.end (compile html)

viewhtml = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
    res.writeHead 200, 'Content-Type': 'text/html'
    res.end data

note_page = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
    dir = parent path
    data = make_note data, path, 'coffee'
    res.end data

gfm = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
    dir = parent path
    data = makeHtml data
    html = template dir, data
    res.end (compile html)

parent = (path) ->
  if path is '/' then parent:'/',own:''
  else
    if path[-1..] is '/' then path = path[0...-1]
    last = path.lastIndexOf '/'
    re =
      parent: path[..last]
      own: path[last+1..]

dirview = (path, res) ->
  fs.readdir at+path, (err, list) ->
    dir = parent path
    main ={}
    for file, index in list
      if path[-1..] isnt '/' then path += '/'
      target = at+path+file
      isdir = false
      stat = fs.statSync target
      if stat.isDirectory() then isdir = true
      if isdir then file += '/'
      month = stat.mtime.getMonth()
      date = stat.mtime.getDate()
      hour = stat.mtime.getHours()
      min = stat.mtime.getMinutes()
      mtime = "#{month}/#{date} #{hour}:#{min}"
      line =
        $td:
          style:
            width: 200
          $a:
            href: path+file+'?raw'
            $text: file
            $text: file
        $td1:
          style:
            width: 100
          class: 'modified_time'
          $text: mtime
        $td2:
          style:
            width: 100
          $text: '_'
      subfix = file.match /\.(\w+)$/
      if subfix?
        type = subfix[1]
        if type in ['md', 'markdown', 'html', 'lx', 'note', 'js']
          line.$td2 =
            $a:
              href: path+file+"?#{type}"
              $text: "->#{type}"
      main["$tr#{index}"] = line
    html = template dir, $table: main
    res.end compile html

give_raw = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
      res.end data
