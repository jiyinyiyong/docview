
store = require '../store'
action = require '../action'

module.exports = React.createClass
  displayName: 'app-view'

  componentDidMount: ->
    store.on 'change', =>
      @forceUpdate()

  render: ->
    $.div {},
      'hello'