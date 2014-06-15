
store = require '../store'
action = require '../action'

TableView = require './table'

module.exports = React.createClass
  displayName: 'sidebar-view'

  getInitialState: ->
    query: ''

  render: ->
    hasText = @state.query.length > 0

    $.div className: 'flex-column-fill ui-bar-side',
      $.input
        id: 'header', ref: 'query'
        className: 'ui-bar-title'
        value: @state.query
        placeholder: 'Type to search...'
        onChange: =>
          el = @refs.query.getDOMNode()
          @setState query: el.value
      $.div id: 'table',
        TableView data: @state.query
        $$.if hasText,
          => $.div
            id: 'create', className: 'ui-button-action'
            onClick: =>
              action.create @state.query
              @setState query: ''
            'Create'