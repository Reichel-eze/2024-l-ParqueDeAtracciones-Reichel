% Parque de Atracciones

persona(nina, joven, 22, 1.60).
persona(marcos, nino, 8, 1.32).
persona(osvaldo, adolescente, 13, 1.29).

%atraccion(trenFantasma(12)).
%atraccion(montanaRusa(1.30)).
%atraccion(maquinaTiquetera).
%atraccion(toboganGigante(1.50)).
%atraccion(rioLento).
%atraccion(piscinaDeOlas(5)).

atraccion(trenFantasma, edad(12), altura(0)).    % Tren Fantasma -> Exige que la persona sea mayor o igual a 12 años (ES DECIR, DA IGUAL LA ALTURA)
atraccion(montanaRusa, edad(0), altura(1.30)).
atraccion(maquinaTiquetera, edad(0), altura(0)).
atraccion(toboganGigante, edad(0), altura(1.50)).
atraccion(rioLento, edad(0), altura(0)).
atraccion(piscinaDeOlas, edad(5), altura(0)).

tiene(parqueDeLaCosta, trenFantasma).
tiene(parqueDeLaCosta, montanaRusa).
tiene(parqueDeLaCosta, maquinaTiquetera).

tiene(parqueAcuatico, toboganGigante).
tiene(parqueAcuatico, rioLento).
tiene(parqueAcuatico, piscinaDeOlas).

% 1) puedeSubir/2, relaciona una persona con una atracción, si 
% la persona puede subir a la atracción.

puedeSubir(Persona, Atraccion) :-
    persona(Persona,_, EdadPersona, AlturaPersona),
    atraccion(Atraccion, edad(EdadMinima), altura(AlturaMinima)),
    EdadPersona >= EdadMinima,
    AlturaPersona >= AlturaMinima.

%cumpleRequisito(trenFantasma(12), persona(_, _, Edad, _)) :- Edad >= 12.
%cumpleRequisito(montanaRusa(1.30), persona(_,_,_,Altura)) :- Altura >= 1.30.
%cumpleRequisito(maquinaTiquetera, _).
%cumpleRequisito(toboganGigante(1.50), persona(_,_,_,Altura)) :- Altura >= 1.50.
%cumpleRequisito(rioLento,_).
%cumpleRequisito(piscinaDeOlas(5), persona(_, _, Edad, _)) :- Edad >= 5.

%puedeSubirV2(Persona, Atraccion) :-
%    persona(Persona, _, _, _),
%    tieneRequsito(Atraccion, _),
%   cumpleRequisitoV2(Atraccion, Persona).

%cumpleRequisitoV2(_, )

% 2) esParaElle/2, relaciona un parque con una persona, si la persona puede subir a todos los juegos del parque

esParaElle(Persona, Parque) :-
    persona(Persona,_,_,_),
    tiene(Parque,_),
    forall(tiene(Parque,Atraccion), puedeSubir(Persona, Atraccion)). % para toda atraccion que tenga el parque, la persona se puede subir a dicha atraccion  
    
% 3) malaIdea/2, relaciona un grupo etario (adolescente/niño/joven/adulto/etc) con un parque, y nos dice que "es mala idea" que las personas de ese 
% grupo vayan juntas a ese parque, si es que no hay ningún juego al que puedan subir todos

% --> si no existe ningún juego al que puedan subir todos, entonces, not(forall) --> hay por lo menos un jugador que no puede subir

malaIdea(GrupoEtario, Parque) :-
    grupoEtario(GrupoEtario),
    tiene(Parque, _),
    not(forall(persona(Persona,GrupoEtario,_,_), (tiene(Parque,Atraccion), puedeSubir(Persona, Atraccion)))).

malaIdeaV2(GrupoEtario, Parque) :-
    persona(Persona, GrupoEtario, _, _),
    tiene(Parque, _),
    not((tiene(Parque,Atraccion), puedeSubir(Persona, Atraccion))).

grupoEtario(Grupo) :- persona(_, Grupo, _, _).
