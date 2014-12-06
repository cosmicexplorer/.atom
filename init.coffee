# destroy default keybindings
keybindingsToRemove = [
  'ctrl-x',
  'ctrl-y',
  'ctrl-k',
  'ctrl-g',
  'ctrl-alt',
  'ctrl-up',
  'ctrl-down',
  'ctrl-b'
  ]

startsWithElementInArray = (string, arrayOfStrings) ->
  (strInArr for strInArr in arrayOfStrings when string.lastIndexOf(strInArr,0) == 0).length > 0

# TODO: make this 80 chars or less!!!
atom.keymap.keyBindings = (kbd for kbd in atom.keymap.keyBindings when !startsWithElementInArray(kbd.keystroke, keybindingsToRemove))

require('./functions.coffee')

# cause lol otherwise loading keymaps doesn't work
atom.keymaps.loadUserKeymap()
