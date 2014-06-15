
server = require 'ws-json-server'

n = 0

id = ->
  n += 1
  n

time = ->
  (new Date).toISOString()

posts = []

server.listen 3000, (ws) ->

  ws.emit 'load', posts

  ws.on 'create', (post, res) ->
    post._id = id()
    post.time = time()
    posts.push post
    console.log posts
    res post

  ws.on 'update', (post, res) ->
    for item in posts
      if item._id is post._id
        item.title = post.title
        item.content = post.content
        item.time = time()
        console.log item
        res item
        break

  ws.on 'delete', (id, res) ->
    console.log 'delete', id
    for item, index in posts
      if item._id is id
        posts.splice index, 1
        console.log 'delete'
        res id
        break