declare
% Enlaza el módulo del navegador
[Browser] = {Module.link ["x-oz://system/Browser.ozf"]}

% Muestra 'Hola Mundo' en el navegador
{Browse 'Hola Mundo'}

% Muestra el resultado de 999*999 en el navegador
{Browse 999*999}

% Variables declarativas : siempre sera la misma no se puede reasignar
% Declaración de una variable
declare
X = 5
{Browse X*X} % Muestra el valor de X en el navegador

% Funciones
% Declaración de una función
declare
fun {Factorial N}
   if N==0 then 1
   else N*{Factorial N-1}
   end
end
{Browse Factorial} % Muestra la función en el navegador
{Browse {Factorial 100}} % Muestra el factorial de 5 en el navegador

% funcion combinatoria
declare
fun {Combinatoria N K}
   {Factorial N} div ({Factorial K} * {Factorial N-K})
end
{Browse {Combinatoria 10 5}} % Muestra la combinatoria de 10 y 5 en el navegador

% Listas y funciones de listas
% Declaración de una lista
declare
X = [1 2 3 4 5]
{Browse X} % Muestra la lista en el navegador

% Lista vacía
declare
X = nil
{Browse X} % Muestra la lista vacía en el navegador

% Cons | : Agrega un elemento a la lista
declare
H = 5
T = [6 7 8 9]
X = H|T
{Browse X} % Muestra la lista con el elemento 5 en el navegador

% lista con cola vacía
{Browse 5|6|7|8|nil} % Muestra la lista con el elemento 5 en el navegador

% Las listas se componen de una cabeza y una cola donde la cabeza es un elemento
% y la cola es otra lista

% Explorar y recorrer listas
List = [1 2 3 4 5]
% Con case se puede obtener la cabeza y la cola de una lista
case List of H|T then
   {Browse H} % Muestra la cabeza de la lista
   {Browse T} % Muestra la cola de la lista
end

% Muestra el primer elemento de la lista
{Browse {List.hd X}}