declare
fun {Q A B}
    SumCell = {NewCell 0}
    Lower = {Min A B}
    Upper = {Max A B}
in
    for I in Lower..Upper do
        SumCell := @SumCell + I
    end
    @SumCell
end

% Tests para la funcion Q
{Browse {Q 1 5}} % Resultado 15
{Browse {Q 3 3}} % Resultado 3
{Browse {Q 5 3}} % Resultado 12
{Browse {Q 0 0}} % Resultado 0
{Browse {Q 2 4}} % Resultado 9