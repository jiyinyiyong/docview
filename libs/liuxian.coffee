
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
    .replace(/'[^']*[^\\]'/)

comment_line = (line) ->
  line.replace(/`([^`]*[^\\`]+)`/g, '<code id="inline_code">$1</code>')
    .replace(/(https?:(\/\/)?(\S+))/g, '<a href="$1">$3</a>')

if typeof exports is 'object' then exports.lx = 0

data = """
dd

sfsdf
  sdfsdfs
    sdfsdfs
    dfg

    dgd
  dd
sdfsdfs

sdgs
sg sfg
"""

console.log make_array (data.split '\n')