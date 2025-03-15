declare
% Productor: Genera un flujo de 10000 numeros enteros
fun {Producer N}
   if N == 0 then nil
   else N|{Producer N-1} end
end

% Filtro: Filtra los numeros impares de la lista
fun {FilterOdds Xs}
   case Xs of nil then nil
   [] X|Xr then
      if X mod 2 == 1 then X|{FilterOdds Xr}
      else {FilterOdds Xr} end
   end
end

% Consumidor: Suma los elementos del flujo filtrado
fun {Consumer Xs}
   case Xs of nil then 0
   [] X|Xr then X + {Consumer Xr} end
end

declare Valores ValoresFiltrados Suma

% Ejecucion asycrona
thread Valores = {Producer 10000} end
thread ValoresFiltrados = {FilterOdds Valores} end
thread Suma = {Consumer ValoresFiltrados} end

{Browse Sum}