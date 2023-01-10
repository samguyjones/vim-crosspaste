" Title: vim-crosspaste plugin
" Description: Works with Vimux to paste text across vimux panes
" Last Change: 19 October 2022
" Maintainer: Sam Jones <sjones6@paypal.com>

if exists("g:CrossPasteLoaded")
  finish
else
  let g:CrossPasteList={}
  let g:CrossPasteLoaded=1

  function! CrossPaste()
    ?^$?;/;/yank q
    let @q = AllValues(@q)
    call VimuxRunCommand(@q)
  endfunction

  function! CrossPasteBlock()
    yank q
    let @q = AllValues(@q)
    call VimuxRunCommand(@q)
  endfunction

  function! SwitchMatch(input, entered)
    let l:start = match(a:input, "\$\{[^}]*\}")
    let l:end = matchend(a:input, "^[^\$]*\$\{[^}]*\}")
    let l:variable = strpart(a:input, l:start+2, l:end - l:start - 3)
    return strpart(a:input, 0, l:start) . UserValue(variable, a:entered) . strpart(a:input, l:end)
  endfunction

  function! AllValues(input)
    let l:process = a:input
    let l:entered = []
    while match(l:process, "\$\{[^}]*\}") >= 0
      let l:process = SwitchMatch(l:process, l:entered)
    endwhile
    return l:process
  endfunction

  function! RememberRegister(name, value, entered)
    let g:CrossPasteList[a:name] = a:value
    call add(a:entered, a:name)
  endfunction

  function! FileReadValue(userinput, enteredvalue)
    let l:filecontents = readfile(a:enteredvalue)
    if match(a:userinput, "fs:") == 0
      let l:filecontents = map(l:filecontents, '"''" . v:val . "''"')
    endif
    return join(l:filecontents, ",")
  endfunction

  function! UserValue(userinput, entered)
    let l:enteredvalue = EnteredValue(a:userinput, a:entered)
    if match(a:userinput,"^f[sn]:") >= 0
      let l:enteredvalue=FileReadValue(a:userinput, l:enteredvalue)
    endif
    return l:enteredvalue
  endfunction

  function! EnteredValue(userinput, entered)
    let l:default = ''
    if has_key(g:CrossPasteList, a:userinput)
      let l:default = g:CrossPasteList[a:userinput]
      if index(a:entered, a:userinput) > -1
        return l:default
      endif
    endif
    call inputsave()
    let l:uservalue = input('Enter ' . a:userinput . ': ', l:default)
    call inputrestore()
    call RememberRegister(a:userinput, l:uservalue, a:entered)
    let g:CrossPasteList[a:userinput] = l:uservalue
    call add(a:entered, a:userinput)
    return l:uservalue
  endfunction
endif
