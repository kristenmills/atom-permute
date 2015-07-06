Permute = require '../lib/permute'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Permute", ->
  [activationPromise, editor, editorView] = []

  beforeEach ->
    editorView = atom.views.getView atom.workspace
    waitsForPromise ->
      Promise.all [
        activationPromise = atom.packages.activatePackage 'permute'
        atom.workspace.open().then (e) ->
          editor = e
      ]

  describe "when no lines are selected", ->
    it "filters out all lines", ->
      editor.setText """
        Apple
        Banana
        Apple
        Cheese
        Cool
      """

      editor.setCursorBufferPosition([0,0])

      atom.commands.dispatch editorView, "permute:unique"
      runs ->
        expect(editor.getText()).toBe """
          Apple
          Banana
          Cheese
          Cool\n
        """

    it "reverses all lines", ->
      editor.setText """
        Apple
        Banana
        Cheese
      """

      editor.setCursorBufferPosition([0,0])

      atom.commands.dispatch editorView, "permute:reverse"
      runs ->
        expect(editor.getText()).toBe """
          Cheese
          Banana
          Apple
        """

  describe "when entire lines are selected", ->
    it "filters out selected lines", ->
      editor.setText """
        Apple
        Banana
        Apple
        Cheese
        Cool
        Cheese
      """

      editor.setSelectedBufferRange([[1,0], [6,0]])

      atom.commands.dispatch editorView, "permute:unique"
      runs ->
        expect(editor.getText()).toBe """
          Apple
          Banana
          Apple
          Cheese
          Cool\n
        """

    it "reverse selected lines", ->
      editor.setText """
        Apple
        Banana
        Carrot
        Cheese
        Trees
      """

      editor.setSelectedBufferRange([[1,0], [5,0]])

      atom.commands.dispatch editorView, "permute:reverse"
      runs ->
        expect(editor.getText()).toBe """
          Apple
          Trees
          Cheese
          Carrot
          Banana
        """

  describe "when partial lines are selected", ->
    it "filters out selected lines", ->
      editor.setText """
        Apple
        Banana
        Apple
        Cheese
        Cool
        Cheese
      """

      editor.setSelectedBufferRange([[1,4], [5,7]])

      atom.commands.dispatch editorView, "permute:unique"
      runs ->
        expect(editor.getText()).toBe """
          Apple
          Banana
          Apple
          Cheese
          Cool\n
        """
    it "reverse selected lines", ->
      editor.setText """
        Apple
        Banana
        Carrot
        Cheese
        Trees
      """

      editor.setSelectedBufferRange([[1,1], [4,7]])

      atom.commands.dispatch editorView, "permute:reverse"
      runs ->
        expect(editor.getText()).toBe """
          Apple
          Trees
          Cheese
          Carrot
          Banana
        """

  describe "when there are multiple selection ranges", ->
    it "filters out the lines in each selection range", ->
      editor.setText """
        Apple
        Apple
        Banana
        Cool
        Cheese
        Cheese
      """

      editor.addSelectionForBufferRange([[0,0], [1,2]])
      editor.addSelectionForBufferRange([[3,0], [6,0]])

      atom.commands.dispatch editorView, "permute:unique"
      runs ->
        expect(editor.getText()).toBe """
          Apple\n
          Banana
          Cool
          Cheese\n
        """
    it "reverse the lines in each selecton range", ->
      editor.setText """
        Apple
        Banana
        Carrot
        Cheese
        Trees
        Potato
        Computer
      """

      editor.addSelectionForBufferRange([[0,0], [1,2]])
      editor.addSelectionForBufferRange([[3,0], [6,0]])

      atom.commands.dispatch editorView, "permute:reverse"
      runs ->
        expect(editor.getText()).toBe """
          Banana
          Apple
          Carrot
          Potato
          Trees
          Cheese
          Computer
        """
