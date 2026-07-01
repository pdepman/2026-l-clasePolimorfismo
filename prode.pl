% Base de Conocimiento
% hizoGolContra(Jugador, EquipoContrario).
hizoGolContra(messi, argelia).
hizoGolContra(messi, argelia).
hizoGolContra(messi, argelia).
hizoGolContra(haaland, senegal).
hizoGolContra(haaland, senegal).
hizoGolContra(pedersen, senegal).
hizoGolContra(sar, noruega).
hizoGolContra(sar, noruega).
hizoGolContra(gakpo, marruecos).
hizoGolContra(diop, holanda).

% equipoDe(Jugador, Equipo).
equipoDe(messi, argentina).
equipoDe(haaland, noruega). % TUM TUM… 🥁RO!! 🚣‍♂️
equipoDe(pedersen, noruega).
equipoDe(sar, senegal).
equipoDe(gakpo, holanda).
equipoDe(diop, marruecos).

% campeonMundial(Equipo).
campeonMundial(marruecos).
/*
    "Lo dije en el '75 cuando fuimos a jugar la 
    Copa Mohammed a Marruecos. Dije acá está el 
    futuro del fútbol. No está en Europa, en 
    Sudamérica" -- el Doctor Bilardo - Sábado Bus, año 2000
*/

% totalGoles/2
totalGoles(Jugador, CantDeGoles) :-
    jugador(Jugador),
    findall(Eq, hizoGolContra(Jugador, Eq), Eqs),
    length(Eqs, CantDeGoles).

jugador(Jugador) :-
    equipoDe(Jugador, _).

% goleadorDelMundial/1
goleadorDelMundial(LaCabra) :-
    totalGoles(LaCabra, CantLaCabra),
    forall(totalGoles(_, CantOtro), CantLaCabra >= CantOtro).

% hizoGolEnPartido/3
hizoGolEnPartido(Jugador, SuEq, EqRival) :-
    equipoDe(Jugador, SuEq),
    hizoGolContra(Jugador, EqRival).

equipo(E):-
    distinct(E, equipoRepetido(E)).

equipoRepetido(Eq) :-
    equipoDe(_, Eq).

equipoRepetido(Eq) :-
    hizoGolContra(_, Eq).

% cantGoles/3
cantGoles(Eq, EqRiv, CantGoles) :-
    equipo(Eq),
    equipo(EqRiv),
    findall(Jugador, hizoGolEnPartido(Jugador, Eq, EqRiv), Jugadores),
    length(Jugadores, CantGoles).

% resultado/4
resultado(Eq, EqRival, GolesEq, GolesRival) :-
    cantGoles(Eq, EqRival, GolesEq),
    cantGoles(EqRival, Eq, GolesRival).

% puntajeTotal/2
puntajeTotal(Persona, PuntajeTotal) :-
    persona(Persona),
    findall(Puntos, (pronostico(Persona, Pronostico),
        puntosPronosticos(Pronostico, Puntos)), 
        ListaDePuntos),
    sum_list(ListaDePuntos, PuntajeTotal).

% pronostico(Persona, Pronostico).
% pronostico(Persona, campeon(Eq)).
pronostico(naza, campeon(francia)).
% pronostico(Persona, balonDeOro(Jugador)).
pronostico(naza, balonDeOro(mbappe)).
% pronostico(Persona, partido(Eq1, Eq2, GolesEq1, GolesEq2)).
pronostico(naza, partido(argentina, argelia, 3, 1)).
pronostico(naza, partido(holanda, marruecos, 2, 1)).

pronostico(lu, partido(argentina, argelia, 3, 0)).
pronostico(lu, campeon(argentina)).

pronostico(dario, balonDeOro(elMosquitoDembele)).
pronostico(dario, partido(noruega, senegal, 3, 1)).

persona(Persona) :-
    distinct(Persona, pronostico(Persona, _)).

% puntosPronosticos(Pronostico, Puntos).
puntosPronosticos(campeon(Campeon), 12) :-
    campeonMundial(Campeon).

puntosPronosticos(balonDeOro(Pichichi), 3) :-
    goleadorDelMundial(Pichichi).

puntosPronosticos(partido(Eq, EqRival, Goles, GolesRival), 6) :-
    resultado(Eq, EqRival, Goles, GolesRival).

puntosPronosticos(partido(Eq, EqRival, Goles, GolesRival), 3) :-
    tendencia(Goles, GolesRival, Tendencia),
    resultado(Eq, EqRival, Resultado, ResultadoRival),
    tendencia(Resultado, ResultadoRival, Tendencia).

tendencia(Goles, GolesRival, gana) :-
    Goles > GolesRival.

tendencia(Goles, Goles, empata).

tendencia(Goles, GolesRival, pierde) :-
    Goles < GolesRival.

