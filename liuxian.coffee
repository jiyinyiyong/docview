
liuxian = (demo) ->
  lines = demo.split '\n'
  html = []
  for line in lines
    line = line
      .replace(/>/g,'&gt;')
      .replace(/</g,'&lt')
    if line.match /^\/#/ then line = "<b>#{line[2..]}</b>"
    if line.match /^\ \ /
      line = "<pre><code>#{line[2..]}</code></pre>"
      line = line.replace /\t/g, '&nbsp;&nbsp'
    else if line.match /^\t/
      line = "<pre><code>#{line[1..]}</code></pre>"
      line = line.replace /\t/g, '&nbsp;&nbsp'
    else
      line = line.replace /`([^`]*[^\\`]+)`/g, '<code>$1</code>'
      line = line.replace /(https?:(\/\/)?(\S+))/g, '<a href="$1">$3</a>'
    html.push line
  html = html.join '<br>'
  html = html.replace /<\/code><\/pre><br>(\s*)<pre><code>/g, '\n'
  html = html.replace /<\/pre><br>/g, '<\/pre>'

if typeof exports is 'object' then exports.lx = liuxian