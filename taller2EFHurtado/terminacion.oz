declare
L1 L2 L3 L4
L1 = [1 2 3]
thread L2 = {Map L1 fun {$ X} {Delay 200} X*X end} end
thread L3 = {Map L1 fun {$ X} {Delay 200} 2*X end} end
thread L4 = {Map L1 fun {$ X} {Delay 200} 3*X end} end

% Realizar un wait para cada uno de los elementos de la lista
proc {WaitList L}
   case L of nil then skip
   [] H|T then
      {Wait H}
      {WaitList T}
   end
end

{WaitList L2}
{WaitList L3}
{WaitList L4}
{Show L2#L3#L4}