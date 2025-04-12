declare
% Convertir una lista en una lista de celdas
fun {MakeCellList L}
    case L
    of nil then nil
    [] H|T then {NewCell H} | {MakeCellList T}
    end
end

% Convertir una lista de celdas en una lista de valores
fun {CellListToValues CL}
    case CL
    of nil then nil
    [] C|T then @C | {CellListToValues T}
    end
end

% BubbleSort: ordena una lista de números usando el algoritmo de burbuja
fun {BubbleSort L}
    CL = {MakeCellList L}
    Swapped = {NewCell true} % Marcar si se han realizado cambios para finalizar el bucle
    proc {InnerLoop Pairs}
        case Pairs
        of C1|C2|Rest then
            if @C1 > @C2 then
                local Temp in
                    Temp = @C1
                    C1 := @C2
                    C2 := Temp
                    Swapped := true
                end
            end
            {InnerLoop C2|Rest}
        [] _ then skip
        end
    end
in
    for while:@Swapped do
        Swapped := false
        {InnerLoop CL}
    end
    {CellListToValues CL}
end

% Tests para la función BubbleSort (ordenamiento de burbuja)
{Browse {BubbleSort [5 3 8 1 2]}} % [1 2 3 5 8]
{Browse {BubbleSort [1]}}         % [1]
{Browse {BubbleSort nil}}         % nil
{Browse {BubbleSort [9 5 7 3 1]}} % [1 3 5 7 9]