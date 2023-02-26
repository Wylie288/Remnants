startY = 870 + 35
StartX = 200
ScoreX = 275
list_size = argument0

i = 0
repeat(ds_grid_height(global.board))
{
    drawY = startY + (35 * i)

    if (i < 10)
        draw_text(StartX,drawY,string(i + 1) + ". " ); 
    if (i >= 10 && i < 100)
        draw_text(StartX-14,drawY,string(i + 1) + ". " );
    if (i >=100 && i < 1000)
        draw_text(StartX-20,drawY,string(i + 1) + ".  ");
    if (i >=1000 && i < 9999)
        draw_text(StartX-30,drawY,string(i + 1) + ".   " );
        
    draw_text(StartX + 32,drawY,ds_grid_get(global.board,0,i))
    draw_text(StartX + ScoreX,drawY,string(ds_grid_get(global.board,1,i)))
    
    i+= 1
}
