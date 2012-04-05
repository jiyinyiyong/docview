
make_array = (arr) ->
  scope_lines = []

  for line in arr
    last_index = scope_lines.length - 1

    if last_index < 0
      scope_lines.push line.trimRight()
    else
      empty_line = line.match /^\s*$/
      if empty_line?
        if (typeof scope_lines[last_index]) is 'object'
          scope_lines[last_index].push ''
        else
          scope_lines.push ''
      else
        code_line = line.match /^\s\s.+$/
        if code_line?
          if (typeof scope_lines[last_index]) is 'object'
            scope_lines[last_index].push line[2..]
          else
            scope_lines.push [line[2..]]
        else
          scope_lines.push line

  output_array = []
  for item in scope_lines
    if (typeof item) is 'object'
      output_array.push (make_array item)
    else
      output_array.push item

  output_array

mark_line = (line) ->
  line.replace(/>/g,'&gt;')
    .replace(/</g,'&lt')
    .replace(/\t/g,'&nbsp;')
    .replace(/\s/g, '&nbsp;')
    .replace(/('[^(\\')]+[^\\]')/, '<span class="string">$1</span>')

comment_line = (line) ->
  line.replace(/`([^`]*[^\\`]+)`/g, '<code class="inline_code">$1</code>')
    .replace(/(https?:(\/\/)?\S+)/g, '<a href="$1">$1</a>')

make_html = (arr) ->
  html = ''
  for line in arr
    if typeof line is 'object'
      html += "<div class='code_block'>#{make_html line}</div>"
    else
      if line is '' then line = '&nbsp;'
      line = mark_line line
      html += "<p class='code_line'>#{line}</p>"
  html

data = """
dd1`rewr`
http:google.com

sfsdf
  sdfsdfs`fgdf`
    sdfsdfs
      ff
    dfg

    dgd
  dd
sdfsdfs '55555'

sdgs
sg sfg
"""

make_page = (arr) ->
  html = '<style>
    *{
      -webkit-box-sizing: border-box;
      box-sizing: border-box;
    }
    #lx_page{
      margin: 13px 26px;
      -webkit-box-shadow: 2px 4px 10px #a77;
      width: 800px;
      padding: 2px;
    }
    .code_block{
      width: 800px;
      background-color: hsl(56,96%,96%);
      margin-left: 20px;
      -webkit-box-shadow: 3px 2px 10px #daa;
      padding: 2px;
    }
    .code_line, .comment_line{
      line-height: 24px;
      font-size: 13px;
      margin: 0px;
    }
    .code_line{
      font-family: monospace;
    }
    .comment_line{
      font-family: wequanyi micro hei;
    }
    a{
      text-decoration: none;
      background-color: hsla(300,80%,70%,0.3);
    }
    .string{
      background-color: hsla(0,80%,70%,0.3);
    }
    .inline_code{
      background-color: hsla(20,90%,70%,0.3);
    }
    </style>'
  for line in arr
    if typeof line is 'object'
      html += "<div class='code_block'><code>#{make_html line}</code></div>"
    else
      if line is '' then line = '&nbsp;'
      line = comment_line (mark_line line)
      html += "<p class='comment_line'>#{line}</p>"
  "<div id='lx_page'>#{html}</div>"

console.log make_page (make_array (data.split '\n'))

if typeof exports is 'object' then exports.lx = 0