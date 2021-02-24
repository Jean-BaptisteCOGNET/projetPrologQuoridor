demarrer :- 
    nl,
    write('Bienvenue dans Rush Hour ! '),
    afficheGrilleJeu. %appel jouer

%création sur une grille de 4x4 pour tester. Sera fait sur 9x9 plus tard

case(11).   %déclaration de toutes les cases
case(12).
case(13).
case(14).
case(21).
case(22).
case(23).
case(24).
case(31).
case(32).
case(33).
case(34).
case(41).
case(42).
case(43).
case(44).

grilleJeu(
    [11,12,13,14,
    21,22,23,24,
    31,32,33,34,
    41,42,43,44]).

afficheGrilleJeu :- grilleJeu(G), printGrid(G). %affichage de la grille de jeu



















%%%% AFFICHAGE DU RESULTAT %%%%
printGrid(G) :- 
    printHSep(3),
    printGrid(G,1,1).
  
  printGrid(G,L,5) :- 
    !,
    printHSep(L),
    L1 is L + 1,
    printGrid(G,L1,1).
  
  printGrid([],_,_) :- !.
  
  
  printGrid([T|Q],L,C) :- 
    write(T),
    printVSep(C),
    C1 is C + 1,
    printGrid(Q,L,C1).
  
  
  printVSep(C) :- 
    write('|').
  
  printVSep(_) :- write(',').
  
  
  printHSep(L) :- 
    nl, write('-------------'), nl,
    write('|').
  
  printHSep(_) :-
    nl, write('|').
