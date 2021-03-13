:- dynamic mur/3, 
joueur/1,                     %determine la personne qui doit jouer
compteurJ1/1, compteurJ2/1,   %Contient le NbMur restant par joueur
compteurJoueur/2,
positionJoueur/2,
compteurCase/1, compteurMur/1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           FONCTIONS PRINCIPALES                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
demarrer :- 
    initialisation, 
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
  write('jouer.                   -- pour jouer.'), nl,
  write('instructions.            -- revoir ce message.'), nl,
  write('halt.                    -- fermer prolog.'), nl,nl,
  write('La grille de jeu quant a elle est constituee des cases suivantes : '), nl,
  nl, afficheGrille, %appel de l'affichage de la grille de jeu
  nl,nl.

initialisation:- 
  retractall(mur(_,_,_)),
  retractall(compteurJoueur(_,_)),
  retractall(joueur(_)),
  retractall(positionJoueur(_,_)),
  retractall(compteurCase(_)),
  retractall(compteurMur(_)),
  assert(compteurJoueur(1,1)),
  assert(compteurJoueur(2,1)),
  assert(joueur(1)),
  assert(positionJoueur(1,85)),
  assert(positionJoueur(2,95)),
  assert(compteurCase(11)),
  assert(compteurMur(11)).

jouer :-
  gagne(1).

jouer :-          %vérifie si le J1 à gagné
  gagne(2).

jouer :-
  joueur(X),X=1,
  write('Joueur 1'), nl,
  write('Que voulez vous faire ? Tapez m. pour poser un mur ou d. pour vous deplacer'),nl,
  read(Action),
  retractall(joueur(_)),
  assert(joueur(2)),
  tourJoueur(1,Action), nl, nl,
  afficheGrille.

jouer :-
  joueur(X),X=2,
  write('Joueur 2'), nl,
  write('Que voulez vous faire ? Tapez m. pour poser un mur ou d. pour vous deplacer'),nl,
  read(Action),
  retractall(joueur(_)),
  assert(joueur(1)),
  tourJoueur(2,Action), nl, nl,
  afficheGrille.

tourJoueur(1,m) :-                          %vérifie si il reste des murs à poser au J1
  compteurJoueur(1,NbMurRestant),
  NbMurRestant==0,
  
  write('plus de mur'),
  deplacer.

tourJoueur(1,m) :- 
  poserMur(1), 
  compteur(compteurJoueur).

tourJoueur(1,d) :- 
  deplacer(1,1).

tourJoueur(2,m) :-                          %vérifie si il reste des murs à poser au J2
  compteurJoueur(2,NbMurRestant),
  NbMurRestant==0,
  write('plus de mur'),
  deplacer.

tourJoueur(2,m) :- 
  poserMur(1), 
  compteur(compteurJoueur).

tourJoueur(2,d) :- 
 deplacer(2, 1).

gagne(1):-          %vérifie si le J1 à gagné
  positionJoueur(1, Position),
  Position =:= 95, 
  write('Le joueur 1 gagne !').

gagne(2):-          %vérifie si le J2 à gagné
  positionJoueur(2, Position),
  Position =:= 15, 
  write('Le joueur 2 gagne !').

%création sur une grille de 5x5 pour tester. Sera fait sur 9x9 plus tard
grilleJeu(
    [11,12,13,14,15,
    21,22,23,24,25,
    31,32,33,34,35,
    41,42,43,44,45,
    51,52,53,54,55]).

afficheGrilleJeu :- grilleJeu(G), printGrid(G). %affichage de la grille de jeu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            GESTION DES DEPLACEMENTS                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deplacer(Joueur, 1) :- 
  write('Direction ? (g. pour gauche, d. pour droite, h. pour haut, b. pour bas)'),nl,
  read(Direction),
  deplace(Joueur, Direction).

deplacer(Joueur, 2) :- 
  write('Deplacement impossible, recommencez !'),nl,
  deplacer(Joueur, 1).

deplace(Joueur,g) :-
  positionJoueur(Joueur, Position),
  Position2 is Position -1,
  Position3 is Position2 mod 10, 
  Position3 =:= 0,
  deplacer(Joueur, 2).

deplace(Joueur,g) :-
  positionJoueur(Joueur, Position),
  Position2 is Position -1,
  mur(Position2, v, _),
  deplacer(Joueur, 2).

deplace(Joueur,g) :-
  positionJoueur(Joueur, Position),
  Position2 is Position - 1,
  retractall(positionJoueur(Joueur,_)),
  assert(positionJoueur(Joueur, Position2)).

deplace(Joueur,d) :-
  positionJoueur(Joueur, Position),
  Position2 is Position +1,
  Position3 is Position2 mod 10, 
  Position3 =:= 0,
  deplacer(Joueur, 2).

deplace(Joueur,d) :-
  positionJoueur(Joueur, Position),
  mur(Position, v, _),
  deplacer(Joueur, 2).

deplace(Joueur,d) :-
  positionJoueur(Joueur, Position),
  Position2 is Position + 1,
  retractall(positionJoueur(Joueur,_)),
  assert(positionJoueur(Joueur, Position2)).

deplace(Joueur,h) :-
  positionJoueur(Joueur, Position),
  Position =< 20,
  deplacer(Joueur, 2).

deplace(Joueur,h) :-
  positionJoueur(Joueur, Position),
  Position2 is Position -10,
  mur(Position2, h, _),
  deplacer(Joueur, 2).

deplace(Joueur,h) :-
  positionJoueur(Joueur, Position),
  Position2 is Position - 10,
  retractall(positionJoueur(Joueur,_)),
  assert(positionJoueur(Joueur, Position2)).

deplace(Joueur,b) :-
  positionJoueur(Joueur, Position),
  Position >= 90,
  deplacer(Joueur, 2).

deplace(Joueur,b) :-
  positionJoueur(Joueur, Position),
  mur(Position, h, _),
  deplacer(Joueur, 2).
  
deplace(Joueur,b) :-
  positionJoueur(Joueur, Position),
  Position2 is Position + 10,
  retractall(positionJoueur(Joueur,_)),
  assert(positionJoueur(Joueur, Position2)).


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
  coupeMur(Position), 
  poserMur(2).

poseMur(Position,v) :- 
  coupeMur(Position), 
  poserMur(2).

poseMur(Position,_) :- 
  Position >= 90, 
  poserMur(2).

poseMur(Position,_) :- 
  Position2 is Position +1, 
  Position3 is Position2 mod 10, 
  Position3 =:= 0,
  poserMur(2).

poseMur(Position,v) :- 
  %\+Position >= 90,
  %\+mur(Position,v,_),                                    %on vérifie qu'il n'y ait pas déjà un mur
  %\+coupeMur(Position, h),                                %on vérifie qu'on ne coupe pas un mur 
  Position2 is Position +10, \+mur(Position2,v,_),        %on vérifie qu'il n'y ait pas de mur en dessous  
  assert(mur(Position, v, debut)),
  Position2 is Position +10,
  assert(mur(Position2, v, fin)).

poseMur(Position,h) :- 
  %\+Position >= 90,
  %\+mur(Position,h,_),                                    %on vérifie qu'il n'y ait pas déjà un mur
  %\+coupeMur(Position, v),                                %on vérifie qu'on ne coupe pas un mur    
  Position2 is Position +1, \+mur(Position2,h,_),         %on vérifie qu'il n'y ait pas de mur à droite  
  assert(mur(Position, h, debut)),
  Position2 is Position +1,
  assert(mur(Position2, h, fin)).

coupeMur(Position) :-                                      %on vérifie qu'on ne coupe pas un mur  
  mur(Position, _, debut).

compteur(compteurJoueur) :-                                      %compteur de mur restant pour le joueur 1
  compteurJoueur(1,NbMurRestant),
  retractall(compteurJoueur(1,_)),
  NbMurRestant2 is NbMurRestant-1,
  assert(compteurJoeur(1,NbMurRestant2)),
  write('Joueur 1, il vous reste '),
  write(NbMurRestant2),
  write(' mur(s)').

compteur(compteurJoueur) :-                                      %compteur de mur restant pour le joueur 1
  compteurJoueur(2,NbMurRestant),
  retractall(compteurJoueur(1,_)),
  NbMurRestant2 is NbMurRestant-1,
  assert(compteurJoeur(2,NbMurRestant2)),
  write('Joueur 2, il vous reste '),
  write(NbMurRestant2),
  write(' mur(s)').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           GESTION DE L'AFFICHAGE                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
afficheGrille :-
  compteurCase(X),
  X>=99,
  retractall(compteurCase(_)),
  assert(compteurCase(11)),
  retractall(compteurMur(_)),
  assert(compteurMur(11)).

afficheGrille :-
  %compteurCase(X), X2 is X+1, X3 is X2 mod 10, X3=/=0,
  afficheCase.

afficheCase :-
  compteurCase(X), X2 is X mod 10, X2=:=0,
  X3 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X3)),
  nl,
  afficheMur.

afficheCase :-
  compteurCase(X),
  positionJoueur(1, X),
  write("J1"),
  afficheMurV,
  X2 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X2)),
  afficheCase.

afficheCase :-
  compteurCase(X),
  positionJoueur(2, X),
  write("J2"),
  afficheMurV,
  X2 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X2)),
  afficheCase.

afficheCase :-
  compteurCase(X),
  write(X),
  afficheMurV,
  X2 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X2)),
  afficheCase.

afficheMurV :-
  compteurCase(X),
  mur(X,v,_),
  write("|").

afficheMurV :-
  write(" ").

afficheMur :-
  compteurMur(X), X2 is X mod 10, X2=:=0,
  X3 is X +1,
  retractall(compteurMur(_)),
  assert(compteurMur(X3)),
  nl,
  afficheGrille.

afficheMur :-
  compteurMur(X),
  mur(X, h, _),
  write("---"),
  X2 is X +1,
  retractall(compteurMur(_)),
  assert(compteurMur(X2)),
  afficheMur.

afficheMur :-
  compteurMur(X),
  write("   "),
  X2 is X +1,
  retractall(compteurMur(_)),
  assert(compteurMur(X2)),
  afficheMur.

