# vim-mapping-conflicts
This is a small Vim plugin I wrote to determine which plugins were using the
same key sequence, thus creating conflicts and not working. This is
particularly handy is you use a lot of plugins, like I do. At the moment it is
a bit hacky but it does the trick.

### Requirements
None. This plugin is written in vimscript, nothing more but Vim is needed.

### Installation
You can install it as any other plugin. For Vundle, add this line:

    Plugin 'lukhio/vim-mapping-conflicts'

to your vimrc file. For pathogen:

    $ cd $HOME/.vim/bundle
    $ git clone git@github.com:lukhio/vim-mapping-conflicts.git

For other plugin managers please refer to their documentation.

### Usage
Inside of Vim, type `:CheckMappingConflicts`. If you get as result `No conflict
detected`, you're good! If you have conflicts, you will get something like `N
conflicts detected. Check conflicts.log for details`. The `conflict.log` file
will be in the directory from which you launched Vim and will contain the list
of commands that some plugin try to mapped to an already taken keys sequence.

### Contributing
You can send me patches at julien AT jgamba DOT eu. You can also try to submit
a pull request on Github, but I do not check it often. You can also email me if
you are having issues, or want to give feedback.

### License
See the `LICENSE` file.
