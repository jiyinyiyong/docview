
{EventEmitter} = require 'events'
ws = require './ws'

module.exports = exports = new EventEmitter

data =
  mode: 'loading'
  reading: undefined
  posts: []

findById = (id) ->
  for post in data.posts
    if post._id is id
      return post

# on mode

exports.setMode = (name) ->
  data.mode = name
  @emit 'change'

exports.getMode = ->
  data.mode

# on reading

exports.setReading = (id) ->
  data.reading = id
  @emit 'change'

exports.getReading = ->
  data.reading

exports.getReadingPost = ->
  for post in data.posts
    if post._id is data.reading
      return post

# on posts

exports.getPosts = ->
  data.posts

exports.setPosts = (posts) ->
  data.posts = posts
  data.mode = 'reading'
  @emit 'change'

# more on posts

exports.create = (post) ->
  data.posts.push post
  exports.setReading post._id
  @emit 'change'

exports.update = (data) ->
  post = findById data._id
  post.title = data.title
  post.content = data.content
  @emit 'change'

exports.delete = (id) ->
  for post, index in data.posts
    if post._id is id
      data.posts.splice index, 1
      if data.reading is id
        data.reading = undefined
        data.mode = 'reading'
      @emit 'change'
      break
