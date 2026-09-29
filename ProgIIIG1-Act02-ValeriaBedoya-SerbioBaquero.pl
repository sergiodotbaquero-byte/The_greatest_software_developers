% HECHOS

estadounidense(west).

enemigo(corea_del_sur, estados_unidos).

misil(m1).
misil(m2).

posee(corea_del_sur, m1).
posee(corea_del_sur, m2).

vendio(west, m1, corea_del_sur).
vendio(west, m2, corea_del_sur).


% REGLA

criminal(X) :-
    estadounidense(X),
    vendio(X, M, N),
    misil(M),
    enemigo(N, estados_unidos).



/*
CONSULTAS

?- criminal(west).
?- criminal(X).
?- criminal(corea_del_sur).
?- estadounidense(X).
?- misil(X).
?- posee(corea_del_sur, X).
?- vendio(west, M, N).
?- enemigo(X, estados_unidos).
*/