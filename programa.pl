% Parque de Atracciones

persona(nina, joven, 22, 1.60).
persona(marcos, ninio, 8, 1.32).
persona(osvaldo, adolescente, 13, 1.29).
persona(ana, adolescente, 13, 1.6).

% Estos ejemplos son arbitrarios, podríamos ampliar los límites, 
% agregar otros grupos etarios 
% o incluso solapar los intervalos porque no es necesario que sean excluyentes
grupoEtario(ninio,0,12).
grupoEtario(adolescente,13,18). 
grupoEtario(joven,19,30).
grupoEtario(adulto,30,100).

perteneceAGrupoEtario(Persona, GrupoEtario) :-
    persona(Persona, GrupoEtario, Edad, _),
    grupoEtario(GrupoEtario, E1, E2),
    between(E1, E2, Edad).
    
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

requisito(trenFantasma, edad(12)).
requisito(montanaRusa, altura(1.30)).
requisito(toboganGigante, altura(1.50)).
requisito(piscinaDeOlas, edad(5)).
% los parques de atracciones que no tienen requesitos no se ponen!!

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

puedeSubirV2(Persona, Atraccion) :-     % PARA LAS ATRACCIONES QUE TIENEN REQUISITOS
    persona(Persona, _, _, _),  % existe la persona
    requisito(Atraccion, Requisito),    % existe la atraccion con requisitos
    cumpleRequisito(Requisito, Persona).

puedeSubirV2(Persona, Atraccion) :-    % PARA LAS ATRACCIONES QUE NO TIENEN REQUISITOS
    persona(Persona, _, _, _),
    tiene(_, Atraccion),            % existe un Parque que tiene a la Atraccion
    not(requisito(Atraccion, _)).   % PERO la atraccion NO tiene requisitos

%Asumiendo que una atracción puede tener varios requisitos, la misma regla ya considera cuando no tiene requisitos

puedeSubirV2(Persona, Atraccion) :-     
    persona(Persona, _, _, _),
    tiene(_, Atraccion),
    forall(requisito(Atraccion, Requisito), cumpleRequisito(Requisito, Persona)).
    % PARA TODO requesito de la atraccion, la persona cumple los requisitos!!

cumpleRequisito(edad(EdadMinima), Persona) :-
    persona(Persona, _, Edad, _),
    EdadMinima =< Edad.

cumpleRequisito(altura(AlturaMinima), Persona) :-
    persona(Persona, _, _, Altura),
    AlturaMinima =< Altura.

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

% --> si no existe ningún juego al que puedan subir todos, entonces, not(forall) --> NO EXISTE ALGUNA ATRACCION

malaIdea(GrupoEtario, Parque) :-
    grupoEtario(GrupoEtario, _, _),
    tiene(Parque, _),
    not(hayUnaAtraccionParaTodes(GrupoEtario, Parque)).     % NO EXISTE UNA ATRACCION PARA TODES!!

hayUnaAtraccionParaTodes(Grupo, Parque) :-
    tiene(Parque, Atraccion),
    forall(perteneceAGrupoEtario(Persona, Grupo), puedeSubirV2(Persona, Atraccion)).
    % PARA TODOS LAS PERSONAS QUE FORMAN PARTEN DEL GRUPO, las mismas pueden subir a la atraccion del parque 
        
% ----------- PROGRAMAS --------------------

% 1) programaLogico/1, me dice si un programa es "bueno", es decir, todos los juegos están en el mismo parque y no hay juegos repetidos

% Un programa es una lista ordenada de atracciones, que tienen que estar todas en el mismo parque
% Obviamente el programa no tiene por qué incluir todos los juegos del parque, es una selección ordenada.

parque(parqueDeLaCosta, [trenFantasma, montanaRusa, maquinaTiquetera]).
parque(parqueAcuatico, [toboganGigante, rioLento, piscinaDeOlas]).

programaLogico(Programa) :-
    estanEnElMismoParque(Programa),
    sinRepetir(Programa).

estanEnElMismoParque(Programa) :-
    tiene(Parque, _),
    forall(member(Atraccion, Programa), tiene(Parque, Atraccion)).

estanEnElMismoParqueV2(Programa) :-
    parque(_, Atracciones),
    forall(member(Atraccion, Programa), member(Atraccion, Atracciones)).

sinRepetir([]).
sinRepetir([_]).
sinRepetir([X|Lista]) :-
    not(member(X, Lista)),
    sinRepetir(Lista).
    
% 2) hastaAca/3, relaciona a una persona P y un programa Q, con el subprograma S que se compone de las atracciones iniciales 
% de Q hasta la primera a la que P no puede subir (excluida obviamente).
% Por ejemplo, si el programa tiene 5 atracciones y P no puede subir a la tercera, pero sí a las dos primeras, el subprograma 
% S deberá incluir a esas dos primeras atracciones.

%hastaAca(Persona, Programa, Subprograma) :-

hastaAca(_, [], []).
hastaAca(P, [X|_], []) :- not(puedeSubirV2(P,X)). % LA SEGUNDA LISTA VA A ESTAR VACIA, SI YA LA PRIMERA ATRACCION DE LA PRIMERA LISTA LA PERSONA NO PUEDE SUBIR
hastaAca(P, [X|XS], [X|YS]) :- puedeSubirV2(P,X), hastaAca(P, XS, YS).

% ----------- PASAPORTES --------------------

% juegoComun(Atraccion, Costo).
juegoComun(trenFantasma, 5).
juegoComun(maquinaTiquetera, 2).
juegoComun(rioLento, 3).
juegoComun(piscinaOlas, 4).

juegoPremium(montaniaRusa).
juegoPremium(toboganGigante).

% Pasaportes
tienePasaporte(nina, premium).
tienePasaporte(marcos, basico(10)).
tienePasaporte(osvaldo, flex(15, montaniaRusa)).
tienePasaporte(ana, basico(14)).

puedeSubirPasaporte(Persona, Atraccion) :-
    puedeSubirV2(Persona, Atraccion),
    tienePasaporte(Persona, Pasaporte),
    cumpleRequisitoPasaporte(Pasaporte, Atraccion).

cumpleRequisitoPasaporte(basico(Creditos), Atraccion) :-
    juegoComun(Atraccion, Costo),
    Creditos >= Costo.

cumpleRequisitoPasaporte(flex(Creditos, Atraccion), Atraccion) :-  
    juegoPremium(Atraccion).

cumpleRequisitoPasaporte(flex(Creditos, _), Atraccion) :- 
    cumpleRequisitoPasaporte(basico(Creditos), Atraccion).

cumpleRequisitoPasaporte(premium, _).


