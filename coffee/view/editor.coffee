
store = require '../store'
action = require '../action'

module.exports = React.createClass
  displayName: 'editor-view'

  getInitialState: ->
    posts: store.getPosts()

  componentDidMount: ->
    store.on @_onChange

  componentWillUnmount: ->
    store.remove @_onChange

  _onChange: ->
    @setState @getInitialState()

  render: ->

    editingPost = store.getReadingPost()

    $.div className: 'flex-column-fill',
      $.div className: 'ui-bar-title',
        $.input
          value: editingPost.title
          onChange: (event) =>
            post =
              _id: editingPost._id
              title: event.target.value
              content: editingPost.content
            action.update post
        $.span
          className: 'ui-button-action'
          onClick: =>
            store.setMode 'reading'
          'Save'
        $.span
          className: 'ui-button-action'
          onClick: =>
            action.delete()
          'Delete'
      $.div className: 'flex-row-fill',
        $.textarea
          className: 'post'
          placeholder: "Start writing..."
          value: editingPost.content
          onChange: (event) =>
            post =
              _id: editingPost._id
              title: editingPost.title
              content: event.target.value
            action.update post
        $.div
          className: 'post markdown',
          dangerouslySetInnerHTML:
            __html: marked editingPost.content