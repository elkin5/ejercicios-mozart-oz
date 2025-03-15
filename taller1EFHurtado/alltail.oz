declare

% Aplicar un procedimiento a todos los elementos de una lista reduciendo la lista en cada iteración
proc {ForAllTail Xs P}
    if Xs \= nil then
        {P Xs}
        {ForAllTail Xs.2 P}
    end
end

% Procedimiento P para imprimir una lista
declare
proc {PrintList L} {Browse L} end

% Prueba
{ForAllTail [1 2 3 4] PrintList}