var language, o, page_layout, render, render_function, table_tr, tr_template;

render = (require('./json2page')).json2page;

o = console.log;

page_layout = function(table, title) {
  var template;
  template = {
    $html: {
      $head: {
        $title: title,
        $meta: {
          charset: 'utf-8'
        },
        $style: {
          '*': {
            'font-size': 12,
            'line-height': 18,
            'font-family': 'Monospace, wenquanyi micro hei mono'
          },
          td: {
            'min-width': 500,
            'vertical-align': 'top',
            background: '#eee',
            'text-align': 'top',
            'padding': 7
          },
          table: {
            'border': 0
          },
          'td>code': {
            padding: '0px 3px',
            margin: '0px 3px',
            background: '#ddd'
          },
          pre: {
            margin: 0
          },
          a: {
            'text-decoration': 'none'
          }
        }
      },
      $body: {
        $table: table
      }
    }
  };
  return render(template);
};

language = '';

tr_template = function(codes, notes) {
  var html;
  html = {
    $tr: {
      $td1: {
        $pre: {
          $code: {
            "class": language,
            $page: codes
          }
        }
      },
      $td2: {
        $page: notes
      }
    }
  };
  return render(html);
};

table_tr = function(arr) {
  var codes, line, notes, _i, _len;
  codes = [];
  notes = [];
  for (_i = 0, _len = arr.length; _i < _len; _i++) {
    line = arr[_i];
    line = line.replace(/</g, '&lt;').replace(/>/g, '&gt;');
    if (line.match(/^\s\s/)) {
      codes.push(line);
    } else {
      notes.push(line);
    }
  }
  codes = codes.map(function(line) {
    return line = line.slice(2);
  });
  codes = codes.join('\n');
  notes = notes.map(function(line) {
    return line = line.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/`([^`]*[^\\`]+)`/g, '<code>$1</code>').replace(/(https?:(\/\/)?(\S+))/g, '<a href="$1">$3</a>').replace(/#([^#]+[^\\])#/g, '<b>$1</b>');
  });
  notes = notes.join('<br>');
  return tr_template(codes, notes);
};

render_function = function(file_string, title, lang) {
  var cut_lines, differ, i, last_cut, lines, mark, tr_tags, _len, _ref,
    _this = this;
  language = lang;
  tr_tags = '';
  last_cut = -1;
  lines = file_string.split('\n');
  lines = lines.filter(function(line) {
    var p;
    p = line.match(/^\s*$/);
    if (p != null) {
      return false;
    } else {
      return true;
    }
  });
  cut_lines = function(index) {
    tr_tags += table_tr(lines.slice(last_cut + 1, index + 1 || 9e9));
    return last_cut = index;
  };
  differ = lines.map(function(line) {
    if ((line.match(/^\s\s+/)) != null) {
      return 'c';
    } else {
      return 'note';
    }
  });
  _ref = differ.slice(0, -1);
  for (i = 0, _len = _ref.length; i < _len; i++) {
    mark = _ref[i];
    if (mark === 'note' && differ[i + 1] === 'c') cut_lines(i);
  }
  cut_lines(lines.length - 1);
  return page_layout(tr_tags, title);
};

/*
fs = require 'fs'
fs.readFile 'text', 'utf-8', (err, data) ->
  throw err if err
  o render_function data, 'my title', 'CoffeeScript'
*/

if (exports) exports.render = render_function;
