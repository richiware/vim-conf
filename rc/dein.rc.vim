" dein configurations.

let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1
let g:dein#notification_icon = '~/.vim/signs/warn.png'

let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

call dein#begin(s:path, [expand('<sfile>')]
      \ + split(glob('~/.vim/rc/toml/*.toml'), '\n'))

call dein#load_toml('~/.vim/rc/toml/dein.toml', {'lazy': 0})
call dein#load_toml('~/.vim/rc/toml/deinlazy.toml', {'lazy' : 1})
if has('nvim')
  call dein#load_toml('~/.vim/rc/toml/deinvim.toml', {})
else
  call dein#load_toml('~/.vim/rc/toml/deivim.toml', {})
endif

call dein#add('altercation/vim-colors-solarized')

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
