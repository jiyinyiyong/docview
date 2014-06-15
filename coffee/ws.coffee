
require("ws-json-browser")
.connect "localhost", 3000, (ws) ->

  exports.emit = (args...) ->
    ws.emit args...

  exports.on = (args...) ->
    ws.on args...

  exports.onload?()
