declare

% Funcion para actualizar el conteo de caracteres
fun {UpdateCounts Counts Char} 
   case Counts of nil then [Char#1]
   [] C#N | Rest then
      if C == Char then (Char#(N+1)) | Rest
      else
         C#N | {UpdateCounts Rest Char} 
      end
   end
end

% Servidor : Proceso contador
fun {Counter InStream}
   {Show 'Inicio de la funcion' | InStream}
   fun {CounterHelper InStream Counts}
      case InStream of Char|InStreamTail then
         {Show 'Caracter ' | Char}
         NewCounts = {UpdateCounts Counts Char}
      in
         {Show 'Nuevo conteo ' | NewCounts}
         NewCounts | {CounterHelper InStreamTail NewCounts}
      else
         nil
      end
   end
in
   {Show 'Crea la lista de respuesta' | InStream}
   {CounterHelper InStream nil}
end

% Cliente : Generador de caracteres
fun {Client Chars}
   case Chars of C|Cr then
      {Delay (500 + {OS.rand} mod 500)}
      C | {Client Cr}
   else
       nil
   end
end

% Mezcla de flujos de caracteres
fun {MergeHelper ClientStreams}
   {Show 'Inicio del tratamiento de los streams ' | ClientStreams}
   case ClientStreams of nil then nil
   [] Stream|Rest then
      case Stream of nil then {MergeHelper Rest}
      [] Char|Tail then
         Char | {MergeHelper {Append Rest [Tail]}}
      end
   end
end

% Programa principal con concurrencia evidente
% local
%    Client1Stream Client2Stream MergedStream OutStream
% in
%    thread Client1Stream = {Client [a b a c]} end
%    thread Client2Stream = {Client [x y a]} end
%    thread MergedStream = {MergeHelper [Client1Stream Client2Stream]} end
%    thread OutStream = {Counter MergedStream} end
%    {Browse OutStream}
% end

% local
%    Client1Stream Client2Stream MergedStream OutStream
% in
%    thread Client1Stream = {Client a | b | a |c |_ } end  % Hilo cliente 1
%    thread Client2Stream = {Client x | y | a | b | c |_} end    % Hilo cliente 2
%    thread MergedStream = {MergeHelper [Client1Stream Client2Stream]} end  % Mezcla los flujos de clientes
%    thread OutStream = {Counter MergedStream} end  % Cuenta los caracteres en el flujo mezclado
%    {Browse OutStream}  % Muestra el resultado
% end

% local
%    Client1Stream Client2Stream MergedStream OutStream
% in
%    thread Client1Stream =  {Client x | y | a | b | c |_} end  % Hilo cliente 1
%    thread Client2Stream = {Client a | b | a |c |_ } end    % Hilo cliente 2
%    thread MergedStream = {MergeHelper [Client1Stream Client2Stream]} end  % Mezcla los flujos de clientes
%    thread OutStream = {Counter MergedStream} end  % Cuenta los caracteres en el flujo mezclado
%    {Browse OutStream}  % Muestra el resultado
% end

local
   Client1Stream Client2Stream MergedStream OutStream ContClient1 ContClient2
in
   thread Client1Stream =  {Client x | y | a | b | c |ContClient1} end  % Hilo cliente 1
   thread Client2Stream = {Client a | b | a |c |ContClient2 } end    % Hilo cliente 2
   thread MergedStream = {MergeHelper [Client1Stream Client2Stream]} end  % Mezcla los flujos de clientes
   thread OutStream = {Counter MergedStream} end  % Cuenta los caracteres en el flujo mezclado
   {Browse OutStream}  % Muestra el resultado
   {Delay 5000}
end