
store = require './store'
ws = require './ws'

exports.create = (name) ->
  post =
    title: name
    content: ''
  ws.emit 'create', post

exports.delete = ->
  id = store.getReading()
  ws.emit 'delete', id

exports.update = (post) ->
  store.update post
  ws.emit 'update', post
