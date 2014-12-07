require('./functions.coffee')

# destroy default keybindings
keybindingsToRemove = [
  'ctrl-x',
  'ctrl-f'
  'ctrl-y',
  'ctrl-k',
  'ctrl-g',
  'ctrl-alt',
  'ctrl-up',
  'ctrl-down',
  'ctrl-b'
  ]

startsWithElementInArray = (string, arrayOfStrings) ->
  (strInArr for strInArr in arrayOfStrings when string.
  lastIndexOf(strInArr,0) == 0).length > 0

atom.keymap.keyBindings = (kbd for kbd in atom.keymap.
keyBindings when !startsWithElementInArray(kbd.keystroke,
keybindingsToRemove))

# cause lol otherwise loading keymaps doesn't work
atom.keymaps.loadUserKeymap()
