" requires ~/.config/python/spotiphil.py

function! SpotiFold()
    let foldSize = 1 + v:foldend - v:foldstart
    let padding     = repeat("▆", foldSize/(10/v:foldlevel))
    let line = "   " . foldSize . " tracks " . padding
    return line
endf

set nowrap
set foldmethod=indent
set shiftwidth=2
set foldtext=SpotiFold()
set foldlevel=1
set foldcolumn=0
set nonumber
set norelativenumber
"GitGutterDisable

nmap <buffer> <Up> :!python -c 'import spotiphil as sp; sp.volume("+")'<CR><CR>
nmap <buffer> <Down> :!python -c 'import spotiphil as sp; sp.volume("-")'<CR><CR>
nmap <buffer> <Right> :!python -c 'import spotiphil as sp; sp.next()'<CR><CR>
nmap <buffer> <S-Right> :!python -c 'import spotiphil as sp; sp.stepIn()'<CR><CR>
nmap <buffer> <Space> za


command! Help      h vi-sper
command! Albums    e albums.spot
command! Playlists e playlists.spot
command! Favs      e favs.spot
command! NowPut    read !python -c 'import spotiphil as sp; sp.playing()'
command! Now       let @/ = system('python -c "import spotiphil as sp; sp.playing(False)"')[:-2] | echo @/
command! Toggle    !python -c 'import spotiphil as sp; sp.toggle()'
command! Pause     !python -c 'import spotiphil as sp; sp.pause()'
command! UpdatePlaylists !python -c 'import spotiphil as sp; sp.updatePlaylists()'
command! UpdateAlbums !python -c 'import spotiphil as sp; sp.updateAlbums()'
command! HiFiPi !python -c 'import spotiphil as sp; sp.goHiFiPi()'

command! Favourite :.w >> favs.spot
nnoremap <buffer>\a :.w >> favs.spot<CR>
vnoremap <buffer>\a :'<,'>w >> favs.spot<CR>
nnoremap <buffer>\p :call SpSearchStr('')<CR>
command! -nargs=1 Search call SpSearchStr(<f-args>)
" SpSearch is in vimrc

nnoremap <buffer><ENTER> :!python -c 'import spotiphil as sp; sp.toggle()'<CR><CR>
nnoremap <buffer><S-ENTER> :call Spotiphil()<CR><CR> " play

" function! findCurrentSong()


function! Spotiphil()
    let thisline = line(".")
    let lastline = line("w$")
    if (lastline - thisline) > 30
        let lastline = thisline + 30
    endif
    let lines    = getline(thisline,lastline)
    let trackIDs = ''
    for line in lines
        if strlen(line) > 150
            let trackIDs = trackIDs . line[-23:]
        endif
    endfor
    let cmd = "!python -c \"import spotiphil as sp; sp.play('".trackIDs."')\""
    silent execute cmd
    echo "Playing from ".getline(thisline)[0:50]
endfunction
