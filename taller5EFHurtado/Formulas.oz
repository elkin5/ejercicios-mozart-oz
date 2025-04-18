declare

% Clase Variable
class Variable
   attr valor
   meth init(V)
      valor := V
   end
   meth asg(X)
      valor := X
   end
   meth evaluar($)
      @valor
   end
end

% Clase Constante
class Constante
   attr valor
   meth init(V)
      valor := V
   end
   meth evaluar($)
      @valor
   end
end

% Clase Suma
class Suma
   attr izq der
   meth init(Izq Der)
      izq := Izq
      der := Der
   end
   meth evaluar($)
      {@izq evaluar($)} + {@der evaluar($)}
   end
end

% Clase Diferencia
class Diferencia
   attr izq der
   meth init(Izq Der)
      izq := Izq
      der := Der
   end
   meth evaluar($)
      {@izq evaluar($)} - {@der evaluar($)}
   end
end

% Clase Producto
class Producto
   attr izq der
   meth init(Izq Der)
      izq := Izq
      der := Der
   end
   meth evaluar($)
      {@izq evaluar($)} * {@der evaluar($)}
   end
end

% Obtener la potencia de un número
fun {PowI X N}
    if N == 0 then 
        1
    else 
        X * {PowI X N-1}
    end
end

% Clase Potencia
class Potencia
   attr base exponente
   meth init(Base Expo)
      base := Base
      exponente := Expo
   end
   meth evaluar($)
      {PowI {@base evaluar($)} @exponente}
   end
end

% Tests
declare 
% 3x^2 - xy + y^3
VarX = {New Variable init(0)}
VarY = {New Variable init(0)}
ExprX2 = {New Potencia init(VarX 2)}
Expr3 = {New Constante init(3)}
Expr3X2 = {New Producto init(Expr3 ExprX2)}
ExprXY = {New Producto init(VarX VarY)}
Expr3X2mXY = {New Diferencia init(Expr3X2 ExprXY)}
ExprY3 = {New Potencia init(VarY 3)}

Formula = {New Suma init(Expr3X2mXY ExprY3)}

%% Asignamos valores
{VarX asg(7)}
{VarY asg(23)}
{Browse {Formula evaluar($)}}   %% Resultado para x=7, y=23

{VarX asg(5)}
{VarY asg(8)}
{Browse {Formula evaluar($)}}   %% Resultado para x=5, y=8