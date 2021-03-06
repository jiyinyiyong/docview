
store = require '../store'
action = require '../action'

Sidebar = require './sidebar'

module.exports = React.createClass
  displayName: 'reader-view'

  getInitialState: ->
    reading: store.getReading()
    posts: store.getPosts()

  componentDidMount: ->
    store.on @_onChange

  componentWillUnmount: ->
    store.remove @_onChange

  _onChange: ->
    @setState @getInitialState()

  render: ->
    readingPost = store.getReadingPost()

    $.div className: 'flex-row-fill',
      Sidebar {}
      $$.if readingPost?,
        -> $.div id: 'page', className: 'flex-column-fill',
          $.div className: 'flex-row-start ui-bar-title',
            $.span {},
              readingPost.title
            $.span
              className: 'ui-button-action'
              onClick: =>
                store.setMode 'editing'
              'Edit'
          $.div
            className: 'post markdown'
            dangerouslySetInnerHTML:
              __html: marked readingPost.content
        -> $.div className: 'flex-column-center ui-font-fill',
          'No post selected'