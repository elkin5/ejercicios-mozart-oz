% La funcion no es iterativa porque no se utiliza una variable de acumulación 
% en cambio se utilizan retrollamados a si misma por lo que debe recordar el estado
% de la llamada anterior

% Funcioon iterativa para la suma
declare

fun {SumIter N}
    fun {Sum N Acc}
       if N == 0 then Acc
       else {Sum N-1 Acc + N}
       end
    end
 in
    {Sum N 0}
 end

% Prueba
declare
L = {SumIter 5}
% Muestra 15
{Browse L}