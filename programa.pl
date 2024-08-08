% Parque de Atracciones

persona(nina, joven, 22, 1.60).
persona(marcos, nino, 8, 1.32).
persona(osvaldo, adolescente, 13, 1.29).

atraccion(trenFantasma(12)).
atraccion(montanaRusa(1.30)).
atraccion(maquinaTiquetera).
atraccion(toboganGigante(1.50)).
atraccion(rioLento).
atraccion(piscinaDeOlas(5)).

puedeSubir(Persona, Atraccion) :-
    persona(Persona,_,_,_),
    cumpleRequisito(Atraccion, Persona).

cumpleRequisito(trenFantasma(12), persona(_, _, Edad, _)) :- Edad >= 12.
cumpleRequisito(montanaRusa(1.30), persona(_,_,_,Altura)) :- Altura >= 1.30.
cumpleRequisito(maquinaTiquetera, _).
cumpleRequisito(toboganGigante(1.50), persona(_,_,_,Altura)) :- Altura >= 1.50.
cumpleRequisito(rioLento,_).
cumpleRequisito(piscinaDeOlas(5), persona(_, _, Edad, _)) :- Edad >= 5.

