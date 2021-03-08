:- dynamic mur/3, 
joueur/1,                     %determine la personne qui doit jouer
compteurJ1/1, compteurJ2/1.   %Contient le NbMur restant par joueur
%score/1, compteur/1,  nbtour/1.
:- retractall(mur(_,_)).

%initialisation des valeurs
compteurJ1(1).
compteurJ2(1).
joueur(1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           FONCTIONS PRINCIPALES                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
demarrer :- 
    nl,
    write('Bienvenue dans Quoridor ! '), nl,
    instructions,
    jouer. %appel jouer

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
  joueur(X),X=1,
  write('Joueur 1'), nl,
  write('Que voulez vous faire ? Tapez m. pour poser un mur ou d. pour vous deplacer'),nl,
  read(Action),
  retractall(joueur(_)),
  assert(joueur(2)),
  tourJoueur(1,Action).

jouer :-
  joueur(X),X=2,
  write('Joueur 2'), nl,
  write('Que voulez vous faire ? Tapez m. pour poser un mur ou d. pour vous deplacer'),nl,
  read(Action),
  retractall(joueur(_)),
  assert(joueur(1)),
  tourJoueur(2,Action).

tourJoueur(1,m) :-                          %vérifie si il reste des murs à poser
  compteurJ1(NbMurRestant), NbMurRestant==0,
  write('plus de mur'),
  deplacer.

tourJoueur(1,m) :- 
  poserMur(1), 
  compteur(compteurJ1).

tourJoueur(1,d) :- 
  deplacer.

tourJoueur(2,m) :-                          %vérifie si il reste des murs à poser
  compteurJ2(NbMurRestant), NbMurRestant==0,
  write('plus de mur'),
  deplacer.

tourJoueur(2,m) :- 
  poserMur(1), 
  compteur(compteurJ2).

tourJoueur(2,d) :- 
 deplacer.


%création sur une grille de 5x5 pour tester. Sera fait sur 9x9 plus tard
grilleJeu(
    [11,12,13,14,15,
    21,22,23,24,25,
    31,32,33,34,35,
    41,42,43,44,45,
    51,52,53,54,55]).

afficheGrilleJeu :- grilleJeu(G), printGrid(G). %affichage de la grille de jeu




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              GESTION DES MURS                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
poserMur(1):- 
  write('position ?'),
  read(Position),
  write('sens ?'),
  read(Sens),
  poseMur(Position,Sens).

poserMur(2):- 
  write('Impossible de poser un mur ici. Recommencez !'),nl,
  poserMur(1).

poseMur(Position,Sens) :-     %si il y a déjà un mur de placé ici
  mur(Position,Sens,_), 
  poserMur(2).

poseMur(Position,h) :-        %si on coupe un mur
  coupeMur(Position, v), 
  poserMur(2).

poseMur(Position,v) :- 
  coupeMur(Position, h), 
  poserMur(2).

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

coupeMur(Position, Sens) :-                               %on vérifie qu'on ne coupe pas un mur  
  mur(Position, _, debut).

compteur(compteurJ1) :-                                      %compteur de mur restant pour le joueur 1
  compteurJ1(NbMurRestant),
  NbMurRestant2 is NbMurRestant-1,
  retractall(compteurJ1(NbMurRestant)),
  assert(compteurJ1(NbMurRestant2)),
  write('Joueur 1, il vous reste '),
  write(NbMurRestant2),
  write(' mur(s)').

compteur(compteurJ2) :-                                    %compteur de mur restant pour le joueur 2
  compteurJ2(NbMurRestant),
  NbMurRestant2 is NbMurRestant-1,
  retractall(compteurJ2(NbMurRestant)),
  assert(compteurJ2(NbMurRestant2)),
  write('Joueur 2, il vous reste '),
  write(NbMurRestant2),
  write(' mur(s)').





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