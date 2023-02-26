#define scr_packet_server
buffer = argument0
socket = argument1
buffer_seek(buffer, buffer_seek_start, 0)
message_id = buffer_read(buffer, buffer_u8)
switch (message_id)
{
    case NAME:
        scr_name_s(buffer,socket)
    break;
    case SENDRECORD:
        scr_sendrecord(buffer,socket)
    break;
    case GETRECORD:
        scr_getrecord(buffer,socket)
    break;
    case GETBOARD:
        scr_getboard(buffer,socket)
    break;
}

#define scr_name_s
buffer = argument0
socket = argument1

name = buffer_read(buffer, buffer_string)
newname = buffer_read(buffer, buffer_u8)
taken = 0

if newname = 1
{
    ini_open("Names")
    count = ini_read_real("count","count",0)
    
    i = 0
    repeat(count)
    {
        i++
        if ini_read_string(string(i),"name","") = name
            taken = 1
    }
    
    if taken = 1
    {
        buffer_seek(global.buffer, buffer_seek_start, 0)
        buffer_write(global.buffer,buffer_u8,NAMETAKEN)
        buffer_write(global.buffer,buffer_u8,1)
        network_send_packet(socket,global.buffer,buffer_tell(global.buffer))
        server_log += "#" + get_time_log() + name + " was already in the list of players"
    }
    
    if taken = 0
    {
        server_log += "#" + get_time_log() + name + " was added to list of players"
        count += 1
        ini_write_string(string(count),"name",name)
        ini_write_real("count","count",count)
        buffer_seek(global.buffer, buffer_seek_start, 0)
        buffer_write(global.buffer,buffer_u8,NAMETAKEN)
        buffer_write(global.buffer,buffer_u8,0)
        network_send_packet(socket,global.buffer,buffer_tell(global.buffer))
    }
    ini_close()
}

if taken = 0
{
    server_log += "#" + get_time_log() + name + "'s name was resolved"
    ds_list_add(name_list,name)
    ini_open("online")
        ini_write_string(string(socket),"name",name)
    ini_close()
}


#define scr_sendrecord
buffer = argument0
socket = argument1

record = buffer_read(buffer, buffer_u16)
name = buffer_read(buffer, buffer_string)

ini_open("Names")
    count = ini_read_real("count","count",0)
    
    i = 0
    repeat(count)
    {
        i++
        if ini_read_string(string(i),"name","") = name
        {
            ini_write_real(string(i),"record",record)
            server_log += "#" + get_time_log() + name + " got a new record of " + string(record)
        }
    }
ini_close()

#define scr_getrecord
buffer = argument0
socket = argument1

name = buffer_read(buffer, buffer_string)

ini_open("Names")
    count = ini_read_real("count","count",0)
    
    i = 0
    repeat(count)
    {
        i++
        if ini_read_string(string(i),"name","") = name
            record = ini_read_real(string(i),"record",0)
    }
ini_close()

ini_open("online")
        uname = ini_read_string(string(socket),"name","")
ini_close()

server_log += "#" + get_time_log() + uname + " requested record for " + name +  "(" + string(record) + ")"

buffer_seek(global.buffer, buffer_seek_start, 0)
buffer_write(global.buffer,buffer_u8,GETRECORD)
buffer_write(global.buffer,buffer_u16,record)
network_send_packet(socket,global.buffer,buffer_tell(global.buffer))
#define scr_getboard
buffer = argument0
socket = argument1

buffer_seek(global.buffer, buffer_seek_start, 0)
buffer_write(global.buffer,buffer_u8,GETBOARD)

ini_open("Names")
count = ini_read_real("count","count",0)
buffer_write(global.buffer,buffer_u32,count)
    i = 0
    repeat(count)
    {
        i++
        buffer_write(global.buffer,buffer_string,ini_read_string(string(i),"name","ERROR"))
        buffer_write(global.buffer,buffer_u16,round(ini_read_real(string(i),"record",0)))
    }
ini_close()

network_send_packet(socket,global.buffer,buffer_tell(global.buffer))
server_log += "#" + get_time_log() + "Board Requested"
