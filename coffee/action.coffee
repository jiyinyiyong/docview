
ws = require './ws'

exports.create = (name) ->
  post =
    title: name
    content: ''
    time: (new Date).toISOString()
  ws.emit 'create', post

exports.delete = (id) ->
  ws.emit 'delete', id

exports.update = (post) ->
  ws.emit 'update', post