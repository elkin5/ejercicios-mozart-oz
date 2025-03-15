declare
fun lazy {HagaX} 
   local T1 T2 in
      T1 = {Time.time}
      {Browse x} 
      {Delay 3000} 
      T2 = {Time.time}
      {Browse 'Tiempo HagaX:' # (T2 - T1)}
      1 
   end
end

fun lazy {HagaY} 
   local T1 T2 in
      T1 = {Time.time}
      {Browse y} 
      {Delay 6000} 
      T2 = {Time.time}
      {Browse 'Tiempo HagaY:' # (T2 - T1)}
      2 
   end
end

fun lazy {HagaZ} 
   local T1 T2 in
      T1 = {Time.time}
      {Browse z} 
      {Delay 9000} 
      T2 = {Time.time}
      {Browse 'Tiempo HagaZ:' # (T2 - T1)}
      3 
   end
end

local TStart TEnd in
   TStart = {Time.time} 
   X = {HagaX}
   Y = {HagaY}
   Z = {HagaZ} 

   % {Browse (X+Y)+Z}
   % {Browse X + (Y + Z)}
   local TResult in
      TResult = (X+Y)+Z
      TEnd = {Time.time}
      {Browse 'Tiempo Total:' # (TEnd - TStart)}
      {Browse TResult}
   end
end