call pathogen#runtime_append_all_bundles()

set nocompatible
set backspace=indent,eol,start 		" allow backspacing over everything in insert mode
set cindent
set incsearch						" do incremental searching
set history=50						" keep 50 lines of command line history
set nobackup
set nowrap
set ruler							" show the cursor position all the time
set scrolloff=2
set shiftwidth=4
set tabstop=4
set showcmd							" display incomplete commands
set ignorecase
set smartcase           			" case sensitive only if search contains uppercase
set guioptions+=b					" horizontal scrolling
set wildmenu 						" :e tab completion file browsing
set wildmode=longest:full 			" make file tab completion act like Bash (full or list)
set cf  							" Enable error files & error jumping.
set laststatus=2  					" Always show status line.
"set listchars=tab:>-,trail:,eol:$
let g:netrw_altv = 1    			" Vsplit right in :Explore mode

set go-=T							"keep MacVim toolbar hidden

" Required for <C-{H,J,K,L}> mappings below
set winminheight=0      " Allow windows to get fully squashed
set winminwidth=0      " Allow windows to get fully squashed
 
" Windows Only
"set backupdir=c:\temp
"set directory=c:\temp
"set viminfo=c:\temp\_viminfo

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("gui_running")
  set autochdir
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  "Always change to directory of current file
  autocmd BufEnter * lcd %:p:h 

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

colorscheme torte
"colorscheme vividchalk
"highlight Normal guibg=Black guifg=White	"Windows, use if no colorscheme

"" Switch between windows, maximizing the current window
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h<C-W>\|
map <C-L> <C-W>l<C-W>\|

" Turn hlsearch off/on with CTRL-N
:map <silent> <C-N> :se invhlsearch<CR>

:map \r	 :call Run()
:map \wr :call WriteRun()
:map \jc :call JavaCompile()
:map \jr :call JavaRun()
:map \fsif :call FormatSQLInsertFields()
:map <silent> <leader>s :set nolist!<CR>

:map ,# :s/^/#/g<CR>:noh<CR>j
:map ,/ :s/^/\/\//g<CR>:noh<CR>j
 
:function Run()
:! %:p
:endfunction

:function WriteRun()
:w | ! %:p
:endfunction

:function JavaCompile()
:if executable("javac")
:!javac "%"
:else
:endif
:endfunction

:function JavaRun()
:!java "%:r"
:endfunction

:function FormatSQLInsertFields()
:g/^$/ d
:1,$-1s/$/,/
:%s/^/\t\t\t/
:endfunction
