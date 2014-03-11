{View} = require 'atom'

module.exports =
class PermuteView extends View
  @content: ->
    @div class: 'permute overlay from-top', =>
      @div "The Permute package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "permute:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "PermuteView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
