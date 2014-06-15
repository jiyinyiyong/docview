
window.$ = React.DOM
window.$$ = {}

store = require './store'
ws = require './ws'

AppView = require './view/app'

ws.onload = ->
  store.loaded()

  ws.on 'create', (post) ->
    store.create post

  ws.on 'update', (post) ->
    store.update post

  ws.on 'delete', (id) ->
    store.delete id

  console.log 'app started'

React.renderComponent (AppView {}),
  document.querySelector('body')