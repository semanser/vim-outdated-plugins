![Vim support](https://img.shields.io/badge/vim-unsupported-red.svg?style=flat-square)
![Vim support](https://img.shields.io/badge/neovim-supported-green.svg?style=flat-square)
![GitHub release](https://img.shields.io/github/release/semanser/vim-outdated-plugins.svg?style=flat-square)

# vim-outdated-plugins

A [remote](https://pynvim.readthedocs.io/en/latest/usage/remote-plugins.html)
(non-blocking) plugin for showing the number of and automatically updating
outdated plugins managed via [vim-plug](https://github.com/junegunn/vim-plug)

## What does it do?

This plugin provides a mechanism for displaying a message indicating whether any
of your plugins are outdated. It can also optionally trigger an update if
needed. It fills a gap in [vim-plug](https://github.com/junegunn/vim-plug),
which has no mechanism for fetching updates without also installing them and
cannot function non-disruptively in the background

## Installation

Add the following line inside of the `call plug#begin()` section of your
`init.vim`:

```vim
Plug 'thisisrandy/vim-outdated-plugins'
```

and anywhere after `call plug#end()`, add

```vim
" This line is required to check for outdated plugins on startup
autocmd VimEnter * call CheckOutdatedPlugins()
```

## Configuration

```vim
" Do not show any message if all plugins are up to date. 0 by default
let g:outdated_plugins_silent_mode = 1

" Trigger :PlugUpdate as needed. 0 by default. Note that, when triggered, this
" will open and focus a vertical split and do blocking work, which some users may
" find disruptive on startup
let g:outdated_plugins_trigger_mode = 1
```

## Requirements

- [neovim](https://neovim.io/)
- [git](https://git-scm.com)
- [vim-plug](https://github.com/junegunn/vim-plug)
- [python](https://www.python.org/) >= 3.5

## Screenshots

Simple message text message under the status bar.

![alt text](https://raw.githubusercontent.com/semanser/vim-outdated-plugins/master/images/outdated.png)
![alt text](https://raw.githubusercontent.com/semanser/vim-outdated-plugins/master/images/updated.png)

### OS

- [x] macOS
- [x] Linux
- [ ] Windows

### Plugin Managers:

- [x] vim-plug
- [ ] Vundle
- [ ] Pathogen
- [ ] dein.vim
- [ ] NeoBundle
- [ ] VAM

### Notificatation methods

- [x] Basic echo
- [ ] Status line variable
