
declare

% Procedimiento para crear una nueva celda con valor inicial X
proc {NuevaCelda X C}
   local Procesar Puerto Flujo in
      % Crear un nuevo flujo y un puerto asociado
      {NewPort Flujo Puerto}

      %% El puerto será el identificador para enviar mensajes a la celda
      C = Puerto

      % Procedimiento interno para procesar mensajes que llegan al puerto
      proc {Procesar EstadoActual Mensajes}
         % Separar el primer mensaje (Msg) del resto (Resto)
         case Mensajes of Msg|Resto then
            case Msg of
               % Si el mensaje es un acceso (alguien quiere leer el valor)
               acceder(PuertoRespuesta) then
                  % Se envia el valor actual de la celda al puerto de respuesta
                  {Send PuertoRespuesta EstadoActual}
                  % Se continua procesando el resto de los mensajes
                  {Procesar EstadoActual Resto}

               % Si el mensaje es una asignación de nuevo valor
               [] asignar(NuevoValor PuertoRespuesta) then
                  % Se envia una confirmación (unit) al puerto de respuesta
                  {Send PuertoRespuesta unit}
                  % Se actualiza el valor actual de la celda al nuevo valor
                  {Procesar NuevoValor Resto}
            end
         end
      end

      % Lanzar un hilo (thread) para procesar los mensajes concurrentemente
      % Esto permite que la celda se mantenga arriba y reciba mensajes a medida que llegan
      thread {Procesar X Flujo} end
   end
end

% Obtener el valor actual de la celda
proc {Acceder X C}
   PuertoRespuesta FlujoRespuesta
in
   % Crear un nuevo puerto y flujo para recibir la respuesta
   {NewPort FlujoRespuesta PuertoRespuesta}
   % Enviar un mensaje acceder al puerto de la celda
   {Send C acceder(PuertoRespuesta)}
   % Esperar a que el flujo FlujoRespuesta este disponible
   {Wait FlujoRespuesta}
   % Extraer el primer elemento del flujo recibido
   X = FlujoRespuesta.1
end

% Asignar un nuevo valor a la celda
proc {Asignar X C}
   PuertoRespuesta FlujoRespuesta
in
   % Crear un nuevo puerto y flujo para recibir la confirmación
   {NewPort FlujoRespuesta PuertoRespuesta}
   % Enviar un mensaje asignar al puerto de la celda
   {Send C asignar(X PuertoRespuesta)}
   % Esperar a que la confirmación llegue
   {Wait FlujoRespuesta}
end

% Test
declare
Celda V1 V2
% Crear una celda nueva con valor inicial 10
{NuevaCelda 10 Celda}

% Acceder al valor actual de la celda
{Acceder V1 Celda}
{Browse V1}   % Debe mostrar 10

% Asignar un nuevo valor 20 a la celda
{Asignar 20 Celda}

% Acceder nuevamente al valor actualizado de la celda
{Acceder V2 Celda}
{Browse V2}   % Debe mostrar 20