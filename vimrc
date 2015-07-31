" ============= Vundle Begin ==============================
"
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" ============= Vundle End ================================


call pathogen#runtime_append_all_bundles()

"set t_Co=256                      " Enable colors (must be set before syntax enable and Terminal must support 256 colors (option in Lion terminal))

set enc=utf-8
set guifont=menlo:h12
"set guifont=monaco:h12

set nocompatible
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set history=50                  " keep 50 lines of command line history
set hidden                      " you can change buffers without saving
set nobackup
set nowrap                      " Don't wrap text
set scrolloff=2                 " Keep 2 lines top/bottom visible for scope
set shiftwidth=2
set tabstop=2
set expandtab                   " Auto convert tabs to spaces
set showcmd                     " display incomplete commands
set incsearch                   " do incremental searching
set smartcase                   " case sensitive only if search contains uppercase
set ignorecase                  " Needs to be present for smartcase to work as intended
set wildmenu                    " :e tab completion file browsing
set wildmode=list:longest,full  " List all matches on first TAB, complete/cycle on second TAB
set cf                          " Enable error files & error jumping.
set vb                          " turns off visual bell
set splitbelow                  " Open new horizontal split windows below current
set splitright                  " Open new vertical split windows to the right
set laststatus=2                " Always show status line
set ruler                       " show the cursor position in the status line
"set cursorline                  " Highlight current line
"set cursorcolumn                " Highlight current column
set number                      " turn on line numbers
set formatoptions=rq            " Automatically insert comment leader on return, and let gq format comments
set autoread                    " Don't prompt to reread the file if it is unchanged in the editor but modified externally.

"set cindent
"set smartindent

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/tmp

" Show git branch form fugitive on the statusline.
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

"colorscheme twilight
colorscheme twilight2
"colorscheme elflord

let g:slime_target = "tmux"

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  let project_path = getcwd()
endif


" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


if has("gui_running")
  set go-=T                       " keep MacVim toolbar hidden
  "set guioptions-=rL             " Scrollbar always off
  set fuoptions=maxvert,maxhorz		" fullscreen maximizes vertically AND horizontally

  "set autochdir

  "Auto write all files when focus is lost, including Cmd-Tab in MacVim
  "autocmd FocusLost * :wall
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")
  "Reload vimrc on write.  Nice if it was opened within a tab/window of the same
  "vim instance
  autocmd! bufwritepost .vimrc source %

  "Treat rabl as ruby
  au BufRead,BufNewFile *.rabl setf ruby

  " kill trailing spaces when exiting file
  " Keeping this disabled.  Messes with existing Git files too much.
  "autocmd BufWritePre * :%s/\s\+$//e

  autocmd! bufwritepost *.rb silent call UpdateTags()

  autocmd filetype sql noremap <leader>x :DBExecSQLUnderCursor<cr>
  autocmd filetype sql noremap <leader>X :DBExecRangeSQL<cr>
  autocmd filetype sql noremap <leader>d :DBExecSQL describe <c-r>=expand("<cword>") <cr><cr>

  "Always change to directory of current file
  "autocmd BufEnter * lcd %:p:h

  " Go up a level in the git repository in fugitive using ..
  autocmd User fugitive
    \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
    \   nnoremap <buffer> .. :edit %:h<CR> |
    \ endif

  " Auto cleanup fugitive buffers
  autocmd BufReadPost fugitive://* set bufhidden=delete

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_WinWidth = 50

"==================="
" Keyboard Mappings "
"==================="

let mapleader=","

" Don't use Ex mode, use Q for formatting
"map Q gq

" Split Edit / Reload Vim Config (short for Configure Vim)
map <leader>cv :tabnew $MYVIMRC<CR>

" Switch between windows
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

"Switch between the last two files
nnoremap <leader><leader> <c-^>

" Toggle display of characters for whitespace
map <silent> <leader>s :set nolist!<CR>

" Edit or view files in same directory as current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

"Execute current file
"map <leader>r :! %:p<CR>

"Write then Execute current file
map <leader>x :w<CR>:! %:p<CR>

"Copy path to clipboard
nmap <leader>cp :call CopyPathToClipboard()<CR>
nmap <leader>cmv :call CopyMigrationVersionToClipboard()<CR>

" Run rspec
nmap <leader>sc :call TestCommand()<CR>
nmap <leader>tc :call TestContext()<CR>
nmap <leader>tf :call TestFile()<CR>


" Rspec.vim mappings
map <Leader>ta :call RunCurrentSpecFile()<CR>
map <Leader>tn :call RunNearestSpec()<CR>
map <Leader>tl :call RunLastSpec()<CR>
"map <Leader>a :call RunAllSpecs()<CR>


map <leader>nt :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>
map <leader>fa :Ack -i 


"Custom Command-T mappings
map <leader>ff :CommandTFlush<cr>\|:CommandT<cr>
" Open files, limited to the directory of the current file.  " This requires the %% mapping.
map <leader>gf :CommandTFlush<cr>\|:CommandT %%<cr>

"Custom Rails-specific Command-T mappings
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>ga :CommandTFlush<cr>\|:CommandT app/assets<cr>

map <leader>gd :CommandTFlush<cr>\|:CommandT app/domain<cr>

" Open the tag definition in a new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Open the tag definition in a vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

command! W w !sudo tee % > /dev/null

" bubble up selected text
vmap <C-up> [egv
vmap <C-k> [egv

" bubble down selected text
vmap <C-down> ]egv
vmap <C-j> ]egv

" Easy access to the start and the end of the line (for Ivan)
nnoremap - ^
nnoremap _ $

" Turnoff search highlighting by pressing enter key
" Note this breaks the ability to press enter in the quickfix window to jump to a file.
" Use <C-Enter> as a workaround.
nnoremap <CR> :nohlsearch<CR>/<BS>

" Append closing characters
" Can't stand these
" inoremap (( ()<Left>
" inoremap [[ []<Left>
" inoremap {{ {}<Left>
" inoremap "" ""<Left>
" inoremap '' ''<Left>

" Keep selection after indenting text
vnoremap > >gv
vnoremap < <gv

" Tabularize
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>A, :Tabularize /,\zs<CR>
nmap <Leader>A, :Tabularize /,\zs<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>as :Tabularize /\s.*<CR>
vmap <Leader>as :Tabularize /\s.*<CR>

"Shortcuts for moving through Diffcheck() similar to moving through the quickfix window.
:map {Q :Gdp<cr>
:map }Q :Gdn<cr>

" Bind jj to esc key when in insert mode
"imap jj <Esc>

"use function! to overwrite when resourcing the vimrc
function! CopyPathToClipboard()
	let @* = expand('%')
	echo "Copied to clipboard: ".@*
endfunction

function! CopyMigrationVersionToClipboard()
	let path = expand('%')
  let a = split(path, '_')
  let b = split(a[0], '/')
  let ver = b[-1]

	let @* = ver
	echo "Copied to clipboard: ".@*
endfunction

function! TestCommand()
	if executable("rspec")
    let @* = "rspec ".expand('%').":".line(".")
	else
    let @* = "spec ".expand('%').":".line(".")
	endif

	echo "Copied to clipboard: ".@*
endfunction

function! TestContext()
	if executable("rspec")
		let command = "!rspec ".expand('%:p').":".line(".")
	else
		let command = "!spec ".expand('%:p').":".line(".")
	endif

	:execute command
endfunction

function! TestFile()
	if executable("rspec")
		!rspec %
	else
		!spec %
	endif
endfunction


function! WriteRun()
	w | ! %:p
endfunction


function! RedBar()
	hi RedBar ctermfg=white ctermbg=red guibg=red
	echohl RedBar
	echon repeat(" ",&columns - 1)
	echohl None
endfunction

function! GreenBar()
	hi GreenBar ctermfg=white ctermbg=green guibg=green
	echohl GreenBar
	echon repeat(" ",&columns - 1)
	echohl None
endfunction


command! -nargs=* -complete=command DiffCheck call DiffCheck(<f-args>)
function! DiffCheck(...)
	setlocal errorformat=%f
	let tmpfile = tempname()

	let g:startspec = a:0 == 1 ? a:1 : ""
	let g:endspec = a:0 == 1 ? "HEAD" : ""

	let g:startspec = a:0 == 2 ? a:1 : g:startspec
	let g:endspec = a:0 == 2 ? a:2 : g:endspec

	let refspec = g:startspec." ".g:endspec

	exe ":!git diff --name-only ".refspec."> ".tmpfile

	exe ":cf " . tmpfile
	cw
endfunction

command! -complete=command Gd call GitDiff()
function! GitDiff()
	exec ":Gdiff ".g:startspec
endfunction


command! -complete=command Gdp call GitDiffPrev()
function! GitDiffPrev()
	wincmd k
	close
	cp
	call GitDiff()
	botright cw 10
endfunction

command! -complete=command Gdn call GitDiffNext()
function! GitDiffNext()
	wincmd k
	close
	cn
	call GitDiff()
	botright cw 10
endfunction


let g:enableTags = 0
command! -complete=command EnableTags call EnableTags()
function! EnableTags()
	let g:enableTags = 1
endfunction

function! UpdateTags()
	if g:enableTags == 1
		:execute ':!ctags -f '.g:project_path.'/tmp/tags -R '.g:project_path.'/ *.rb &'
	endif
endfunction


function! TabMessage(cmd)
	redir => message
	silent ! a:cmd
	redir END
	tabnew
	silent put=message
	set nomodified
endfunction

" Create custom command for Function
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

" A function to clear the undo history
function! <SID>ForgetUndo()
    let old_undolevels = &undolevels
    set undolevels=-1
    exe "normal a \<BS>\<Esc>"
    let &undolevels = old_undolevels
    unlet old_undolevels
endfunction
command! -nargs=0 ClearUndo call <SID>ForgetUndo()

function! OpenFileWithOptionalLineNumber(path)
  if match(a:path, ":") > 0
    let tmp = split(a:path, ":")
    let path = tmp[0]
    let line_number = tmp[1]

    let open_cmd = ":ex ".path
    execute open_cmd

    let jump_cmd = ":".line_number
    execute jump_cmd
  else
    execute ":ex ".a:path
  endif
endfunction
command! -nargs=1 Ex call OpenFileWithOptionalLineNumber(<f-args>)


so ~/.vim/ruby-refactoring.vim

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif


" vmap <leader>! :call ExecuteSelectedCommand()<CR>
" function! ExecuteSelectedCommand()
"   let cmd = ":! ".@*
"   echo cmd
"   exec cmd
" endfunction
"

" vmap <Leader>! :call ExecuteVLines()<CR>
"
" function! NumSort(a, b)
"   return a:a>a:b ? 1 : a:a==a:b ? 0 : -1
" endfunction
"
" function! ExecuteVLines()
"   let [firstline, lastline]=sort([line('v'), line('.')], 'NumSort')
"   let lines = getline(firstline, lastline)
"   exec ":!".join(lines, " && ")
" endfunction


"Source: http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))

  "This will use buffer corresponding to command name
  " let winnr = bufwinnr('^' . command . '$')
  " silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'

  "This will reuse the same buffer
  let winnr = bufwinnr('^' . 'test_output' . '$')
  silent! execute  winnr < 0 ? 'botright new ' . 'test_output' : winnr . 'wincmd w'

  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  " echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  let shell_status_code = v:shell_error

  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''

  "This only seems to work when using <Leader> and only when in the output window.
  " silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'

  wincmd p

  let message = 'Shell command ' . command . ' executed.'
  " echo message

	" hi GreenBar ctermfg=black guifg=black ctermbg=green guibg=green
	" hi RedBar ctermfg=black guifg=black ctermbg=red guibg=red
	" echohl GreenBar | echo message | echon repeat(" ",&columns - len(message)) | echohl
  " silent! redraw

  return shell_status_code
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)


function! s:FoldItBlock()
  let start = search('^\s*\(it\|let\|specify\|scenario\|before\).*do\s*$', 'We')
  let end   = search('end', 'We')
  let cmd = (start).','.(end+1).'fold'
  if (start > 0) && (start < end)
    execute cmd
    return 1
  else
    return 0
  endif
endfunction

function! FoldAllItBlocks()
  let position = line('.')
  exe cursor(1,1)
  let result = 1

  while result == 1
    let result = s:FoldItBlock()
  endwhile

  call cursor(position, 1)
endfunction

nmap <leader>f1 :call FoldAllItBlocks()<CR>
nmap <leader>f0 :execute "normal zE"<CR>

function! FormatNumbers()
  :%s/\(\d\)\(\(\d\d\d\)\+\d\@!\)\@=/\1,/g
endfunction

let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'echo %URL% | pbcopy'
let g:gist_post_private = 1
let g:gist_show_privates = 1

"let g:ackprg = 'ag --nogroup --nocolor --column'

function! UpdateRubyHashSynxtax()
:s/\v:(\w+)? \=\> /\1: /g
endfunction

"let g:loaded_bufexplorer = 1

"tab navigation shortcuts for command line
nnoremap th :tabprev<CR>
nnoremap tl :tabnext<CR>
nnoremap tn :tabnew<CR>
nnoremap td :tabclose<CR>
