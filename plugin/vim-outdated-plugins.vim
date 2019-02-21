if !exists('g:outdated_plugins_silent_mode')
  let g:outdated_plugins_silent_mode = 0
endif

function! s:JobHandler(job_id, data, event) dict
  if (str2nr(join(a:data)) == 0)
    let g:pluginsToUpdate += 1
  endif
endfunction

function! s:CalculateUpdates(job_id, data, event) dict
  let g:test2 = 0
  let g:command2 = ""

  for key in keys(g:plugs)
    let g:command2 .= '(git -C ' . g:plugs[key].dir . ' rev-list HEAD..origin --count)'
    let g:test2 += 1

    if g:test2 != len(keys(g:plugs))
      let g:command2 .= ' &&'
    endif
  endfor

  call async#job#start([ 'bash', '-c', g:command2], s:calculateCallbacks)
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
	let g:command = ""

  " TODO check only activated plugins and not all downloaded
  let g:test = 0
  for key in keys(g:plugs)
    let g:command .= 'git -C ' . g:plugs[key].dir . ' remote update > /dev/null'
    let g:test += 1

    if g:test != len(keys(g:plugs))
      let g:command .= ' &'
    endif
  endfor

  call async#job#start([ 'bash', '-c', g:command], s:remoteUpdateCallbacks)
endfunction

au VimEnter * call CheckForUpdates()

