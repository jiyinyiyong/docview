
store = require '../store'
action = require '../action'

ReaderView = require './reader'
EditorView = require './editor'

module.exports = React.createClass
  displayName: 'app-view'

  getInitialState: ->
    mode: 'loading'

  componentDidMount: ->
    store.on @_onChange

  componentWillUnmount: ->
    store.remove @_onChange

  _onChange: ->
    @setState mode: store.getMode()

  render: ->
    $$.switch @state.mode,
      loading: =>
        $.div className: 'flex-column-center',
          $.span className: 'ui-font-fill',
            'DocView is loading...'

      reading: =>
        ReaderView {}

      editing: =>
        EditorView {}