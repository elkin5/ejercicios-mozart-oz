declare
%% Sumar deudas (valor del camino)
fun {SumDebt Comp Deudas}
   {FoldL Comp fun {$ Acc X} Acc + {Nth Deudas X} end 0}
end

%% Construir lista de adyacencia (el grafo)
fun {BuildAdj Amistades N}
   Adj = {NewArray 1 N nil}
in
   for Pair in Amistades do
      case Pair of I#J then
         if I >= 1 andthen I =< N andthen J >= 1 andthen J =< N then
            Adj.I := J | {Array.get Adj I}
            Adj.J := I | {Array.get Adj J}
         else
            raise invalidPair(I#J) end
         end
      end
   end
   Adj
end

%% Realizar busqueda en profundidad (DFS) para encontrar elementos conexos y marcarlos
proc {DFS Node Adj Visited Comp}
   if {Array.get Visited Node} == false then
      {Array.put Visited Node true}
      Comp := Node | @Comp
      for Neighbor in {Array.get Adj Node} do
         {DFS Neighbor Adj Visited Comp}
      end
   end
end

%% Encontrar elementos conexos
fun {FindElements Adj N}
   Visited = {NewArray 1 N false}
   Elements = {NewCell nil}
in
   for I in 1..N do
      if {Array.get Visited I} == false then
         Elem = {NewCell nil}
      in
         {DFS I Adj Visited Elem}
         Elements := {Reverse @Elem} | @Elements
      end
   end
   {Reverse @Elements}
end

%% Función principal que verifica si todos los componentes tienen deudas que se cancelan entre sí
fun {PagoDeuda Amistades Deudas}
   N = {Length Deudas}
   Adj = {BuildAdj Amistades N}
   Components = {FindElements Adj N}
in
   {All Components fun {$ Comp} {SumDebt Comp Deudas} == 0 end}
end

%% Tests para la función PagoDeuda
{Browse {PagoDeuda [1#2 2#3 4#5] [100 ~75 ~25 ~42 42]}}  % Respuesta: true
{Browse {PagoDeuda [1#3 2#4] [15 20 ~10 ~25]}}           % Respuesta: false
