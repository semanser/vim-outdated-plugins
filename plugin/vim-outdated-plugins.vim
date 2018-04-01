function! CheckForUpdates()
  let g:needToUpDate = 0
  " TODO check only activated plugins and not all downloaded

  for key in keys(g:plugs)
    let job2 = jobstart([ 'bash', '-c', "cd " . g:plugs[key].dir ." && git remote update && git status -uno"], s:callbacks)
  endfor

endfunction

function! s:JobHandler(job_id, data, event) dict
  if a:event == 'stdout'
    if (join(a:data) =~ "is behind")
      let g:needToUpDate += 1
    endif
  elseif a:event == 'stderr'
    echom 'stderr: '.join(a:data)
  else
    if g:needToUpDate > 0
      echom 'Plugins to update: ' . g:needToUpDate
    else
      echom 'All plugins up-to-date'
    endif
  endif
endfunction

let s:callbacks = {
      \ 'on_stdout': function('s:JobHandler'),
      \ 'on_stderr': function('s:JobHandler'),
      \ 'on_exit': function('s:JobHandler')
      \ }

au VimEnter * call CheckForUpdates()

