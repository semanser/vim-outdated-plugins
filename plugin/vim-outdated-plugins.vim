function! s:JobHandler(job_id, data, event) dict
  if (str2nr(join(a:data)) != 0)
    let g:pluginsToUpdate += 1
  endif
endfunction

function! s:CalculateUpdates(job_id, data, event) dict
	call remove(g:check_for_updates_jobids, a:job_id)

  if len(g:check_for_updates_jobids) == 0
    if g:pluginsToUpdate > 0
      echom 'Plugins to update: ' . g:pluginsToUpdate
    else
      echom 'All plugins up-to-date'
    endif
  endif
endfunction

let s:callbacks = {
      \ 'on_stdout': function('s:JobHandler'),
      \ 'on_exit': function('s:CalculateUpdates')
      \ }

function! CheckForUpdates()
  let g:pluginsToUpdate = 0
  let g:check_for_updates_jobids = {}

  " TODO check only activated plugins and not all downloaded
  for key in keys(g:plugs)
    let g:check_for_updates_jobids[async#job#start([ 'bash', '-c', "cd " . g:plugs[key].dir ." && git remote update > /dev/null && git rev-list HEAD..origin --count"], s:callbacks)] = key
  endfor
endfunction

au VimEnter * call CheckForUpdates()

