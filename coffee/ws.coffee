
require("ws-json-browser")
.connect 5021, (ws) ->

  exports.emit = (args...) ->
    ws.emit args...

  exports.on = (args...) ->
    ws.on args...

  exports.onload?()
