
store = require '../store'
action = require '../action'

PostItem = React.createClass
  displayName: 'post-item'

  render: ->

    $.div
      className: 'post-item ui-line'
      onClick: =>
        store.setReading @props.data._id
      @props.data.title

module.exports = React.createClass
  displayName: 'table-view'

  componentDidMount: ->
    store.on 'change', @_onChange

  componentWillUnmount: ->
    store.removeListener 'change', @_onChange

  getInitialState: ->
    posts: store.getPosts()

  _onChange: ->
    @setState @getInitialState()

  render: ->
    posts = store.getPosts()

    postItems = posts
    .filter (post) =>
      post.title.indexOf(@props.data) >= 0
    .map (post) =>
      PostItem data: post, key: post._id

    $.div {},
      postItems