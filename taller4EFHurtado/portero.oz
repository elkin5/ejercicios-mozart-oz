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

% Logger: objeto no reactivo
fun {Logger}
   fun {Comp Msg Estado}
      {Browse Msg}  % Muestra el mensaje recibido
      Estado        % No cambia su estado
   end
in
   {NuevoObjetoPuerto Comp unit}
end

% Portero: objeto puerto reactivo que interactúa con el Logger
fun {Portero LoggerPort}
   fun {Comp Msg Estado}
      case Msg
      of getIn(N) then
         NewEstado = Estado + N
      in
         {Send LoggerPort porteroIn(N NewEstado)}
         NewEstado
      [] getOut(N) then
         NewEstado = {Max Estado-N 0}
      in
         {Send LoggerPort porteroOut(N NewEstado)}
         NewEstado
      [] getCount(Ret) then
         Ret = Estado
         {Send LoggerPort porteroReport(Estado)}
         Estado
      end
   end
in
   {NuevoObjetoPuerto Comp 0}
end

% test
declare
PorteroPort LoggerPort Count

LoggerPort = {Logger}
PorteroPort = {Portero LoggerPort}

{Send PorteroPort getIn(5)}     % Entraron 5 personas
{Send PorteroPort getOut(2)}    % Salieron 2 personas
{Send PorteroPort getCount(Count)} % Pide cuantas personas hay
{Browse Count} % Debe mostrar 3