if global.friendDraw = 0
    board = global.board
else
    board = global.friendsBoard

i = 0
repeat(ds_grid_height(global.board))
{
    if ds_grid_get(global.board,0,i) = global.uname
    {
        scroll = i - global.boardHeight + 2
    }
    i++
}

if scroll < 0 or scroll > ds_grid_height(board)
    scroll = 0
    
return scroll
