
{EventEmitter} = require 'events'
ws = require './ws'

module.exports = exports = new EventEmitter

data =
  posts: []
  focus: undefined
  editing: no
  loaded: no

exports.findById = (id) ->
  for post in data.posts
    if post.id is id
      return post

exports.create = (post) ->
  data.posts.push post
  @emit 'change'

exports.update = (data) ->
  post = @findById data.id
  post.title = data.title
  post.content = data.content
  post.time = (new Date).toISOString()
  @emit 'change'

exports.delete = (id) ->
  for post, index in data.posts
    if post.id is id
      data.posts.splice index, 1
      break

exports.loaded = ->
  data.loaded = yes
  @emit 'change'