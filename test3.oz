declare
A = {NewCell 0}
B = {NewCell 0}
T1 = @A
T2 = @B
{Show A == B}  % a)
{Show T1 == T2}  % b)
{Show T1 = T2}  % c)
A := @B
{Show A == B}  % d)