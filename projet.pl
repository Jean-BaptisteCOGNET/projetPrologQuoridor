:- dynamic mur/3, joueur1/1,score/1, compteur/1,joueur2/1, joueur/1, nbtour/1.
:- retractall(mur(_,_)).
joueur1(10).
joueur2(10).
joueur(1).
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
  joueur(X),X=1,
  write('Joueur 1'), nl,
  write('Que voulez vous faire ? m. pour poser un mur ou d. pour vous deplacer'),nl,
  tour(1),
  retractall(joueur(_)),
  assert(joueur(2)).

jouer :-
  joueur(X),X=2,
  write('Joueur 2'), nl,
  write('Ecrire action que voulez-vous faire ?'),nl,
  retractall(joueur(_)),
  assert(joueur(1)),
  tour(2).

tour(1) :- 
  read(X),X==m,
  poserMur(1), 
  compteur(joueur1).

tour(1) :- 
  read(X),X==d, 
  deplacer.

tour(2) :- 
  read(X),X==m, 
  poserMur(1), 
  compteur(joueur2).

tour(2) :- 
  read(X),X==d,
  deplacer.


%création sur une grille de 5x5 pour tester. Sera fait sur 9x9 plus tard
grilleJeu(
    [11,12,13,14,15,
    21,22,23,24,25,
    31,32,33,34,35,
    41,42,43,44,45,
    51,52,53,54,55]).

afficheGrilleJeu :- grilleJeu(G), printGrid(G). %affichage de la grille de jeu

poserMur(1):- 
  write('position ?'),
  read(P),
  write('sens'),
  read(S),
  poseMur(P,S).

poserMur(2):- 
  write('Impossible de poser un mur ici. Recommencez !'),nl,
  poserMur(1).

poseMur(Position,Sens) :- 
  mur(Position,Sens,_), 
  poserMur(2).

poseMur(Position,h) :- 
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

coupeMur(Position, Sens) :-                                 %on vérifie qu'on ne coupe pas un mur  
  mur(Position, _, debut).





compteur(joueur1) :-
  joueur1(NbMurRestant),
  NbMurRestant2 is NbMurRestant-1,
  retractall(joueur1(NbMurRestant)),
  assert(joueur1(NbMurRestant2)),
  write('Joueur 1, il vous reste '),
  write(NbMurRestant2),
  write(' mur(s) a poser').

compteur(joueur2) :-
  joueur2(NbMurRestant),
  NbMurRestant2 is NbMurRestant-1,
  retractall(joueur2(NbMurRestant)),
  assert(joueur2(NbMurRestant2)),
  write('Joueur 2, il vous reste '),
  write(NbMurRestant2),
  write(' mur(s) a poser').





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