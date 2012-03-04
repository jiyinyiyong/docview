
json2page = (data) ->
  if typeof data is 'string' then return ">#{data}"
  html = ''
  attrs = []
  tags = []
  for key, value of data
    parse = key.match /^(\w*)\$(\w*)$/
    if parse then tags.push id: parse[1], tag: parse[2], value: value
    else if check = key.match /^[a-zA-Z_]\w+$/ then attrs.push key
  css = []
  for item in attrs
    if item.match /^style\d*$/ then css.push item
    else if typeof data[item] is 'string' then html += "#{item}='#{data[item]}'"
  if css.length > 0
    html += "style='"
    for item in css
      for key, value of data[item]
        html += "#{key}:"
        if typeof value is 'string' then html += "#{value};"
        else html += "#{value}px;"
    html += "'"
  html += '>'
  for item in tags
    if item.tag.match /^pipe\d*$/ then html += (json2page item.value)[1..] else
      _id = item.id
      _tag = item.tag || 'div'
      match = _tag.match /^([a-z]+)\d*$/
      if _tag.match /^text\d*$/ then html += item.value else
        html += "<#{match[1]} "
        html += "id='#{_id}'" if _id
        if _tag.match /^style\d*$/
          html += '>'
          html += render_style item.value
          html += '</style>'
        else
          html += json2page item.value
          html += "</#{match[1]}>"
  return html

render_style = (data) ->
  style = ''
  for key, value of data
    style += "#{key}\{"
    for attr, content of value
      if match = attr.match /^([a-z-]+)\d*$/
        style += "#{match[1]}:"
      if typeof value is 'number' then style += "#{content}px;" else
        style += "#{content};"
    style += '\}'
  return style
      
err = (e) ->
  o 'Error: ', e
o = console.log or (v...)->null

out = (data) ->
  (json2page data)[1..]

if typeof window is 'object' then window.render = out
if typeof exports is 'object' then exports.render = out