call pathogen#runtime_append_all_bundles()

set enc=utf-8
"set guifont=menlo:h12
set guifont=monaco:h12

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
set listchars=tab:▸\ ,eol:¬     " Use the same symbols as TextMate for tabstops and EOLs
"set listchars=tab:>-,trail:.,eol:$
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

"colorscheme koehler
"colorscheme slate2
"colorscheme torte
"colorscheme twilight
colorscheme twilight2
"colorscheme koehler
"colorscheme vividchalk
"colorscheme ir_black
"colorscheme elflord

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

  " kill trailing spaces when exiting file
  " Keeping this disabled.  Messes with existing Git files too much.
  "autocmd BufWritePre * :%s/\s\+$//e

  autocmd! bufwritepost *.rb silent call UpdateTags()

  autocmd! VimLeave * silent :!rm ~/.yankring_history_v2.txt

  autocmd filetype sql noremap <leader>x :DBExecRangeSQL<cr>
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

" Split Edit / Reload Vim Config
map <leader>v :tabnew $MYVIMRC<CR>
map <leader>V :source $MYVIMRC<CR>

" Switch between windows
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Toggle display of characters for whitespace
map <silent> <leader>s :set nolist!<CR>

"Execute current file
"map <leader>r :! %:p<CR>

"Write then Execute current file
map <leader>x :w<CR>:! %:p<CR>

"Copy path to clipboard
nmap <leader>cp :call CopyPathToClipboard()<CR>

" Run rspec
nmap <leader>sc :call TestCommand()<CR>
nmap <leader>tc :call TestContext()<CR>
nmap <leader>tf :call TestFile()<CR>

"nnoremap <leader>t :call RunAllTests('')<cr>:redraw<cr>:call JumpToError()<cr>
"nnoremap <leader>T :call RunAllTests('')<cr>

map <leader>nt :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>
map <leader>tl :Tlist<CR>
map <leader>fa :call VimGrep()<CR>
map <leader>ft :FufTag<CR>
map <leader>ff :CommandTFlush<cr>\|:CommandT<cr>


" show yank register
map <leader>yr :YRShow<CR>

" TABS: Firefox style, open tabs with command-<tab number>
map <silent> <D-1> :tabn 1<CR>
map <silent> <D-2> :tabn 2<CR>
map <silent> <D-3> :tabn 3<CR>
map <silent> <D-4> :tabn 4<CR>
map <silent> <D-5> :tabn 5<CR>
map <silent> <D-6> :tabn 6<CR>
map <silent> <D-7> :tabn 7<CR>
map <silent> <D-8> :tabn 8<CR>
map <silent> <D-9> :tabn 9<CR>

" bind command-] to shift right
nmap <D-]> >>
vmap <D-]> >>
imap <D-]> <C-O>>>

" bind command-[ to shift left
nmap <D-[> <<
vmap <D-[> <<
imap <D-[> <C-O><<

" bind command-/ to toggle comment (requires tComment)
nmap <D-/> <C-_><C-_>
vmap <D-/> <C-_><C-_>
imap <D-/> <C-O><C-_><C-_>

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
nnoremap <CR> :nohlsearch<CR>/<BS>

" Append closing characters
inoremap (( ()<Left>
inoremap [[ []<Left>
inoremap {{ {}<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>

" Keep selection after indenting text
vnoremap > >gv
vnoremap < <gv

" Tabularize
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>

" Bind jj to esc key when in insert mode
"imap jj <Esc>

"use function! to overwrite when resourcing the vimrc
function! CopyPathToClipboard()
	let @* = expand('%')
	echo "Copied to clipboard: ".@*
endfunction

function! TestCommand()
    let @* = "spec ".expand('%').":".line(".")
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


function! RunTests(target, args)
	silent ! echo
	exec 'silent ! echo -e "\033[1;36mRunning tests in ' . a:target . '\033[0m"'
	silent w
	exec "make " . a:target . " " . a:args
endfunction

function! ClassToFilename(class_name)
	let understored_class_name = substitute(a:class_name, '\(.\)\(\u\)', '\1_\U\2', 'g')
	let file_name = substitute(understored_class_name, '\(\u\)', '\L\1', 'g')
	return file_name
endfunction

function! ModuleTestPath()
	let file_path = @%
	let components = split(file_path, '/')
	let path_without_extension = substitute(file_path, '\.rb$', '', '')
	let test_path = 'tests/unit/' . path_without_extension
	return test_path
endfunction

function! NameOfCurrentClass()
	let save_cursor = getpos(".")
	normal $<cr>
	"call RubyDec('class', -1)
	let line = getline('.')
	call setpos('.', save_cursor)
	let match_result = matchlist(line, ' *class \+\(\w\+\)')
	let class_name = ClassToFilename(match_result[1])
	return class_name
endfunction

function! TestFileForCurrentClass()
	let class_name = NameOfCurrentClass()
	let test_file_name = ModuleTestPath() . '/test_' . class_name . '.rb'
	return test_file_name
endfunction

function! TestModuleForCurrentFile()
	let test_path = ModuleTestPath()
	let test_module = substitute(test_path, '/', '.', 'g')
	return test_module
endfunction

function! RunTestsForFile(args)
	if @% =~ 'test_'
		call RunTests('%', a:args)
	else
		let test_file_name = TestModuleForCurrentFile()
		call RunTests(test_file_name, a:args)
	endif
endfunction

function! RunAllTests(args)
	silent ! echo
	silent ! echo -e "\033[1;36mRunning all unit tests\033[0m"
	silent w
	exec "make!" . a:args
endfunction

function! JumpToError()
	if getqflist() != []
		for error in getqflist()
			if error['valid']
				break
			endif
		endfor
		let error_message = substitute(error['text'], '^ *', '', 'g')
		silent cc!
		exec ":sbuffer " . error['bufnr']
		call RedBar()
		echo error_message
	else
		call GreenBar()
		echo "All tests passed"
	endif
endfunction

function! RedBar()
	hi RedBar ctermfg=white ctermbg=red guibg=red
	echohl RedBar
	echon repeat(" ",&columns - 1)
	echohl
endfunction

function! GreenBar()
	hi GreenBar ctermfg=white ctermbg=green guibg=green
	echohl GreenBar
	echon repeat(" ",&columns - 1)
	echohl
endfunction


function! VimGrep()
	let pattern = input("Search Pattern: ")
	let filePattern = input("File Pattern: ")

	let cmd = ':noautocmd vimgrep /'.pattern.'/gj ./**/'.filePattern
	"let cmd = ':grep -Er "'.pattern.'" app api lib public script spec'

	exe cmd
	cw
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
		":Rtags	 "Possilbe alternative but dependend on Rails plugin and being rails project.
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


so ~/.vim/ruby-refactoring.vim

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
