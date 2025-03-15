declare
fun {FactList N}
    if N == 1 then
        [1]
    else
        Prev Current in
            Prev = {FactList N - 1}
            Current = {Nth Prev {Length Prev}} * N
            {Append Prev [Current]}
        end
    end

%% prueba
declare
L = {FactList 5}
% debería mostrar [1 2 6 24 120]
{Browse L}