declare

fun {Add B1 B2}
    R1 = {Reverse B1}
    R2 = {Reverse B2}
    fun {Iterate L1 L2 Carry Acc}
       case L1#L2 of (H1|T1)#(H2|T2) then
            local Sum NewSumBit NewCarry in
                Sum = H1 + H2 + Carry
                NewSumBit = Sum mod 2
                NewCarry = Sum div 2
                {Iterate T1 T2 NewCarry NewSumBit | Acc}
            end
        [] nil#nil then
            if Carry == 1 then Carry | Acc else Acc end
        end
    end
in
    {Iterate R1 R2 0 nil}
end

% Prueba
declare
Result = {Add [1 1 0 1 1 0] [0 1 0 1 1 1]}
% Debería mostrar [1 0 1 1 0 0 1]
{Browse Result}