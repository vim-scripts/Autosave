if !has('python')
    echo "Error: Require Vim compiled with +python."
    finish
endif

" Set path and suffix for auto save file.
let s:auto_save_path = expand($VIM . '/' . "backup")
let s:auto_save_suffix = ".txt"

" Check whether the path exists, create the directory when it doesn't exist.
if !isdirectory(s:auto_save_path)
    silent! call mkdir(s:auto_save_path, "p")
endif

function! Autosave(path, suffix)

python << monty
import vim
from datetime import datetime

path = vim.eval("s:auto_save_path")
suffix = vim.eval("s:auto_save_suffix")
cbuffer = vim.current.buffer                            # Get current buffer object.
lines = cbuffer[0:len(cbuffer)]                         # Get current buffer's content.

if lines == [""]:                                       # Check empty buffer.
    name = datetime.now().strftime("%Y%m%d%H%M%S%f")    # Get current time stamp.
    full_path_name = path + "/" + name + suffix         # Combined into full path and file name.
    vim.command("silent edit %s" % (full_path_name))    # Edit this file.
    vim.command("silent write")                         # And write to disk.

monty

endfunction

if has("autocmd")
    autocmd BufEnter * call Autosave(s:auto_save_path, s:auto_save_suffix)
endif
