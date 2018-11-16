let g:holylight_checker_path = expand('<sfile>:p:h:h').'/bin/holylight-checker'

" Init
if !exists('g:holylight_threshold')
  let g:holylight_threshold = 1000000
endif

let s:light = 0

" These functions can be overridden {{

function HolylightLight()
  set background=light
endfunction

function HolylightDark()
  set background=dark
endfunction

" }}

function! holylight#check()
  let brightness  = system(g:holylight_checker_path)
  let exit_status = v:shell_error

  if (exit_status != 0)
    echo "Holy Light: Failed to initialize the ambient light sensor"
    return
  endif

  if (brightness > g:holylight_threshold)
    if (!s:light)
      let s:light = 1
      call HolylightLight()
    endif
  elseif (s:light)
    let s:light = 0
    call HolylightDark()
  endif
endfunction

augroup holyLight
  autocmd!
  autocmd CursorHold,BufNewFile,BufRead,VimEnter * silent! call holylight#check()
augroup END
