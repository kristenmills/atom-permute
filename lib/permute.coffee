PermuteView = require './permute-view'

module.exports =
  permuteView: null

  activate: (state) ->
    @permuteView = new PermuteView(state.permuteViewState)

  deactivate: ->
    @permuteView.destroy()

  serialize: ->
    permuteViewState: @permuteView.serialize()
