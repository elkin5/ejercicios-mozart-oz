declare

%% En lugar de devolver valores se utiliza una variable por
% referencia que permite ser modificada y en la que se almacena el resultado
proc {Max L ?Result}
    proc {MaxLoop L CurrentMax ?Result}
       case L
       of nil then Result = CurrentMax
       [] H|T then
            if CurrentMax > H then
               {MaxLoop T CurrentMax Result}
            else
               {MaxLoop T H Result}
          end
        end
    end
in
    if L == nil then
       Result = error
    else
       {MaxLoop L.2 L.1 Result}
    end
end

%% Prueba
declare X
{Max [3 1 4 1 5 9 2 6 5 3] X}
 %% Debería mostrar 9
{Browse X}