# vim-mapping-conflicts
### Look for key mapping conflicts in Vim

This is a quick'n'dirty plugin I wrote to determine which plugins were using the
same key sequence, thus creating conflicts and not working. At the moment it is
hacky but it did the trick. If you want to help me improve it feel free to open
a pull request !

#### Requirements
Your Vim version needs to have Python built-in support. To check if your Vim can
handle Python code, just do `vim --version` and grep for `+python`. You can also
type `:py 1` inside of Vim : if you get nothing, you're good to go.

If you do not have Python built-in support, you can either get a newer version
of Vim or [build it from source](http://vim.wikia.com/wiki/Building_Vim).

#### Installation
You can install it as any other plugin. For pathogen that is :

    $ cd $HOME/.vim/bundle
    $ git clone git@github.com:lukhio/vim-mapping-conflicts.git

For other plugin manager please refer to the documentation.

#### Usage
Inside of Vim, type `:CheckMapping`. If you get as result `No key-mapping
conflict found`, you're good ! If you have conflicts, you will get something
like `N conflicts found. Check conflicts.log for details`. The `conflict.log`
file will be in the directory from which you launched Vim and will contain the
list of commands that some plugin try to mapped to an already taken keys
sequence.
