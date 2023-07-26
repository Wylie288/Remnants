#define friendsList
ds_list_clear(global.friends)
ds_list_add(global.friends, global.uname)
ini_open("friendList")
    count = ini_read_real("count", "count", 0)
    i = 1
    repeat(count)
    {
        name = ini_read_string(string("names"), string(i), "unnamed")
        ds_list_add(global.friends, name)
        i ++
    }
ini_close()


if ds_exists(global.friendsBoard, ds_type_grid)
    ds_grid_destroy(global.friendsBoard)
global.friendsBoard = ds_grid_create(2, ds_list_size(global.friends))

i = 0
count = 0
repeat(ds_grid_height(global.board))
{
    currentName = ds_grid_get(global.board,0,i)
    if ds_list_find_index(global.friends, currentName) != -1
    {
        ds_grid_add(global.friendsBoard, 0, count, currentName)
        ds_grid_add(global.friendsBoard, 1, count, ds_grid_get(global.board,1,i))
        count += 1
    }
    i += 1
}


#define addFriend
name_ok = 0
do
{
    if name_ok = 0
    name = get_string("Insert your friends name.", "")
    if name_ok = 1
    name = get_string(reason+"try again.", "")
    name_ok = 0
    file = file_text_open_read(working_directory + "Filter_Words.txt")
    if string_char_at(name, 1) = " "
    {
            name_ok = 1
            reason = "Cannot start name with a space "
    }
    if string_length(name) > 15
    {
            name_ok = 1
            reason = "Usernames cannot exceed 15 characters"
    }
    if name = ""
    {
    http = 0
    exit
    }
    if name_ok = 0
    {
        regex_setinput(name)
        regex_setexpression("[^a-zA-Z\d\s:]")
        if regex_search() = 1
        {
            name_ok = 1
            reason = "Cannot use special characters "
        }
        regex_setinput(global.uname)
        regex_setexpression("\s")
        if regex_search() = 1
        {
            name_ok = 1
            reason = "Cannot use new lines "
        }
    }
file_text_close(file)
}
until (name_ok = 0);

if ds_list_find_index(global.friends, name) = -1
{
    ini_open("friendList")
        count = ini_read_real("count", "count", 0)
        ini_write_string(string("count"), string("count"), count + 1)
        ini_write_string(string("names"), string(count+1), name)
    ini_close()
}