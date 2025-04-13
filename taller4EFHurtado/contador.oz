declare

% Función para actualizar conteos
fun {UpdateCounts Counts Char}
   case Counts of nil then [Char#1]
   [] C#N | Rest then
      if C == Char then (Char#(N+1)) | Rest
      else C#N | {UpdateCounts Rest Char} end
   end
end

% Servidor: Procesa mensajes del puerto
proc {CounterServer InStream OutStream}
   proc {Loop Counts InStream OutStream}
      case InStream of Char|Rest then
         {Delay (100 + {OS.rand} mod 300)}   % Retardo aleatorio en el servidor pra lograr resultados distintos en cada ejecución
         NewCounts = {UpdateCounts Counts Char}
      in
         OutStream = NewCounts | {Loop NewCounts Rest}
      else
         OutStream = nil
      end
   end
in
   {Loop nil InStream OutStream}
end

% Cliente: Envía caracteres al puerto
proc {Client Chars Port}
   case Chars of C|Cr then
      {Delay (100 + {OS.rand} mod 800)}   % Delay para lograr resultados distintos en cada ejecución
      {Send Port C}
      {Client Cr Port}
   else
      skip
   end
end

% Test 
declare
Port Stream OutStream

{NewPort Stream Port}  % Crear puerto único
thread {CounterServer Stream OutStream} end  % Servidor en hilo
{Browse OutStream}     % Mostrar flujo de salida

% Lanzar clientes concurrentes
thread {Client a|c|nil Port} end    % Cliente 1
thread {Client b|c|nil Port} end    % Cliente 2
thread {Client a|nil Port} end      % Cliente 3

% thread {Client x|y|a|b|c Port} end  % Cliente 1
% thread {Client a|b|a|c Port} end    % Cliente 2