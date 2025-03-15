declare

%% Función recursiva para Fibonacci
fun {FibRec N}
    if N < 2 then 1
    else {FibRec (N-1)} + {FibRec (N-2)}
    end
end

declare
% Función iterativa para Fibonacci
fun {FibIter N}
    fun {Aux I A B}
        if I > N then A
        else {Aux (I+1) B (A+B)}
        end
    end
in
    {Aux 0 1 1}
end

%% Prueba recursiva
% declare
% N = 100
% R = {FibRec N}
% {Browse R}

% No calcula el valor de N = 100 debido a que la recursión es muy lenta

%% Prueba iterativa --> si calcula el valor de N = 100
declare
N = 100  
R = {FibIter N}
{Browse R}