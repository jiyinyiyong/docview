var liuxian;

liuxian = function(demo) {
  var html, line, lines, _i, _len;
  lines = demo.split('\n');
  html = [];
  for (_i = 0, _len = lines.length; _i < _len; _i++) {
    line = lines[_i];
    line = line.replace(/>/g, '&gt;').replace(/</g, '&lt');
    if (line.match(/^\/#/)) line = "<b>" + line.slice(2) + "</b>";
    if (line.match(/^\ \ /)) {
      line = "<pre><code>" + line.slice(2) + "</code></pre>";
      line = line.replace(/\t/g, '&nbsp;&nbsp');
    } else if (line.match(/^\t/)) {
      line = "<pre><code>" + line.slice(1) + "</code></pre>";
      line = line.replace(/\t/g, '&nbsp;&nbsp');
    } else {
      line = line.replace(/`([^`]*[^\\`]+)`/g, '<code>$1</code>');
      line = line.replace(/(https?:(\/\/)?(\S+))/g, '<a href="$1">$3</a>');
    }
    html.push(line);
  }
  html = html.join('<br>');
  html = html.replace(/<\/code><\/pre><br>(\s*)<pre><code>/g, '\n');
  return html = html.replace(/<\/pre><br>/g, '<\/pre>');
};

if (typeof exports === 'object') exports.lx = liuxian;
