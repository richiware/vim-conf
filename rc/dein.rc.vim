" dein configurations.

let g:dein#auto_recache = 1
let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = 1
let g:dein#notification_icon = '~/.vim/signs/warn.png'
let g:dein#install_log_filename = '~/tmp/dein.log'

let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

let s:dein_toml = '~/.vim/rc/toml/dein.toml'
let s:dein_lazy_toml = '~/.vim/rc/toml/deinlazy.toml'
let s:dein_nvim_toml = '~/.vim/rc/toml/deinvim.toml'
let s:dein_vim_toml = '~/.vim/rc/toml/deivim.toml'
let s:browser_toml = '~/.vim/rc/toml/browser.toml'
let s:decoration_toml = '~/.vim/rc/toml/decoration.toml'
let s:notes_toml = '~/.vim/rc/toml/notes.toml'
let s:search_toml = '~/.vim/rc/toml/search.toml'

call dein#begin(s:path, [
      \ expand('<sfile>'), s:dein_toml, s:dein_lazy_toml, s:dein_nvim_toml, s:dein_vim_toml
      \ ])

call dein#load_toml(s:dein_toml, {'lazy': 0})
call dein#load_toml(s:dein_lazy_toml, {'lazy' : 1})
if has('nvim')
  call dein#load_toml(s:dein_nvim_toml)
else
  call dein#load_toml(s:dein_vim_toml)
endif
call dein#load_toml(s:browser_toml)
call dein#load_toml(s:decoration_toml)
call dein#load_toml(s:notes_toml)
call dein#load_toml(s:search_toml)

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
