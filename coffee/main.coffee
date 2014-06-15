
require './extend'
store = require './store'
ws = require './ws'

AppView = require './view/app'

ws.onload = ->

  ws.on 'create', (post) ->
    store.create post

  ws.on 'update', (post) ->
    store.update post

  ws.on 'delete', (id) ->
    store.delete id

  ws.on 'load', (posts) ->
    store.setPosts posts

React.renderComponent (AppView {}),
  document.querySelector('body')