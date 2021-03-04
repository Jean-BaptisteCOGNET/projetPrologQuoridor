:- dynamic mur/3.
:- retractall(mur(_,_)).

demarrer :- 
    nl,
    write('Bienvenue dans Quoridor ! '), nl,
    instructions.
    %jouer. %appel jouer

instructions :-
  nl,
  write('Inserer ici les regle du jeu.'), nl, 
  write('Inserer ici les regle du jeu.'), nl,nl,
  write('Pour pouvoir jouer, entrez les differentes commandes suivantes en respectant la syntax Prolog (pas de majuscule et avec un point a la fin de la commande).'), nl,
  write('Les differentes commandes du jeu sont :'), nl,
  write('demarrer.                -- pour lancer le jeu.'), nl,
  write('jouer.                   -- pour lancer une partie.'), nl,
  write('poseMur(Position,Sens).  -- pour poser un mur a la position voulu.'), nl,
  write('instructions.            -- revoir ce message.'), nl,
  write('abandonner.              -- quitter le niveau en cours.'), nl,
  write('halt.                    -- fermer prolog.'), nl,nl,
  write('La grille de jeu quant a elle est constituee des cases suivantes : '), nl,
  afficheGrilleJeu, %appel de l'affichage de la grille de jeu
  nl,nl.

jouer :- 
         write("ecrire ici "),nl,
         read(X). %récupération du niveau choisi par l'utilisateur


%création sur une grille de 4x4 pour tester. Sera fait sur 9x9 plus tard

case(11).   %déclaration de toutes les cases
case(12).
case(13).
case(14).
case(15).
case(21).
case(22).
case(23).
case(24).
case(25).
case(31).
case(32).
case(33).
case(34).
case(35).
case(41).
case(42).
case(43).
case(44).
case(45).
case(51).
case(52).
case(53).
case(54).
case(55).

grilleJeu(
    [11,12,13,14,15,
    21,22,23,24,25,
    31,32,33,34,35,
    41,42,43,44,45,
    51,52,53,54,55]).

afficheGrilleJeu :- grilleJeu(G), printGrid(G). %affichage de la grille de jeu

poseMur(Position,v) :- 
    \+mur(Position,v,_),                                    %on vérifie qu'il n'y ait pas déjà un mur
    \+coupeMur(Position, h),                                %on vérifie qu'on ne coupe pas un mur 
    Position2 is Position +10, \+mur(Position2,v,_),        %on vérifie qu'il n'y ait pas de mur en dessous  
    assert(mur(Position, v, debut)),
    Position2 is Position +10,
    assert(mur(Position2, v, fin)).

poseMur(Position,h) :- 
    \+mur(Position,h,_),                                    %on vérifie qu'il n'y ait pas déjà un mur
    \+coupeMur(Position, v),                                %on vérifie qu'on ne coupe pas un mur    
    Position2 is Position +1, \+mur(Position2,h,_),         %on vérifie qu'il n'y ait pas de mur à droite  
    assert(mur(Position, h, debut)),
    Position2 is Position +1,
    assert(mur(Position2, h, fin)).

coupeMur(Position, Sens) :-                                 %on vérifie qu'on ne coupe pas un mur  
    mur(Position, _, debut).










%%%% AFFICHAGE DU RESULTAT %%%%
printGrid(G) :- 
    printHSep(3),
    printGrid(G,1,1).
  
  printGrid(G,L,6) :- 
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
    write(' ').
  
  printVSep(_) :- write(',').
  
  
  printHSep(L) :- 
    nl, write(''), nl,
    write(' ').
  
  printHSep(_) :-
    nl, write('|').