% persona(Nombre, Genero, Padre, Madre)
personas([
    persona(abraham, masculino, ninguno, ninguno),
    persona(mona, femenino, ninguno, ninguno),
    persona(herbert, masculino, abraham, mona),
    persona(homero, masculino, abraham, mona),
    persona(clancy, masculino, ninguno, ninguno),
    persona(jacqueline, femenino, ninguno, ninguno),
    persona(patty, femenino, clancy, jacqueline),
    persona(selma, femenino, clancy, jacqueline),
    persona(marge, femenino, ninguno, ninguno),
    persona(bart, masculino, homero, marge),
    persona(lisa, femenino, homero, marge),
    persona(maggie, femenino, homero, marge),
    persona(ling, femenino, ninguno, selma)
]).

% REGLAS PARA OBTENER LOS PADRES
padre_de(Padre, Hijo) :-
    personas(Lista),
    member(persona(Hijo, _, Padre, _), Lista),
    Padre \= ninguno.

madre_de(Madre, Hijo) :-
    personas(Lista),
    member(persona(Hijo, _, _, Madre), Lista),
    Madre \= ninguno.

% ABUELO
abuelo_de(Abuelo, Nieto) :-
    padre_de(Abuelo, Padre),
    (padre_de(Padre, Nieto) ; madre_de(Padre, Nieto)).

% ABUELA
abuela_de(Abuela, Nieto) :-
    madre_de(Abuela, Padre),
    (padre_de(Padre, Nieto) ; madre_de(Padre, Nieto)).

% HERMANO
hermano_de(Hermano, Persona) :-
    padre_de(Padre, Hermano),
    padre_de(Padre, Persona),
    Hermano \= Persona.
hermano_de(Hermano, Persona) :-
    madre_de(Madre, Hermano),
    madre_de(Madre, Persona),
    Hermano \= Persona.

% HERMANA
hermana_de(Hermana, Persona) :-
    padre_de(Padre, Hermana),
    padre_de(Padre, Persona),
    Hermana \= Persona.
hermana_de(Hermana, Persona) :-
    madre_de(Madre, Hermana),
    madre_de(Madre, Persona),
    Hermana \= Persona.

% TIO
tio_de(Tio, Sobrino) :-
    hermano_de(Tio, Padre),
    (padre_de(Padre, Sobrino) ; madre_de(Padre, Sobrino)).

% TIA
tia_de(Tia, Sobrino) :-
    hermana_de(Tia, Padre),
    (padre_de(Padre, Sobrino) ; madre_de(Padre, Sobrino)).

% PRIMO
primo_de(Primo, Persona) :-
    padre_de(PadrePrimo, Primo),
    padre_de(PadrePersona, Persona),
    hermano_de(PadrePrimo, PadrePersona),
    Primo \= Persona.
primo_de(Primo, Persona) :-
    madre_de(MadrePrimo, Primo),
    madre_de(MadrePersona, Persona),
    hermana_de(MadrePrimo, MadrePersona),
    Primo \= Persona.

% PRIMA
prima_de(Prima, Persona) :-
    padre_de(PadrePrima, Prima),
    padre_de(PadrePersona, Persona),
    hermano_de(PadrePrima, PadrePersona),
    Prima \= Persona.
prima_de(Prima, Persona) :-
    madre_de(MadrePrima, Prima),
    madre_de(MadrePersona, Persona),
    hermana_de(MadrePrima, MadrePersona),
    Prima \= Persona.

/* CONSULTAS
?- padre_de(abraham, X).
?- madre_de(marge, X).
?- abuelo_de(abraham, bart).
?- abuelo_de(X, bart).
?- abuela_de(mona, X).
?- hermano_de(bart, X).
?- hermana_de(lisa, X).
?- tio_de(herbert, X).
?- tia_de(patty, X).
?- primo_de(bart, X).
?- prima_de(ling, X).
*/