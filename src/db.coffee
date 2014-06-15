
mongoose = require 'mongoose'
{Schema} = mongoose

mongoose.connect 'mongodb://localhost/docview'

postSchema = Schema
  title: String
  time: Date
  content: String

Post = mongoose.model 'Post', postSchema

exports.all = (cb) ->
  Post.find (err, docs) ->
    cb docs

exports.create = (data, cb) ->
  post = new Post data
  post.save (err, newPost) ->
    cb newPost

exports.update = (data, cb) ->
  cond = _id: data._id
  Post.findOne cond, (err, post) ->
    if post?
      post.title = data.title
      post.content = data.content
      post.save (err, newPost) ->
        cb newPost

exports.delete = (id, cb) ->
  cond = _id: id
  Post.findOne cond, (err, post) ->
    post?.remove()
    cb()