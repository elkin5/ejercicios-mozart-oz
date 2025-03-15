declare

% Función para actualizar los conteos de caracteres
fun {UpdateCounts Counts Char}
   case Counts of nil then [Char#1]
   [] C#N | Rest then
      if C == Char then
         (Char#(N+1)) | Rest
      else
         C#N | {UpdateCounts Rest Char}
      end
   end
end

% Proceso contador (servidor)
proc {Counter InStream OutStream}
   proc {CounterHelper InStream Counts OutStream}
      case InStream of Char|InStreamTail then
         local NewCounts in
            NewCounts = {UpdateCounts Counts Char}
            {Show NewCounts}
            OutStream = NewCounts | {CounterHelper InStreamTail NewCounts}
         end
      else
         OutStream = nil
      end
   end
in
   {CounterHelper InStream nil OutStream}
end

% Creación del puerto y flujo de entrada
local
   Port
   Stream
   OutStream
in
   {NewPort Stream Port}
   thread {Counter Stream OutStream} end
   {Show OutStream}

   % Clientes
   proc {Client Chars}
      for C in Chars do
         {Send Port C}
      end
   end

   % Ejemplo con 2 clientes
   thread {Client [a b a c]} end
   thread {Client [x y]} end
end