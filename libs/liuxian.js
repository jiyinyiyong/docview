var comment_line, data, make_array, make_html, make_page, mark_line;

make_array = function(arr) {
  var code_line, empty_line, item, last_index, line, output_array, scope_lines, _i, _j, _len, _len2;
  scope_lines = [];
  for (_i = 0, _len = arr.length; _i < _len; _i++) {
    line = arr[_i];
    last_index = scope_lines.length - 1;
    if (last_index < 0) {
      scope_lines.push(line.trimRight());
    } else {
      empty_line = line.match(/^\s*$/);
      if (empty_line != null) {
        if ((typeof scope_lines[last_index]) === 'object') {
          scope_lines[last_index].push('');
        } else {
          scope_lines.push('');
        }
      } else {
        code_line = line.match(/^\s\s.+$/);
        if (code_line != null) {
          if ((typeof scope_lines[last_index]) === 'object') {
            scope_lines[last_index].push(line.slice(2));
          } else {
            scope_lines.push([line.slice(2)]);
          }
        } else {
          scope_lines.push(line);
        }
      }
    }
  }
  output_array = [];
  for (_j = 0, _len2 = scope_lines.length; _j < _len2; _j++) {
    item = scope_lines[_j];
    if ((typeof item) === 'object') {
      while (item.slice(-1)[0] === '') {
        output_array.push('&nbsp;');
        item.pop();
      }
      output_array.push(make_array(item));
    } else {
      output_array.push(item);
    }
  }
  return output_array;
};

mark_line = function(line) {
  return line.replace(/>/g, '&gt;').replace(/</g, '&lt').replace(/\t/g, '&nbsp;').replace(/\s/g, '&nbsp;').replace(/('[^(\\')]+[^\\]')/, '<span class="string">$1</span>');
};

comment_line = function(line) {
  return line.replace(/`([^`]*[^\\`]+)`/g, '<code class="inline_code">$1</code>').replace(/(https?:(\/\/)?\S+)/g, '<a href="$1">$1</a>').replace(/#(\w+)#/g, '<span class="bold">$1</span>');
};

make_html = function(arr) {
  var html, line, _i, _len;
  html = '';
  for (_i = 0, _len = arr.length; _i < _len; _i++) {
    line = arr[_i];
    if (typeof line === 'object') {
      html += "<div class='code_block'>" + (make_html(line)) + "</div>";
    } else {
      if (line === '') line = '&nbsp;';
      line = mark_line(line);
      html += "<p class='code_line'>" + line + "</p>";
    }
  }
  return html;
};

data = "dd1`rewr`\nhttp:google.com\n\nsfsdf\n  sdfsdfs`fgdf`\n    sdfsdfs\n      ff\n    dfg\n\n    dgd\n  dd\nsdfsdfs '55555'\n\nsdgs\nsg sfg";

make_page = function(arr) {
  var html, line, _i, _len;
  html = '<style>\
    *{\
      -webkit-box-sizing: border-box;\
      box-sizing: border-box;\
    }\
    #lx_page{\
      margin: 13px 26px;\
      -webkit-box-shadow: 1px 2px 20px #ddc;\
      width: 800px;\
      padding: 6px;\
    }\
    .code_block{\
      width: 800px;\
      background-color: white;\
      margin-left: 17px;\
      -webkit-box-shadow: 1px 2px 20px #ddc ;\
      padding: 0px 0px 0px 2px;\
      margin-top: 1px;\
    }\
    .code_line, .comment_line{\
      line-height: 24px;\
      font-size: 13px;\
      margin: 0px;\
    }\
    .code_line{\
      font-family: monospace;\
    }\
    .comment_line{\
      font-family: wequanyi micro hei;\
      color: hsl(0,80%,80%);\
    }\
    a{\
      text-decoration: none;\
      -webkit-box-shadow: 1px 2px 10px #daa;\
      background-color: hsla(300,80%,80%,0.2);\
    }\
    .string{\
      background-color: hsla(0,80%,80%,0.2);\
      -webkit-box-shadow: 1px 2px 10px #daa;\
    }\
    .inline_code{\
      background-color: hsla(20,90%,80%,0.2);\
      -webkit-box-shadow: 1px 2px 10px #daa;\
    }\
    .bold{\
      font-weight: bold;\
    }\
    </style>';
  for (_i = 0, _len = arr.length; _i < _len; _i++) {
    line = arr[_i];
    if (typeof line === 'object') {
      html += "<div class='code_block'><code>" + (make_html(line)) + "</code></div>";
    } else {
      if (line === '') line = '&nbsp;';
      line = comment_line(mark_line(line));
      html += "<p class='comment_line'>" + line + "</p>";
    }
  }
  return "<div id='lx_page'>" + html + "</div>";
};

if (typeof exports === 'object') {
  exports.lx = function(str) {
    var arr;
    arr = str.split('\n');
    return make_page(make_array(arr));
  };
}
