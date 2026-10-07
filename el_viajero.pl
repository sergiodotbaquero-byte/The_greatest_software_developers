
viaje(vancouver, edmonton, 16).
viaje(vancouver, calgary, 13).

viaje(edmonton, saskatoon, 12).

viaje(calgary, edmonton, 4).
viaje(calgary, regina, 14).

viaje(saskatoon, calgary, 9).
viaje(saskatoon, winnipeg, 20).

viaje(regina, saskatoon, 7).
viaje(regina, winnipeg, 4).

camino(X, Y) :- camino(X, Y, [X]).

camino(X, Y, _) :- viaje(X, Y, _).
camino(X, Y, Visitados) :-
    viaje(X, Z, _),
    \+ member(Z, Visitados),
    camino(Z, Y, [Z|Visitados]).

tiene_aristas(N) :- viaje(N, _, _).
tiene_aristas(N) :- viaje(_, N, _).

costo_por(X, Y, Z, Total) :-
    viaje(X, Y, C1),
    viaje(Y, Z, C2),
    Total is C1 + C2.

/*consultas
camino(saskatoon, vancouver).
camino(vancouver, saskatoon).
camino(edmonton, calgary).
viaje(regina, A, B).
viaje(A, regina, B).
tiene_aristas(winnipeg).
tiene_aristas(vancouver).
costo_por(vancouver, calgary, regina, T).
costo_por(vancouver, edmonton, saskatoon, T).
*/
