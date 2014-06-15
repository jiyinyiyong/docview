
exports.EventEmitter = class
  constructor: ->
    @_queue = []

  on: (cb) ->
    unless cb in @_queue
      @_queue.push cb

  emit: ->
    for cb in @_queue
      cb()

  remove: (f) ->
    for cb, index in @_queue
      if cb is f
        @_queue.splice index, 1
        break