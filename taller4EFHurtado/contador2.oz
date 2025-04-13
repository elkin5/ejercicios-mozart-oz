declare

% Función general para crear un objeto puerto reactivo
fun {NuevoObjetoPuerto Comp Inic}
   proc {MsgLoop S Estado}
      case S of Msg|Resto then
         {MsgLoop Resto {Comp Msg Estado}}
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Inic} end
   {NewPort Sin}
end

fun {Comp Msg Counts}
   case Msg of
      acceso(Retorno) then
         Retorno = Counts   % Para retornar el conteo actual
         Counts
   [] Char then
      NewCounts = {UpdateCounts Counts Char}
   in
      {Send LoggerPort counterUpdated(Char NewCounts)}
      NewCounts
   end
end

% Logger: objeto no reactivo
fun {Logger}
   fun {Comp Msg Estado}
      {Browse Msg}  % Muestra el mensaje recibido
      Estado        % No cambia su estado
   end
in
   {NuevoObjetoPuerto Comp unit}
end

% Counter: objeto reactivo que interactúa con Logger
fun {Counter LoggerPort}
   fun {UpdateCounts Counts Char}
      case Counts of nil then [Char#1]
      [] C#N | Rest then
         if C == Char then (Char#(N+1))|Rest
         else C#N | {UpdateCounts Rest Char}
         end
      end
   end
in
   {NuevoObjetoPuerto Comp nil}
end

% test
declare
CounterPort LoggerPort Res

% Crear Logger y Counter
LoggerPort = {Logger}
CounterPort = {Counter LoggerPort}

% Simular actividad del contador
{Send CounterPort a}
{Send CounterPort b}
{Send CounterPort a}
{Send CounterPort c}

% Ahora pedimos el estado final
{Send CounterPort acceso(Res)}
{Browse Res}