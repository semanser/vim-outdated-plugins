if !exists('g:outdated_plugins_silent_mode')
  let g:outdated_plugins_silent_mode = 0
endif

if !exists('g:outdated_plugins_trigger_mode')
  let g:outdated_plugins_trigger_mode = 0
endif

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

python3 << EOF
import sys
from os.path import normpath, join
import vim
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
sys.path.insert(0, python_root_dir)
import outdatedplugins
EOF

