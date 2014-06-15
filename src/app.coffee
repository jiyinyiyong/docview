
server = require 'ws-json-server'

db = require './db'

time = ->
  (new Date).toISOString()

server.listen 3000, (ws) ->

  db.all (docs) ->
    ws.emit 'load', docs

  ws.on 'create', (post, res) ->
    post.time = time()
    db.create post, (doc) ->
      res post

  ws.on 'update', (post, res) ->
    db.update post, (doc) ->
      res doc

  ws.on 'delete', (id, res) ->
    db.delete id, ->
      res id