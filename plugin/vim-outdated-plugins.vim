if !exists('g:outdated_plugins_silent_mode')
  let g:outdated_plugins_silent_mode = 0
endif

function! s:JobHandler(job_id, data, event) dict
  if (str2nr(join(a:data)) != 0)
    let g:pluginsToUpdate += 1
  endif
endfunction

function! s:CalculateUpdates(job_id, data, event) dict
  let l:numberOfcheckedPlugins = 0
  let l:command = ""

  for key in keys(g:plugs)
    let l:command .= '(git -C ' . g:plugs[key].dir . ' rev-list HEAD..origin/' .
          \ g:plugs[key].branch . ' --count)'
    let l:numberOfcheckedPlugins += 1

    if l:numberOfcheckedPlugins != len(keys(g:plugs))
      let l:command .= ' &&'
    endif
  endfor

  call async#job#start([ 'bash', '-c', l:command], s:calculateCallbacks)
endfunction

function! s:DisplayResults(job_id, data, event) dict
  if g:pluginsToUpdate > 0
    echom 'Plugins to update: ' . g:pluginsToUpdate
  else
    if !g:outdated_plugins_silent_mode
      echom 'All plugins up-to-date'
    endif
  endif
endfunction


let s:remoteUpdateCallbacks = {
  \ 'on_exit': function('s:CalculateUpdates')
  \ }

let s:calculateCallbacks = {
  \ 'on_stdout': function('s:JobHandler'),
  \ 'on_exit': function('s:DisplayResults')
  \ }

function! CheckForUpdates()
  let g:pluginsToUpdate = 0
  let l:command = ""

  " TODO check only activated plugins and not all downloaded
  let l:numberOfcheckedPlugins = 0
  for key in keys(g:plugs)
    let l:command .= 'git -C ' . g:plugs[key].dir . ' remote update > /dev/null & '
    let l:numberOfcheckedPlugins += 1

    if l:numberOfcheckedPlugins == len(keys(g:plugs))
      let l:command .= 'wait'
    endif
  endfor

  call async#job#start([ 'bash', '-c', l:command], s:remoteUpdateCallbacks)
endfunction

if v:vim_did_enter
  call CheckForUpdates()
else
  au VimEnter * call CheckForUpdates()
endif

