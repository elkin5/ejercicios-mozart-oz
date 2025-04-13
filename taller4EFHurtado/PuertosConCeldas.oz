declare

% El metodo NuevoPuerto crea un puerto (objeto) y un flujo (stream)
proc {NuevoPuerto S P}
   % Crea una celda para almacenar el final actual del flujo.
   % Esta celda será usada para agregar nuevos elementos.
   TailCell = {NewCell S}   % Estado interno (celda privada)
in
   % Define el procedimiento P que servirá para enviar mensajes.
   % P toma un valor X y lo inserta al final del flujo.
   P = proc {$ X} % Procemiento anónimo para enviar mensajes
         NewTail in % Crea una nueva variable no ligada para extender el flujo
         % NewTail es un "hueco" nuevo al final del stream
         % Todavía no sabemos qué valor tendrá; se ligará después
         % Conecta el mensaje X al final actual del flujo
         % Aquí, @TailCell accede al "final actual" del flujo y
         % lo ligamos a un nuevo par: X|NewTail
         @TailCell = X | NewTail

         % Ahora actualizamos TailCell para que apunte a NewTail.
         % Así, el próximo mensaje se agregará después de NewTail.
         TailCell := NewTail
      end
end

% Enviar mensaje X a través del puerto P
% Simplemente llama al procedimiento P con el mensaje X.
proc {Enviar P X}
   {P X}
end

% Tests 
declare S P in
    {NuevoPuerto S P}  % Crea el puerto P con flujo S
    {Enviar P 10}      % Envía 10 al puerto
    {Enviar P 20}      % Envía 20 al puerto
    {Enviar P 30}      % Envía 30 al puerto
    {Browse S}         % Muestra 10|20|30|_  