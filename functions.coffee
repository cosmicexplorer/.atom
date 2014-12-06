## includes
clipboard = require('clipboard')

# TODO: eval-expression
# DONE: kill-line-or-region, comment-dwim, forward/backward-paragraph,
# tab-dwim (emacs-flow), expand-current-pane

## TODO: customize comment-dwim to add different languages!

## utility functions
# TODO: make this work
atom.commands.add 'atom-text-editor',
  'user:reload-things': (event) ->
    atom.keymaps.loadUserKeymap()
    atom.requireUserInitScript()

moveToPoint = (editor, point) ->
  if !editor.getCursorBufferPosition().isEqual(point)
    if editor.getCursorBufferPosition().isLessThan(point)
      editor.moveRight() while editor.getCursorBufferPosition().isLessThan(point)
    else
      editor.moveLeft() while editor.getCursorBufferPosition().isGreaterThan(point)

getFollowingChar = (editor) ->
  curPosn = editor.getCursorBufferPosition()
  editor.moveToBottom()
  endPosn = editor.getCursorBufferPosition()
  if curPosn.isEqual(endPosn)
    null
  else
    moveToPoint(editor, curPosn)
    editor.moveRight()
    curPlusOne = editor.getCursorBufferPosition()
    followingChar = editor.getTextInBufferRange([curPosn.toArray(), curPlusOne.toArray()])
    moveToPoint(editor, curPosn)
    followingChar

getPrecedingChar = (editor) ->
  curPosn = editor.getCursorBufferPosition()
  editor.moveLeft()
  precedingChar = getFollowingChar(editor)
  moveToPoint(editor, curPosn)
  precedingChar

## killing text
initKillRing = ->
  atom.killRing = []
  atom.killRingPointer = -1

killLine = (editor) ->
  startPosn = editor.getCursorBufferPosition()
  editor.moveToEndOfLine()
  endPosn = editor.getCursorBufferPosition()
  moveToPoint(editor, startPosn)
  textToCopy = editor.getTextInBufferRange([startPosn.toArray(), endPosn.toArray()])
  editor.deleteToEndOfLine()
  textToCopy

killRegion = (editor) ->
  textToCopy = editor.getSelectedText()
  editor.cutSelectedText()
  textToCopy

atom.commands.add 'atom-text-editor',
  'user:kill-line-or-region': (event) ->
    editor = @getModel()
    initKillRing() if !atom.killRing
    if editor.getSelectedText().length == 0
      textToCopy = killLine(editor)
    else
      textToCopy = killRegion(editor)
    atom.killRing.unshift(textToCopy)
    atom.killRingPointer = 0
    clipboard.writeText(textToCopy)

atom.commands.add 'atom-text-editor',
  'user:yank-text': (event) ->
    editor = @getModel()
    initKillRing() if !atom.killRing
    if atom.killRing.length > 0 and clipboard.readText() == atom.killRing[atom.killRingPointer]
      editor.insertText(atom.killRing[atom.killRingPointer])
    else editor.insertText(clipboard.readText())

atom.commands.add 'atom-text-editor',
  'user:reset-yank-pointer': (event) ->
    initKillRing() if !atom.killRing
    atom.killRingPointer = 0

# ONLY USE AFTER A YANK
atom.commands.add 'atom-text-editor',
  'user:increment-yank-pointer': (event) ->
    editor = @getModel()
    atom.killRingPointer = (atom.killRingPointer + 1) % atom.killRing.length
    editor.undo()
    editor.insertText(atom.killRing[atom.killRingPointer])

# ALSO ONLY USE AFTER A YANK
atom.commands.add 'atom-text-editor',
  'user:decrement-yank-pointer': (event) ->
    editor = @getModel()
    atom.killRingPointer-- if atom.killRingPointer > 0
    editor.undo()
    editor.insertText(atom.killRing[atom.killRingPointer])

## comment-dwim
atom.commands.add 'atom-text-editor',
  'user:comment-dwim': (event) ->
    editor = @getModel()
    if editor.getSelectedText().length > 0
      editor.toggleLineCommentsInSelection()
    else
      startPosn = editor.getCursorBufferPosition()
      editor.moveToEndOfLine()
      endPosn = editor.getCursorBufferPosition()
      editor.moveToBeginningOfLine()
      beginLinePosn = editor.getCursorBufferPosition()
      textInLine = editor.getTextInBufferRange([beginLinePosn.toArray(), endPosn.toArray()])
      editor.moveToEndOfLine()
      curGrammar = editor.getGrammar()
      # add your language here!
      if curGrammar.name == "CoffeeScript"
        commentChar = "\#"
      else
        commentChar = "\#"
        # if not comment
      if startPosn.isEqual(endPosn) and
      textInLine.search("^[ \t\n\r]*$") == -1 and # empty line
      textInLine.search("#{commentChar}[ \t\n\r]*$") == -1 and # only comment
      textInLine.search("^[ \t\n\r]*#{commentChar}") == -1 # line already comm.
        editor.insertText(" #{commentChar} ")
        # if ends in margin comment
        # to be used strictly with point at end of line
      else if textInLine.search("#{commentChar}[ \t\n\r]*$") != -1
        editor.moveLeft()
        editor.moveLeft()
        editor.moveLeft()
        # for languages like C++ with multi-char comments
        if curGrammar.name == ""
          editor.moveLeft()
        editor.deleteToEndOfLine()
      else
        editor.toggleLineCommentsInSelection()

## paragraph motion
atom.commands.add 'atom-text-editor',
  'user:forward-paragraph': (event) ->
    @getModel().moveToBeginningOfNextParagraph()

atom.commands.add 'atom-text-editor',
  'user:backward-paragraph': (event) ->
    @getModel().moveToBeginningOfPreviousParagraph()

## expand window pane to all of workspace
# TODO: fix so uses @ instead of directly accessing globals
atom.commands.add 'atom-text-editor',
  'user:expand-current-pane': (event) ->
    prevView = atom.workspaceView.getActivePaneView()
    atom.workspaceView.focusNextPaneView()
    while atom.workspaceView.getActivePaneView() != prevView
      atom.workspaceView.destroyActivePane()
      atom.workspaceView.focusNextPaneView()
