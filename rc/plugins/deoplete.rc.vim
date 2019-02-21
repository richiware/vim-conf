"---------------------------------------------------------------------------
" deoplete.nvim

" <CR>: close popup and save indent. Instead of insert candidate, use as normal Enter.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#cancel_popup() . "\<CR>"
endfunction

" <C-l> insert common candidates.
inoremap <silent><expr><C-l>       deoplete#complete_common_string()
" ' insert candidate and close popup
inoremap <expr> '  pumvisible() ? deoplete#close_popup() : "'"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

inoremap <expr><C-g>       deoplete#refresh()
inoremap <expr><C-e>       deoplete#cancel_popup()
"" inoremap <silent><expr> <C-t> deoplete#manual_complete('file')

" Automatically closing the scratch window at the top of the vim window on finishing a complete or leaving insert.
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Make sure the autocompletion will actually trigger using the omnifuncs set later on
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy', 'matcher_length'])

call deoplete#custom#source('zsh', 'filetypes', ['zsh', 'sh'])

call deoplete#custom#source('_', 'converters', [
      \ 'converter_remove_paren',
      \ 'converter_remove_overlap',
      \ 'matcher_length',
      \ 'converter_truncate_abbr',
      \ 'converter_truncate_menu',
      \ 'converter_auto_delimiter',
      \ ])

"call deoplete#custom#option('keyword_patterns', {
"      \ '_': '[a-zA-Z_]\k*\(?',
"      \ 'tex': '[^\w|\s][a-zA-Z_]\w*',
"      \ })

call deoplete#custom#option('camel_case', v:true)
call deoplete#custom#option('refresh_always', v:true)

"call deoplete#custom#option('profile', v:true)
"call deoplete#enable_logging('DEBUG', 'deoplete.log')
"call deoplete#custom#source('clang', 'debug_enabled', 1)

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_',
            \ 'disabled_syntaxes', ['Comment', 'String'])

" LanguageClient options.
call deoplete#custom#source('LanguageClient', 'sorters', [])

call deoplete#custom#var('buffer', 'require_same_filetype', v:false)    " otherbuffer complete

" Marks
call deoplete#custom#source('LanguageClient','mark', 'ℰ')
call deoplete#custom#source('omni',          'mark', '⌾')
call deoplete#custom#source('flow',          'mark', '⌁')
call deoplete#custom#source('ternjs',        'mark', '⌁')
call deoplete#custom#source('go',            'mark', '⌁')
call deoplete#custom#source('jedi',          'mark', '⌁')
call deoplete#custom#source('vim',           'mark', '⌁')
call deoplete#custom#source('ultisnips',     'mark', '⌘')
call deoplete#custom#source('around',        'mark', '↻')
call deoplete#custom#source('buffer',        'mark', 'ℬ')
call deoplete#custom#source('tmux-complete', 'mark', '⊶')
call deoplete#custom#source('syntax',        'mark', '♯')
call deoplete#custom#source('member',        'mark', '.')

let g:ulti_expand_res = 0 "default value, just set once
function! CompleteSnippet()
  if empty(v:completed_item)
    return
  endif

  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res > 0
    return
  endif

  let l:complete = type(v:completed_item) == v:t_dict ? v:completed_item.word : v:completed_item
  let l:comp_len = len(l:complete)

  let l:cur_col = mode() == 'i' ? col('.') - 2 : col('.') - 1
  let l:cur_line = getline('.')

  let l:start = l:comp_len <= l:cur_col ? l:cur_line[:l:cur_col - l:comp_len] : ''
  let l:end = l:cur_col < len(l:cur_line) ? l:cur_line[l:cur_col + 1 :] : ''

  call setline('.', l:start . l:end)
  call cursor('.', l:cur_col - l:comp_len + 2)

  call UltiSnips#Anon(l:complete)
endfunction

autocmd CompleteDone * call CompleteSnippet()
