
port = 5021

server = require 'ws-json-server'
db = require './db'

time = -> (new Date).toISOString()

server.listen port, (ws) ->

  db.all (docs) ->
    ws.emit 'load', docs

  ws.on 'create', (post, res) ->
    post.time = time()
    db.create post, (doc) ->
      ws.broadcast 'create', doc
      res doc

  ws.on 'update', (post, res) ->
    db.update post, (doc) ->
      ws.broadcast 'update', doc
      res doc

  ws.on 'delete', (id, res) ->
    db.delete id, ->
      ws.broadcast 'delete', id
      res id

  ws.bind 'create', (post) ->
    ws.emit 'create', post

  ws.bind 'update', (post) ->
    ws.emit 'update', post

  ws.bind 'delete', (id) ->
    ws.emit 'delete', id

console.log "running at #{port}"