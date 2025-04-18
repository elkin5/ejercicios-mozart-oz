declare

%desempaqueta una clase y la devuelve
fun {Desenvolver Clase}
   Clase
end

% Empaqueta una nueva clase a partir de métodos y atributos
fun {Envolver c(metodos:M atrbs:A)}
   c(metodos:M atrbs:A)
end

% Crear nuevo objeto (new)
fun {Nuevo ClaseEmp MetodoInicial}
    Estado Obj Clase = {Desenvolver ClaseEmp}
in
    Estado = {MakeRecord s Clase.atrbs}
    {Record.forAll Estado proc {$ A} {NewCell _ A} end}
    proc {Obj M}
        {Clase.metodos.{Label M} M Estado Obj}
    end
    {Obj MetodoInicial}
    Obj
end

% Elimina duplicados de una lista
fun {EliminarDuplicados L}
    case L
    of nil then nil
    [] X|Xs then
        if {Member X Xs} then
            {EliminarDuplicados Xs}
        else
            X | {EliminarDuplicados Xs}
        end
    end
end

% Función principal para realizar herencia múltiple
fun {NuevaHeredarDe Clase SuperClases}
   % Desenvolver la clase base
   c(metodos:M1 atrbs:A1) = {Desenvolver Clase}
   
   % Desenvolver todas las superclases
   SuperDatos = {Map SuperClases fun {$ SC} {Desenvolver SC} end}
   
   % Separar métodos y atributos de las superclases
   MetodosList = {Map SuperDatos fun {$ c(metodos:M atrbs:A)} M end}
   AtrbsList   = {Map SuperDatos fun {$ c(metodos:M atrbs:A)} A end}
   
   % Extraer nombres de métodos y atributos de todas las superclases
   MetodosNombres = {FoldL MetodosList
      fun {$ Acc M} {Append Acc {Arity M}} end
      nil}
   
   AtrbsNombres = {FoldL AtrbsList
      fun {$ Acc A} {Append Acc A} end
      nil}
   
   %Detectar conflictos
   fun {Conflictos L}
      fun {Contar X L}
         {Length {Filter L fun {$ Y} Y == X end}}
      end
   in
      {Filter {EliminarDuplicados L} fun {$ X} {Contar X L} > 1 end}
   end
   ConflictosMetodos = {Minus {Conflictos MetodosNombres} {Arity M1}}
   ConflictosAtrbs   = {Minus {Conflictos AtrbsNombres} A1}

   % Unir todo
   AllMetodos = {FoldL MetodosList
      fun {$ Acc M} {Adjoin Acc M} end
      M1}
   
   AllAtrbs = {FoldL AtrbsList
      fun {$ Acc A} {Union Acc A} end
      A1}
in
   % Si hay conflictos lanzar errores
   if ConflictosMetodos \= nil then
      raise herenciaIlegal(metEnConfl:ConflictosMetodos) end
   end
   if ConflictosAtrbs \= nil then
      raise herenciaIlegal(atrEnConfl:ConflictosAtrbs) end
   end

   % Empaquetar y devolver nueva clase
   {Envolver c(metodos:AllMetodos atrbs:AllAtrbs)}
end

% Tests 

% %
% % Un ejemplo para probar la herencia m�ltiple.
% % Definici�n de las clases Contador, Disminuir y Restaurar
% %
local Contador Disminuir Restaurar ClaseResultado Obj
    local
        Atrbs = [val]
        TablaDeMetodos = m(browse:MiBrowse inic:Inic inc:Inc)
        proc {Inic M S Self}
            inic(Valor) = M
        in
            {Assign S.val Valor}
        end
        proc {Inc M S Self}
            X
            inc(Valor) = M
        in
            X = {Access S.val}
            {Assign S.val X+Valor}
        end
        proc {MiBrowse M S Self}
            M = browse
        in
            {Browse {Access S.val}}
        end
    in
        Contador = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
    end
    local
        Atrbs = nil
        TablaDeMetodos = m(dism:Dism)
        proc {Dism M S Self}
            X
            dism(Valor) = M
        in
            X = {Access S.val}
            {Assign S.val X-Valor}
        end
    in
        Disminuir = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
    end
    local
        Atrbs = nil
        TablaDeMetodos = m(restaurar:VSet)
        proc {VSet M S Self}
            restaurar(Valor) = M
        in
            {Assign S.val Valor}
        end
    in
        Restaurar = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
    end
in
    ClaseResultado = {NuevaHeredarDe Contador [Disminuir Restaurar]}
    % Esto se puede lograr con la función HeredarDe tomada del libro
    % ClaseResultado = {HeredarDe Contador Disminuir Restaurar}
    % Descomente la línea anterior y comente la línea que invoca NuevaHeredarDe
    % para ver los resultados esperados.
    Obj = {Nuevo ClaseResultado inic(10)}
    {Obj browse}
    {Obj inc(3)}
    {Obj browse}
    {Obj dism(4)}
    {Obj browse}
    {Obj restaurar(0)}
    {Obj browse}
end
 

% Un ejemplo para probar la herencia m�ltiple.
% Debe fallar porque hay un m�todo presente
% en las superclases Disminuir y DisminuirMul,
% pero no est� en la clase Contador

% local Contador Disminuir DisminuirMul Restaurar ClaseResultado Obj
%     local
%         Atrbs = [val]
%         TablaDeMetodos = m(browse:MiBrowse inic:Inic inc:Inc)
%         proc {Inic M S Self}
%             inic(Valor) = M
%         in
%             {Assign S.val Valor}
%         end
%         proc {Inc M S Self}
%             X
%             inc(Valor) = M
%         in
%             X = {Access S.val}
%             {Assign S.val X+Valor}
%         end
%         proc {MiBrowse M S Self}
%             M = browse
%         in
%             {Browse {Access S.val}}
%         end
%     in
%         Contador = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
%     end
%     local
%         Atrbs = nil
%         TablaDeMetodos = m(dism:Dism)
%         proc {Dism M S Self}
%             X
%             dism(Valor) = M
%         in
%             X = {Access S.val}
%             {Assign S.val X-Valor}
%         end
%     in
%         Disminuir = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
%     end
%     local
%         Atrbs = nil
%         TablaDeMetodos = m(dism:Dism2 dismmul:DismMul)
%         proc {Dism2 M S Self}
%             X
%             dism(Valor) = M
%         in
%             X = {Access S.val}
%             {Assign S.val X-Valor}
%         end
%         proc {DismMul M S Self}
%             dismmul(Valor Factor) = M
%         in
%             {Assign S.val {Access S.val}-(Valor*Factor)}
%         end
%     in
%         DisminuirMul = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
%     end
%     local
%         Atrbs = nil
%         TablaDeMetodos = m(restaurar:VSet)
%         proc {VSet M S Self}
%             restaurar(Valor) = M
%         in
%             {Assign S.val Valor}
%         end
%     in
%         Restaurar = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
%     end
% in
%     ClaseResultado = {NuevaHeredarDe Contador [Disminuir DisminuirMul Restaurar]}

%     Obj = {Nuevo ClaseResultado inic(10)}
%     {Obj browse}
%     {Obj inc(3)}
%     {Obj browse}
%     {Obj dismmul(4 2)}
%     {Obj browse}
%     {Obj restaurar(0)}
%     {Obj browse}
% end
 
 