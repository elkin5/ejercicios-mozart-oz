declare
% Compuerta NOT
fun {Not X}
   if X == 0 then 1 else 0 end
end
 
%  Compuerta NOT usando registros
proc {NotGate Xs Ys}
   case Xs of X|Xr then Yr in
      Ys = {Not X}|Yr
      {NotGate Xr Yr}
   else
      Ys = nil
   end
end
 
 % Compuertas AND
fun {And X Y}
   if X == 1 andthen Y == 1 then 1 else 0 end
end

%  Compuerta AND usando registros
proc {AndGate A B Ys}
   case A|B of (X|Ar)|(Y|Br) then Yr in
      Ys = {And X Y}|Yr
      {AndGate Ar Br Yr}
   else
      Ys = nil
   end
end
 
%  Compuertas OR
fun {Or X Y}
   if X == 1 orelse Y == 1 then 1 else 0 end
end
 
%  Compuerta OR usando registros
proc {OrGate A B Ys}
   case A|B of (X|Ar)|(Y|Br) then Yr in
      Ys = {Or X Y}|Yr
      {OrGate Ar Br Yr}
   else
      Ys = nil
   end
end
 
% Simulación de circuitos
%  funcion para obtener el stream de cada variable y reemplazarla en la estructura
fun {GetStream Var Ss}
   {System.showInfo 'Var '#Var}
   Ss.Var
end
 
%  Funcion para simular un circuito
fun {Simulate G Ss}
   case G
   of input(V) then % validar si la estructura de la entrada G es una variable
      {GetStream V Ss} % obtener el stream de la variable V en Ss, asignacion se stream a variable
   [] gate(value:Op ...) then % validar si la estructura de la entrada G es una compuerta
      Inputs = {Record.toListInd G} % Convertir la estructura de la compuerta en una lista de entradas clave-valor Inputs = [value#'or' gate#gate(value:'and' input(x) input(y)) gate#gate(value:'not' input(z))]
      Filtered = {Filter Inputs fun {$ F#_} F \= value end} % Excluir las clave que son value                    Filtered = [gate#gate(value:'and' input(x) input(y)) gate#gate(value:'not' input(z))]
      InputGates = {Map Filtered fun {$ _#V} V end} % Extraer los valores de las entradas                      InputGates = [gate(value:'and' input(x) input(y)) gate(value:'not' input(z))]
      SimulatedInputs = {Map InputGates fun {$ In} {Simulate In Ss} end} % llamado recursivo para cada sub compuerta
   in
       % Evaluar el tipo de compuerta de manera concurrente
       case Op
       of 'not' then
           [A] = SimulatedInputs % Extraer la única entrada simulada que es la entrada de la compuerta NOT
           Ys % Retornar el stream de la compuerta NOT
       in
         thread {NotGate A Ys} end
         Ys
       [] 'and' then
           [A B] = SimulatedInputs
           Ys
       in
           thread {AndGate A B Ys} end
         Ys
       [] 'or' then
           [A B] = SimulatedInputs
           Ys
       in
           thread {OrGate A B Ys} end
           Ys
       else
           nil
       end
   else
      nil
   end
end
 
% Sumador Completo
% Funciones para crear compuertas concurrentes
fun {CAnd A B}
   Ys in
   thread {AndGate A B Ys} end
   Ys
end

fun {COr A B}
   Ys in
   thread {OrGate A B Ys} end
   Ys
end

fun {CXor A B}
   NotA NotB Part1 Part2 in
   thread {NotGate A NotA} end
   thread {NotGate B NotB} end
   thread {AndGate A NotB Part1} end
   thread {AndGate NotA B Part2} end
   {COr Part1 Part2}
end

% Sumador Completo (3 entradas, 2 salidas)
proc {SumadorCompleto X Y Z C S}
   K L M in
   K = {CAnd X Y} 
   L = {CAnd Y Z}      
   M = {CAnd X Z}
   C = {COr K {COr L M}}
   S = {CXor Z {CXor X Y}}
end

% Prueba sumador completo
declare
X = 1|1|0|_
Y = 0|1|0|_
Z = 1|1|1|_
C S         
in
{SumadorCompleto X Y Z C S}
{Browse ent(X Y Z)#suma(C S)}

% Parte e: Pruebas simulador de circuitos
%% Definición del circuito G según el ejemplo:
% gate se usa en oz para definir una compuerta
G = gate(value:'or'
          gate(value:'and' input(x) input(y))
          gate(value:'not' input(z)))

%% Realizamos la simulación usando los streams:
Result = {Simulate G input(x:1|0|1|0|_ y:0|1|0|1|_ z:1|1|0|0|_)}

%% Mostramos el resultado; se espera 0|0|1|1|_
{Browse Result}