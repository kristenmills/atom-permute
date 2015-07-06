RangeFinder = require './range-finder'

Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0..@length]
  value for key, value of output

module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', 'permute:shuffle', (event) ->
      editor = atom.workspace.getActiveTextEditor()
      shuffle(editor)
    atom.commands.add 'atom-workspace', 'permute:unique', (event) ->
      editor = atom.workspace.getActiveTextEditor()
      unique(editor)
    atom.commands.add 'atom-workspace', 'permute:reverse', (event) ->
      editor = atom.workspace.getActiveTextEditor()
      reverse(editor)

shuffle = (editor) ->
  shufflebleRanges = RangeFinder.rangesFor(editor)
  shufflebleRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n")
    for i in [textLines.length..1]
      j = Math.floor(Math.random() * (i+1))
      [textLines[i], textLines[j]] = [textLines[j], textLines[i]]
    editor.setTextInBufferRange(range, textLines.join("\n"))

unique = (editor) ->
  uniqueRanges = RangeFinder.rangesFor(editor)
  uniqueRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n").unique()
    editor.setTextInBufferRange(range, textLines.join("\n"))

reverse = (editor) ->
  reverseRanges = RangeFinder.rangesFor(editor)
  reverseRanges.forEach (range) ->
    textLines = editor.getTextInBufferRange(range).split("\n").reverse()
    editor.setTextInBufferRange(range, textLines.join("\n"))
