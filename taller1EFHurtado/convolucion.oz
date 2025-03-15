declare
fun {Convolution Xs Ys}
    fun {Iterate Xs ReversedYs Acc}
        case Xs of nil then {Reverse Acc}
        [] X|Xr then 
            case ReversedYs of Y|Yr then
                {Iterate Xr Yr (X#Y | Acc)}
            end
        end
    end
    fun {ReverseList Ys Acc}
        case Ys of nil then Acc
        [] Y|Yr then {ReverseList Yr Y|Acc}
        end
    end
    ReversedYs = {ReverseList Ys nil}
in
    {Iterate Xs ReversedYs nil}
end

% Prueba
declare
L = {Convolution [x1 x2 x3] [y1 y2 y3]}
% Debería mostrar [x1#y3 x2#y2 x3#y1]
{Browse L}  