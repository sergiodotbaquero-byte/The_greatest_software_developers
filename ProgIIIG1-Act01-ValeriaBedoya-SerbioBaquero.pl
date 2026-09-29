% HECHOS

padre_de(abraham, herbert).
madre_de(mona, herbert).

padre_de(abraham, homero).
madre_de(mona, homero).

padre_de(clancy, patty).
madre_de(jacqueline, patty).

padre_de(clancy, selma).
madre_de(jacqueline, selma).

padre_de(homero, bart).
madre_de(marge, bart).

padre_de(homero, lisa).
madre_de(marge, lisa).

padre_de(homero, maggie).
madre_de(marge, maggie).

madre_de(selma, ling).


% REGLAS

% ABUELO
abuelo_de(Abuelo, Nieto) :-
    padre_de(Abuelo, Padre),
    (padre_de(Padre, Nieto);
     madre_de(Padre, Nieto)).


% ABUELA
abuela_de(Abuela, Nieto) :-
    madre_de(Abuela, Padre),
    (padre_de(Padre, Nieto);
     madre_de(Padre, Nieto)).


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
    (padre_de(Padre, Sobrino);
     madre_de(Padre, Sobrino)).


% TIA
tia_de(Tia, Sobrino) :-
    hermana_de(Tia, Padre),
    (padre_de(Padre, Sobrino);
     madre_de(Padre, Sobrino)).


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


% CONSULTAS

% ?- padre_de(abraham, X).
% ?- abuelo_de(abraham, bart).
% ?- hermano_de(bart, X).
% ?- tio_de(herbert, X).