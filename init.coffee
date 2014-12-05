# destroy default keybindings
keybindingsToRemove = [
  'ctrl-x', 'ctrl-s', # saving/searching
  'ctrl-k','ctrl-y', # copy-paste
  'ctrl-g' # quitting
  ]
atom.keymap.keyBindings = (kbd for kbd in atom.keymap.keyBindings when keybindingsToRemove.indexOf(kbd.keystroke) == -1)

require("./test_init.coffee")

atom.beep()
