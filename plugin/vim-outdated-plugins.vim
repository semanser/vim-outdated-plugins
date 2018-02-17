function! CheckForUpdates()
  let g:needToUpDate = 0
  " TODO check only activated plugins and not all downloaded
  let job2 = jobstart([ 'bash', '-c', 'find ' . g:plug_home . ' -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd ' . '{}' . ' && git status -uno" \;' ], s:callbacks)
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
      let g:airline_section_warning = 'Updates: ' . g:needToUpDate
    endif
    execute ":AirlineRefresh"
  endif

endfunction

let s:callbacks = {
      \ 'on_stdout': function('s:JobHandler'),
      \ 'on_stderr': function('s:JobHandler'),
      \ 'on_exit': function('s:JobHandler')
      \ }

au VimEnter * call CheckForUpdates()

