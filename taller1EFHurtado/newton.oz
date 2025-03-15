declare
fun {Derivar F A}
   % {Show 'Derivando ' | F}
   if F == A then 1.0
   else
      case F of
         s(X Y) then s({Derivar X A} {Derivar Y A})
         [] r(X Y) then r({Derivar X A} {Derivar Y A})
         [] m(X Y) then s(m({Derivar X A} Y) m(X {Derivar Y A}))
         [] d(X Y) then 
            d(s(m({Derivar X A} Y) r(m(X {Derivar Y A}))) m(Y Y))
         [] e(X Y) then
            m(e(X Y) s(m(Y d({Derivar X A} X)) m({Derivar Y A} l(X))))
         [] l(X) then d({Derivar X A} X)
         else 0.0
      end
   end
end

declare
fun {Evaluar F A V}
   % {Show 'Evaluando ' | F}
   if F == A then V
   else
      case F of
      X andthen {IsNumber X} then X
      [] s(X Y) then {Evaluar X A V} + {Evaluar Y A V}  
      [] r(X Y) then {Evaluar X A V} - {Evaluar Y A V}
      [] m(X Y) then {Evaluar X A V} * {Evaluar Y A V}
      [] d(X Y) then {Evaluar X A V} / {Evaluar Y A V}
      [] e(X Y) then {Number.pow {Evaluar X A V} {Evaluar Y A V}}
      [] l(X) then {Float.'log' {Evaluar X A V}}
      else raise error(expresion_no_soportada(F)) end
      end
   end
end

declare
fun {Limpiar F}
   case F of
      s(X Y) then
         Xc = {Limpiar X}
         Yc = {Limpiar Y}
      in
         if {IsNumber Xc} andthen {IsNumber Yc} then
            Xc + Yc
         else
            if Xc == 0.0 then Yc
            elseif Yc == 0.0 then Xc
            else s(Xc Yc)
            end
         end
   [] r(X Y) then
         Xc = {Limpiar X}
         Yc = {Limpiar Y}
      in
         if {IsNumber Xc} andthen {IsNumber Yc} then
            Xc - Yc
         else
            if Yc == 0.0 then Xc
            else r(Xc Yc)
            end
         end
   [] m(X Y) then
         Xc = {Limpiar X}
         Yc = {Limpiar Y}
      in
         if {IsNumber Xc} andthen {IsNumber Yc} then
            Xc * Yc
         else
            if Xc == 0.0 orelse Yc == 0.0 then 0.0
            elseif Xc == 1.0 then Yc
            elseif Yc == 1.0 then Xc
            else m(Xc Yc)
            end
         end
   [] d(X Y) then
         Xc = {Limpiar X}
         Yc = {Limpiar Y}
      in
         if {IsNumber Xc} andthen {IsNumber Yc} then
            Xc / Yc
         else
            if Yc == 1.0 then Xc
            elseif Xc == 0.0 then 0.0
            else d(Xc Yc)
            end
         end
   [] e(X Y) then
         Xc = {Limpiar X}
         Yc = {Limpiar Y}
      in
         if {IsNumber Xc} andthen {IsNumber Yc} then
            {Number.pow Xc Yc}
         else
            if Yc == 0.0 then 1.0
            elseif Xc == 0.0 then 0.0
            else e(Xc Yc)
            end
         end
   [] l(X) then
         Xc = {Limpiar X}
      in
         if {IsNumber Xc} then
            {Float.'log' Xc}
         else
            l(Xc)
         end
   [] X then
         if {IsNumber X} then X else F end
   else
      raise error(unsupported_expression:F) end
   end
end

declare
fun {Raiz F X0 BuenaAprox}
   % Encuentra la variable única en la fórmula F
   fun {FindVariables F}
      if {IsAtom F} then
         [F]
      elseif {IsFloat F} then
         nil
      else
         case F
         of s(U V) then {Append {FindVariables U} {FindVariables V}}
         [] r(U V) then {Append {FindVariables U} {FindVariables V}}
         [] m(U V) then {Append {FindVariables U} {FindVariables V}}
         [] d(U V) then {Append {FindVariables U} {FindVariables V}}
         [] e(U V) then {Append {FindVariables U} {FindVariables V}}
         [] l(U) then {FindVariables U}
         else nil
         end
      end
   end

   Variables = {FindVariables F}
   {Show 'Variables ' | Variables}
   A = case Variables of [X] then X
        else raise 'Fórmula con múltiples variables o sin variables' end
        end

   FDerivada = {Derivar F A}
   {Show 'Derivada ' | FDerivada}

   FDerivadaLimpiada = {Limpiar FDerivada}
   {Show 'Derivada limpiada ' | FDerivadaLimpiada}
   
   % Iteración de Newton-Raphson
   fun {Iter Xn}
      FValor = {Evaluar F A Xn}
      FDerivadaValor = {Evaluar FDerivadaLimpiada A Xn}
      Xn1 = Xn - (FValor / FDerivadaValor)
   in
      if {BuenaAprox F Xn1} then Xn1
      else {Iter Xn1}
      end
   end

in
   {Iter X0}
end

declare
fun {BuenaAprox F V}
   {Abs {Evaluar F x V}} < 0.0001
end

% --- pruebas Raiz ---
{Show '%%%%%%%% PRUEBAS RAIZ %%%%%%%'}
% Prueba 1: Raíz de x² - 4
declare
F = r(e(x 2.0) 4.0)
% Valor inicial de la raíz cerca de 2.0 para pocas iteraciones
X0 = 2.1
RaizCalculada = {Raiz F X0 BuenaAprox}
% Debe ser ≈ 2.0
{Show 'Raíz de x² - 4: ' | RaizCalculada}


% % --- pruebas Derivar ---
% {Show '%%%%%%%% PRUEBAS DERIVAR %%%%%%%'}
% % Prueba 1: Derivada de s(m(3.0 x) 5.0) → s(0.0 s(m(0.0 x) m(3.0 1.0)))
% declare
% F1 = s(k m(3.0 x))
% D1 = {Derivar F1 x}
% {Show D1} 

% % --- pruebas Evaluar ---
% {Show '%%%%%%%% PRUEBAS EVALUAR %%%%%%%'}

% % Prueba 1: Fórmula s(m(3.0 x) 5.0) (3x + 5), evaluada en x=2.0 → 3*2 +5 =11.0
% declare
% F1 = s(m(3.0 x) 5.0)
% Resultado1 = {Evaluar F1 x 2.0}
% {Show Resultado1}

% % % Prueba 2: Fórmula e(x 2.0) (x²), evaluada en x=4.0 → 16.0
% declare
% F2 = e(x 2.0)
% Resultado2 = {Evaluar F2 x 4.0}
% {Show Resultado2}

% % % Prueba 3: Fórmula l(e(x 2.0)) (ln(x²)), evaluada en x=3.0 → ln(9) ≈2.1972245773
% declare
% F3 = l(e(x 2.0))
% Resultado3 = {Evaluar F3 x 3.0}
% {Show Resultado3}

% % % Prueba 4: Fórmula r(d(s(x 5.0) 2.0) m(3.0 x)) → ((x +5)/2 -3x), evaluada en x=1.0 → (6/2 -3) =3 -3=0.0
% declare
% F4 = r(d(s(x 5.0) 2.0) m(3.0 x))
% Resultado4 = {Evaluar F4 x 1.0}
% {Show Resultado4}

% % ---- pruebas Limpiar ----
% {Show '%%%%%%%% PRUEBAS LIMPIAR %%%%%%%'}
% % Prueba 1: Simplificar s(0.0 s(m(0.0 x) m(3.0 1.0))) → 3.0
% declare
% F1 = s(0.0 s(m(0.0 x) m(3.0 1.0)))
% Resultado1 = {Limpiar F1}
% {Show Resultado1}

% % Prueba 2: Simplificar m(3.0 m(1.0 x)) → m(3.0 x)
% declare
% F2 = m(3.0 m(1.0 x))
% Resultado2 = {Limpiar F2}
% {Show Resultado2}

% % Prueba 3: Simplificar s(m(2.0 0.0) r(x 0.0)) → x
% declare
% F3 = s(m(2.0 0.0) r(x 0.0))
% Resultado3 = {Limpiar F3}
% {Show Resultado3}

% % Prueba 4: Evaluar exponente constante e(2.0 3.0) → 8.0
% declare
% F4 = e(2.0 3.0)
% Resultado4 = {Limpiar F4}
% {Show Resultado4}

% % Prueba 5: Simplificar logaritmo l(e(7.0 1.0)) ≈1.9459
% declare
% F5 = l(e(7.0 1.0))
% Resultado5 = {Limpiar F5}
% {Show Resultado5}

% % ---- pruebas BuenaAprox ----
% {Show '%%%%%%%% PRUEBAS BUENA APROXIMACION %%%%%%%'}
% % Prueba 1: BuenaAproximacion de 0.0001 para evaluar s(m(3.0 x) 5.0) en x=2.0
% declare
% F1 = s(m(3.0 x) 5.0)
% Resultado6 = {BuenaAprox F1 2.0}
% {Show Resultado6}