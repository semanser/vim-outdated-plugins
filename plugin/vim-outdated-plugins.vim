function! s:JobHandler(job_id, data, event) dict
  if (str2nr(join(a:data)) != 0)
    let g:pluginsToUpdate += 1
  endif
endfunction

function! s:CalculateUpdates(job_id, data, event) dict
  if g:pluginsToUpdate > 0
    echom 'Plugins to update: ' . g:pluginsToUpdate
  else
    echom 'All plugins up-to-date'
  endif
endfunction

let s:callbacks = {
      \ 'on_stdout': function('s:JobHandler'),
      \ 'on_exit': function('s:CalculateUpdates')
      \ }

function! CheckForUpdates()
  let g:pluginsToUpdate = 0

  " TODO check only activated plugins and not all downloaded
  for key in keys(g:plugs)
    let job = async#job#start([ 'bash', '-c', "cd " . g:plugs[key].dir ." && git remote update > /dev/null && git rev-list HEAD..origin --count"], s:callbacks)
  endfor
endfunction

au VimEnter * call CheckForUpdates()

