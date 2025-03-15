declare

Beers = {NewCell 0}    %% Contador de cervezas en la mesa
Stop = {NewCell false} %% Bandera para detener el proceso

% Bar: Proceso que sirve cervezas
proc {Bar}
    if @Stop then skip else
        if @Beers < 5 then
            {Delay 3000}
            Beers := @Beers + 1
            {System.showInfo "Bar sirvió una cerveza. Hay en la mesa: "#@Beers}
        end
        {Bar}
    end
end

% Foo: Proceso que bebe cervezas
proc {Foo}
    if @Stop then skip else
        if @Beers > 0 then
           {Delay 12000}
           Beers := @Beers - 1
           {System.showInfo "Foo bebió una cerveza. Hay en la mesa: "#@Beers}
        end
        {Foo}
    end
end

% Tiempo de ejecución de la simulación
proc {Timer}
    % Delay de 3 minutos (180000 ms)
    {Delay 180000} 
    Stop := true
    {System.showInfo "Tiempo terminado. Bar se detiene."}
end

thread {Bar} end
thread {Foo} end
thread {Timer} end
