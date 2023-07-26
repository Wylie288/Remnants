startY = argument0//870 + 35
StartX = argument1 //200
ScoreOffset = 275
list_size = argument2
list_size = global.boardHeight
scroll = argument3

if global.friendDraw = 0
    board = global.board
else
    board = global.friendsBoard

i = 0

draw_size = clamp(ds_grid_height(board) - scroll, 1, global.boardHeight)

i = 0
repeat(draw_size)
{
    if ds_grid_get(board,0,i + scroll) = global.uname
        draw_set_color(c_yellow)
    else
        draw_set_color(make_color_rgb(72,158,221))
    
    drawY = startY + (35 * i)
    drawI = (i + 1 + scroll)
    
    if (drawI < 10)
        draw_text(StartX,drawY,string(drawI) + ". " ); 
    if (drawI >= 10 && i < 999)
        draw_text(StartX-14,drawY,string(drawI) + ". " );
    if (drawI >= 999 && i < 9999)
        draw_text(StartX-20,drawY,string(drawI) + ".  ");
        
    draw_text(StartX + 32,drawY,ds_grid_get(board,0,i + scroll))
    draw_text(StartX + ScoreOffset,drawY,string(ds_grid_get(board,1,i + scroll)))
    
    i+= 1
}
