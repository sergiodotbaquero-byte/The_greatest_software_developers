grafo([
    arista(vancouver, edmonton, 16),
    arista(vancouver, calgary, 13),
    arista(edmonton, saskatoon, 12),
    arista(calgary, edmonton, 4),
    arista(calgary, regina, 14),
    arista(saskatoon, calgary, 9),
    arista(saskatoon, winnipeg, 20),
    arista(regina, saskatoon, 7),
    arista(regina, winnipeg, 4)
]).

pertenece(X, [X|_]).
pertenece(X, [_|Resto]) :- pertenece(X, Resto).

conexion(O, D, C) :-
    grafo(G),
    pertenece(arista(O, D, C), G).

ruta(O, D, Ruta) :- ruta(O, D, [O], Ruta).

ruta(O, D, _, [O, D]) :-
    conexion(O, D, _).
ruta(O, D, Visitadas, [O|Resto]) :-
    conexion(O, Z, _),
    \+ pertenece(Z, Visitadas),
    ruta(Z, D, [Z|Visitadas], Resto).

camino(O, D) :- ruta(O, D, _).

salidas(N, Lista) :- grafo(G), salidas(N, G, Lista).

salidas(_, [], []).
salidas(N, [arista(N, D, C)|Resto], [destino(D, C)|R]) :-
    salidas(N, Resto, R).
salidas(N, [arista(O, _, _)|Resto], R) :-
    O \= N,
    salidas(N, Resto, R).

entradas(N, Lista) :- grafo(G), entradas(N, G, Lista).

entradas(_, [], []).
entradas(N, [arista(O, N, C)|Resto], [origen(O, C)|R]) :-
    entradas(N, Resto, R).
entradas(N, [arista(_, D, _)|Resto], R) :-
    D \= N,
    entradas(N, Resto, R).

tiene_aristas(N) :- conexion(N, _, _).
tiene_aristas(N) :- conexion(_, N, _).

costo_por(X, Y, Z, Total) :-
    conexion(X, Y, C1),
    conexion(Y, Z, C2),
    Total is C1 + C2.

/*
?- camino(saskatoon, vancouver).         % false
?- camino(vancouver, saskatoon).         % true
?- camino(edmonton, calgary).            % true
?- ruta(edmonton, calgary, R).           % R = [edmonton, saskatoon, calgary]
?- salidas(regina, L).                   % L = [destino(saskatoon,7), destino(winnipeg,4)]
?- entradas(regina, L).                  % L = [origen(calgary,14)]
?- tiene_aristas(winnipeg).              % true
?- costo_por(vancouver, calgary, regina, T).   % T = 27
*/