
compile = (require './libs/json2page').render
lx = (require './libs/liuxian').lx
makeHtml = (require './libs/showdown').makeHtml
o = console.log
fs = require 'fs'
url = require 'url'
compile_jade = (require 'jade').compile

server = (require 'http').createServer (req, res) ->
  parse = url.parse req.url
  path = decodeURI parse.pathname
  type = parse.query
  page = render path, type, res
server.listen 8000

render = (path, type, res) ->
  fs.stat at+path, (err, stats) ->
    if stats
      if stats.isDirectory() then dirview path, res
      else if type is 'raw' then source path, res
      else if type is 'lx' then liuxian path, res
      else if type is 'md' then gfm path, res
      else if type is 'html' then viewhtml path, res
      else if type is 'jade' then jade2html path, res
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
          'font-family': 'Wenquanyi Micro Hei Mono'
          'font-size': '13px'
          'line-height': 26
        pre:
          margin: '0px 0px'
          background: 'hsl(300,95%,95%)'
          padding: '0px 3px'
        a:
          'text-decoration': 'none'
        'body>code':
          padding: '0px 3px'
          background: 'hsl(300,95%,95%)'
    $body:
      $p:
        $a:
          href: dir.parent
          $text: 'Home' + dir.parent
        $span:
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
    html = template dir, main
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

jade2html = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
    dir = parent path
    data = do compile_jade data
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
    html = template dir, ''
    for file, index in list
      if path[-1..] isnt '/' then path += '/'
      target = at+path+file
      isdir = false
      if (fs.statSync target).isDirectory() then isdir = true
      if isdir then file += '/'
      line =
        $a:
          href: path+file+'?raw'
          $text: file
      if file.match /\.(md)|(markdown)$/
        line.$span1 = ' '
        line.$a1 =
          href: path+file+'?md'
          $text: '->Markdown'
      if file.match /\.(html?)|(markdown)$/
        line.$span2 = ' '
        line.$a2 =
          href: path+file+'?html'
          $text: '->HTML'
      if file.match /\.(jade?)|(markdown)$/
        line.$span3 = ' '
        line.$a3 =
          href: path+file+'?jade'
          $text: '->HTML'
      if file.match /\.lx$/
        line.$span4 = ' '
        line.$a4 =
          href: path+file+'?lx'
          $text: '->LiuXian'
      html.$html.$body["$p#{index}"] = line
    res.end compile html

give_raw = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
      res.end data
