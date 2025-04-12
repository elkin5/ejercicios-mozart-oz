declare
fun {Fibo N}
    if N < 2 then 
        1
    else
        A = {NewCell 1}  % Celda para Fib(n-2)
        B = {NewCell 1}  % Celda para Fib(n-1)
    in
        for I in 2..N do
            local Sum in
                Sum = @A + @B
                A := @B
                B := Sum
            end
        end
        @B
    end
end

% Tests para la función Fibonacci
{Browse {Fibo 0}} % Resultado: 1
{Browse {Fibo 1}} % Resultado: 1
{Browse {Fibo 2}} % Resultado: 2
{Browse {Fibo 5}} % Resultado: 8
{Browse {Fibo 6}} % Resultado: 13