%% amigos.oz
declare
fun {SumDebt Comp Deudas}
   {FoldL Comp fun {$ Acc Person} Acc + {Nth Deudas Person} end 0}
end

fun {BuildAdj Amistades N}
   Adj = {NewDictionary}
in
   for I in 1..N do
      Adj.I := nil
   end
   for Pair in Amistades do
      case Pair of I#J then
         if I > 0 andthen I =< N andthen J > 0 andthen J =< N then
            Adj.I := J | Adj.I
            Adj.J := I | Adj.J
         else
            raise invalidPair(I#J) end
         end
      end
   end
   Adj
end

proc {DFS Node Adj Visited Comp}
   if {Not {HasFeature Visited Node}} then
      Visited.Node := true
      Comp := Node | @Comp
      for Neighbor in Adj.Node do
         {DFS Neighbor Adj Visited Comp}
      end
   end
end

fun {FindComponents Adj N}
   Visited = {NewDictionary}
   Components = {NewCell nil}  % Ahora es una celda
in
   for I in 1..N do
      if {Not {HasFeature Visited I}} then
         Comp = {NewCell nil}
      in
         {DFS I Adj Visited Comp}
         Components := {Reverse @Comp} | @Components  % Acceso correcto
      end
   end
   {Reverse @Components}  % Retorna la lista de componentes
end

fun {PagoDeuda Amistades Deudas}
   N = {Length Deudas}
   Adj = {BuildAdj Amistades N}
   Components = {FindComponents Adj N}
in
   {All Components fun {$ Comp} {SumDebt Comp Deudas} == 0 end}
end

%% Ejemplos
{Browse {PagoDeuda [1#2 2#3 4#5] [100 ~75 ~25 ~42 42]}} % true
{Browse {PagoDeuda [1#3 2#4] [15 20 ~10 ~25]}} % false
