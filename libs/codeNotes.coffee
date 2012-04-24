
render = (require './json2page').json2page
o = console.log

page_layout = (table, title) ->
  template = $html:
    $head:
      $title: title
      $meta:
        charset: 'utf-8'
      $style:
        body:
          margin: 0
        '*':
          'font-size': 13
          'line-height': 22
          'font-family': 'wenquanyi micro hei, arial'
        td:
          padding: '20px 10px'
          'min-width': 500
          'vertical-align': 'top'
          'text-align': 'top'
        tr:
          background: '#fff'
        'tr:nth-child(2n)':
          background: '#CEDAC1'
        table:
          border: 0
          width: '100%'
          'border-collapse': 'collapse'
        code: 
          'font-family': 'wenquanyi micro hei mono, monospace'
        'td>code':
          background: '#211'
          color: '#eef'
          padding: '1px 3px'
          margin: '1px 1px'
        pre:
          margin: 0
          'font-family': 'wenquanyi micro hei mono, monospace'
        a:
          'text-decoration': 'none'
          color: '#3737D5'
    $body:
      $table: table
  render template

language = ''

tr_template = (codes, notes) ->
  html = $tr:
    $td1:
      $pre:
        $code:
          class: language
          $page: codes
    $td2:
      $page: notes
  render html

table_tr = (arr) ->
  codes = []
  notes = []
  for line in arr
    line = line.replace(/</g,'&lt;').replace(/>/g,'&gt;')
    if line.match /^\s\s/ then codes.push line
    else notes.push line
  codes = codes.map (line) ->
    line = line[2..]
  codes = codes.join '\n'
  notes = notes.map (line) ->
    line = line.replace(/</g,'&lt;')
      .replace(/>/g,'&gt;')
      .replace(/`([^`]*[^\\`]+)`/g, '<code>$1</code>')
      .replace(/(https?:(\/\/)?(\S+))/g, '<a href="$1">$3</a>')
      .replace(/#([^\\\S]+)#/g, '<b>$1</b>')
  notes = notes.join '<br>'
  tr_template codes, notes

render_function = (file_string, title, lang) ->
  language = lang
  tr_tags = ''
  last_cut = -1
  lines = file_string.split '\n'
  lines = lines.filter (line) ->
    p = line.match /^\s*$/
    if p? then false else true
  cut_lines = (index) =>
    tr_tags += table_tr lines[last_cut+1..index]
    last_cut = index
  differ = lines.map (line) ->
    if (line.match /^\s\s+/)? then 'c' else 'note'
  for mark, i in differ[...-1]
    cut_lines i if mark is 'note' and differ[i+1] is 'c'
  cut_lines lines.length-1
  page_layout tr_tags, title

###
fs = require 'fs'
fs.readFile 'text', 'utf-8', (err, data) ->
  throw err if err
  o render_function data, 'my title', 'CoffeeScript'
###

exports.render = render_function if exports
