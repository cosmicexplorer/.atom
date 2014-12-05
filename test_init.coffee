## functions
atom.commands.add 'atom-text-editor',
  'user:insert-date': (event) ->
    editor = @getModel()
    editor.insertText(new Date().toLocaleString())
