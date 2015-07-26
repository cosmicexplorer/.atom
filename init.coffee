require('./functions.coffee')

# destroy default keybindings
keybindingsToRemove = [
  'ctrl-x'
  'ctrl-f'
  'ctrl-y'
  'ctrl-k'
  'ctrl-g'
  'ctrl-up'
  'ctrl-down'
  'ctrl-b'
  'ctrl-n'
  'ctrl-t'
  'alt-p' # TODO: this doesn't work
  ]

startsWithElementInArray = (string, arrayOfStrings) ->
  (strInArr for strInArr in arrayOfStrings when string.lastIndexOf(strInArr,0) == 0).length > 0

atom.keymaps.keyBindings = (
  kbd for kbd in atom.keymaps.keyBindings if not startsWithElementInArray(
    kbd.keystrokes, keybindingsToRemove))

# cause lol otherwise loading keymaps doesn't work
atom.keymaps.loadUserKeymap()
