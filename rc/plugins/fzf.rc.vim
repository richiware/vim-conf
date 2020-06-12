" Files + devicons + floating fzf
function! FzfFilePreview()
    let l:fzf_files_options = '--preview "bat --color=always {3..-1} | head -100" --expect=ctrl-v,ctrl-x'
    let s:files_status = {}

    function! s:cacheGitStatus()
        let l:gitcmd = 'git -c color.status=false -C ' . $PWD . ' status -s'
        let l:statusesStr = system(l:gitcmd)
        let l:statusesSplit = split(l:statusesStr, '\n')
        for l:statusLine in l:statusesSplit
            let l:fileStatus = split(l:statusLine, ' ')[0]
            let l:fileName = split(l:statusLine, ' ')[1]
            let s:files_status[l:fileName] = l:fileStatus
        endfor
    endfunction

    function! s:files()
        call s:cacheGitStatus()
        let l:files = split(system('fd --type f'), '\n')
        return s:prepend_indicators(l:files)
    endfunction

    function! s:prepend_indicators(candidates)
        return s:prepend_git_status(s:prepend_icon(a:candidates))
    endfunction

    function! s:prepend_git_status(candidates)
        let l:result = []
        for l:candidate in a:candidates
            let l:status = ''
            let l:icon = l:candidate[0]
            let l:file_path = l:candidate[1]

            if has_key(s:files_status, l:file_path)
                let l:status = s:files_status[l:file_path]
                call add(l:result, printf('%s %s %s', l:status, l:icon, l:file_path))
            else
                " printf statement contains a load-bearing unicode space
                " the file path is extracted from the list item using {3..-1},
                " this breaks if there is a different number of spaces, which
                " means if we add a space in the following printf it breaks.
                " using a unicode space preserves the spacing in the fzf list
                " without breaking the {3..-1} index
                call add(l:result, printf('%s %s %s', ' ', l:icon, l:file_path))
            endif
        endfor

        return l:result
    endfunction

    function! s:prepend_icon(candidates)
        let l:result = []
        for l:candidate in a:candidates
            let l:filename = fnamemodify(l:candidate, ':p:t')
            let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
            call add(l:result, [l:icon, l:candidate])
        endfor

        return l:result
    endfunction

    function! s:edit_file(lines)
        if len(a:lines) < 2 | return | endif

        let l:cmd = get({'ctrl-x': 'split',
                    \ 'ctrl-v': 'vertical split',
                    \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')

        for l:item in a:lines[1:]
            let l:pos = strridx(l:item, ' ')
            let l:file_path = l:item[pos+1:-1]
            execute 'silent '. l:cmd . ' ' . l:file_path
        endfor
    endfunction

    call fzf#run({
                \ 'source': <sid>files(),
                \ 'sink*':   function('s:edit_file'),
                \ 'options': '-m --preview-window=right:70%:noborder --reverse --prompt Files➤\  ' . l:fzf_files_options,
                \ 'down':    '40%',
                \ 'window': 'call FloatingFZF()'})
endfunction

function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = &lines - 3
    let width = float2nr(&columns - (&columns * 2 / 10))
    let col = float2nr((&columns - width) / 2)

    let opts = {
          \ 'relative': 'editor',
          \ 'row': 3,
          \ 'col': col,
          \ 'width': width,
          \ 'height': height
          \ }

    "set winhl=Normal:Floating
    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&number', 0)
endfunction
