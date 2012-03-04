
require 'coffee-script'
compile = (require './json2page').render
o = console.log
fs = require 'fs'
url = require 'url'

server = (require 'http').createServer (req, res) ->
  parse = url.parse req.url
  path = parse.pathname
  query = parse.query
  raw = if query is 'raw' then true else false
  page = render path, raw, res
server.listen 8000

render = (path, raw, res) ->
  fs.stat at+path, (err, stats) ->
    if stats
      if stats.isDirectory() then dirview path, res
      else if raw then source path, res
      else fs.readFile at+path, 'utf8', (err, data) ->
        res.end data
    else source path, res

head = $head:
  $title: "T"
  $meta:
    charset: 'utf-8'

link = (dir) ->
  $p:
    $a:
      href: dir.p
      $text: 'Home' + dir.p
    $span: dir.o

at = __dirname
home = new RegExp (__dirname.replace /\//g, '\\/')

source = (path, res) ->
  fs.readFile at+path, 'utf8', (err, data) ->
    if err then data = (String err).replace home, 'Home'
    dir = parent path
    html = $html:
      $pipe: head
      $body:
        $pipe: link dir
        $pre:
          $code: data
    res.end compile html

parent = (path) ->
  if path is '/' then p:'/',o:''
  else
    if path[-1..] is '/' then path = path[0...-1]
    last = path.lastIndexOf '/'
    re =
      p: path[..last]
      o: path[last+1..]

dirview = (path, res) ->
  fs.readdir at+path, (err, list) ->
    dir = parent path
    html = $html:
      $pipe: head
      $body: link dir
    for file, index in list
      if path[-1..] isnt '/' then path += '/'
      line =
        $a:
          href: path+file+'?raw'
          $text: file
      html.$html.$body["$p#{index}"] = line
    res.end compile html