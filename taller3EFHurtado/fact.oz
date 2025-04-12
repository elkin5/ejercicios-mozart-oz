declare
fun {Factorial N}
    Result = {NewCell 1}
in
    for I in 1..N do
        Result := @Result * I
    end
    @Result
end

% Tests para la función Factorial
{Browse {Factorial 0}} % Resultado: 1
{Browse {Factorial 5}} % Resultado: 120
{Browse {Factorial 3}} % Resultado: 6