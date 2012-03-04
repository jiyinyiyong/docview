
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
		else
		  line = line.replace /`([^`]*[^\\`]+)`/g, '<code>$1</code>'
		html.push line
	html = html.join '<br>'
	html = html.replace /<\/code><\/pre><br>(\s*)<pre><code>/g, '\n'

if typeof exports is 'object' then exports.lx = liuxian