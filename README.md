### CrossPaste

This is a vim plugin for pasting text across Vimux panes. It requires you have the Vimux plugin installed.

## Use

To use, type '\qp' to run CrossPaste.  This pulls everything from the white space above the current cursor
to the semicolon after the cursor and pulls it into a buffer. Then CrossPaste searches the buffer for any
instance of ${any_chars} in the buffer and prompts the user to replace it.  For example, if your cursor is
over this text:

SELECT name FROM user WHERE user_id = ${userId};

and you hit \qp, it will prompt you for userId. If you type "23", then

SELECT name FROM user WHERE user_id = 23;

will get pasted across to the nearest TMUX pane.

## Installation

You can get this plugin by adding this to your .vimrc.bundles.local
```
Plug 'https://github.com/samguyjones/vim-crosspaste.git'
```

I add this to my .vimrc_local to let me paste code with the shortcut \qp
```
map <silent> <LocalLeader>qp :call CrossPaste()<CR>
```
