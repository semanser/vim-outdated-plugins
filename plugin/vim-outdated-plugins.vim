function! s:JobHandlerVim(chanell, msg)
  if (a:msg =~ "is behind")
    let g:needToUpDate += 1
  endif
endfunction

function! s:CalculateUpdatesVim(chanell)
  if g:needToUpDate > 0
    echom 'Plugins to update: ' . g:needToUpDate
  else
    echom 'All plugins up-to-date'
  endif
endfunction

function! s:JobHandlerNeovim(job_id, data, event) dict
  if (join(a:data) =~ "is behind")
    let g:needToUpDate += 1
  endif
endfunction

function! s:CalculateUpdatesNeovim(job_id, data, event) dict
  if g:needToUpDate > 0
    echom 'Plugins to update: ' . g:needToUpDate
  else
    echom 'All plugins up-to-date'
  endif
endfunction

let s:callbacksNeovim = {
      \ 'on_stdout': function('s:JobHandlerNeovim'),
      \ 'on_exit': function('s:CalculateUpdatesNeovim')
      \ }

let s:callbacksVim = {
      \ 'out_cb': function('s:JobHandlerVim'),
      \ 'close_cb': function('s:CalculateUpdatesVim')
      \ }

function! CheckForUpdates()
  let g:needToUpDate = 0

  " TODO check only activated plugins and not all downloaded
  if has('nvim')
    for key in keys(g:plugs)
      let job2 = jobstart([ 'bash', '-c', "cd " . g:plugs[key].dir ." && git remote update && git status -uno"], s:callbacksNeovim)
    endfor
  else
    for key in keys(g:plugs)
      let job2 = job_start([ 'bash', '-c', "cd " . g:plugs[key].dir ." && git remote update && git status -uno"], s:callbacksVim)
    endfor
  endif
endfunction

au VimEnter * call CheckForUpdates()

