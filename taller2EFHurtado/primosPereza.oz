declare
% Generación perezosa de una lista infinita de enteros desde I
fun lazy {Gen I}
    I|{Gen I+1}
end

% Criba de Eratóstenes
% Filtra los números primos de una lista de enteros
fun lazy {LazyFilter Xs P}
    case Xs
    of X|Xr then
        if {P X} then
            X|{LazyFilter Xr P}
        else
            {LazyFilter Xr P}
        end
    end
end

fun lazy {Criba Xs}
    case Xs
    of X|Xr then
        X|{Criba {LazyFilter Xr fun {$ Y} Y mod X \= 0 end}}
    end
end

% Lista infinita de primos usando la Criba de Eratóstenes perezosa iniciando desde 2
fun {Primes}
    {Criba {Gen 2}}
end

% Mostrar los primeros N números primos
proc {ShowPrimes N}
    PrimesList = {Primes}
    proc {Loop Lst Count}
        if Count < N then
            case Lst
            of H|T then
                {Show H}
                {Loop T Count+1}
            end
        end
    end
in
    {Loop PrimesList 0}
end

% Prueba
% Mostrar los primeros 10 números primos
{ShowPrimes 10}