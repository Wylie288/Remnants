avs = global.speed_start * power(global.speed_increase,global.distance/30)//Average Speed Calculation
if global.distance > 310
avs = global.speed2_increase * power(global.distance,1/2) - global.speed2_start
avs += 10
