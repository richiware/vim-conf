"---------------------------------------------------------------------------
" Encoding:
"
" The automatic recognition of the character code.

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if has('vim_starting') && &encoding !=# 'utf-8'
  if IsWindows() && !has('gui_running')
    set encoding=cp1252
  else
    set encoding=utf-8
  endif
endif

" Setting of terminal encoding."{{{
if !has('gui_running')
  if $ENV_ACCESS ==# 'linux'
    set termencoding=utf-8
  elseif $ENV_ACCESS ==# 'colinux'
    set termencoding=utf-8
  else  " fallback
    set termencoding=  " same as 'encoding'
  endif
elseif IsWindows()
  " For system.
  set termencoding=cp1252
endif
"}}}

" The automatic recognition of the character code."{{{
if has('kaoriya')
  " For Kaoriya only.
   set fileencodings=guess
elseif !exists('did_encoding_settings') && has('iconv')
  " Build encodings.
  let &fileencodings = join([
        \ 'utf-8', 'cp1252', 'latin1', 'latin9'])
  let did_encoding_settings = 1
endif
"}}}

" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac

" Command group opening with a specific character code again."{{{
" In particular effective when I am garbled in a terminal.
" Open in UTF-8 again.
command! -bang -bar -complete=file -nargs=? Utf8
      \ edit<bang> ++enc=utf-8 <args>
" Open in Windows 1252
command! -bang -bar -complete=file -nargs=? Cp1252
      \ edit<bang> ++enc=cp1252 <args>
" Open in Latin1
command! -bang -bar -complete=file -nargs=? Latin1
      \ edit<bang> ++enc=latin1 <args>
" Open in Latin9
command! -bang -bar -complete=file -nargs=? Latin9
      \ edit<bang> ++enc=latin9 <args>
" Open in UTF-16 again.
command! -bang -bar -complete=file -nargs=? Utf16
      \ edit<bang> ++enc=ucs-2le <args>
" Open in UTF-16BE again.
command! -bang -bar -complete=file -nargs=? Utf16be
      \ edit<bang> ++enc=ucs-2 <args>

" Aliases.
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
"}}}

" Tried to make a file note version."{{{
" Don't save it because dangerous.
command! WUtf8 setlocal fenc=utf-8
command! WCp1252 setlocal fenc=cp1252
command! WLatin1 setlocal fenc=latin1
command! WLatin9 setlocal fenc=latin9
command! WUtf16 setlocal fenc=ucs-2le
command! WUtf16be setlocal fenc=ucs-2
" Aliases.
command! WUnicode WUtf16
"}}}

" Appoint a line feed."{{{
command! -bang -complete=file -nargs=? WUnix
      \ write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WDos
      \ write<bang> ++fileformat=dos <args> | edit <args>
command! -bang -complete=file -nargs=? WMac
      \ write<bang> ++fileformat=mac <args> | edit <args>
"}}}

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif
