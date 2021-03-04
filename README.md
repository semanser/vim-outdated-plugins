![Vim support](https://img.shields.io/badge/vim-support-brightgreen.svg?style=flat-square)
![Vim support](https://img.shields.io/badge/neovim-support-brightgreen.svg?style=flat-square)
![GitHub release](https://img.shields.io/github/release/semanser/vim-outdated-plugins.svg?style=flat-square)

# vim-outdated-plugins

Async plugin for showing number of your outdated plugins.

## What it does?

This plugin automatically checks if any of your plugins are outdated and display a message about that.

To use this plugin make sure you have **git** installed.

## Installation

```vim
Plug 'thisisrandy/vim-outdated-plugins'
```

## Configuration

```vim
" Do not show any message if all plugins are up to date. 0 by default
let g:outdated_plugins_silent_mode = 1

" Trigger :PlugUpdate as needed
let g:outdated_plugins_trigger_mode = 1
```

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
