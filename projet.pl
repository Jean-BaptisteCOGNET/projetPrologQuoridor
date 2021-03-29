:- dynamic mur/3, 
joueur/1,                     %determine la personne qui doit jouer
compteurJ1/1, compteurJ2/1,   %Contient le NbMur restant par joueur
compteurJoueur/2,
positionJoueur/2,
arc/3,
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
  write('Le jeu Quoridor est un jeu de strategie combinatoire, qui se joue sur un plateau de 81 cases carrees (9x9) et qui se joue ici a 2 joueurs.'), nl, 
  write('Les joueurs sont representes par un pion J1 et un pion J2 sur le plateau et commencent chacun au centre de leur ligne de fond, en haut au milieu pour le joueur J1 (case 15) et en bas au milieu pour le joueur J2 (case 95).'), nl,
  write('Chaque case du plateau est representee par un numero et constitue une position potentielle ou les pions des joueurs peuvent se trouver.'),nl,
  write('Chaque joueur dispose de 10 murs chacun, pour entraver la progression du joueur adverse. Un mur peut etre place entre deux ensembles de deux cases. Chaque joueur a son tour choisit de deplacer son pion ou de poser un mur. Lorsqu il n a plus de murs, le joueur doit deplacer son pion.'),
  nl,nl,
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
  retractall(arc(_,_,_,_)),
  assert(compteurJoueur(1,10)),
  assert(compteurJoueur(2,10)),
  assert(joueur(1)),
  assert(positionJoueur(1,85)),
  assert(positionJoueur(2,45)),
  assert(compteurCase(11)),
  assert(compteurMur(11)),
  creerArc(11).

creerArc(99).

creerArc(X):-
  X < 90,
  XA is X+1,
  X2 is XA mod 10,
  X2 =:= 0,
  X3 is X +10,
  assert(arc(X, X3,1)),
  assert(arc(X3, X,1)),
  X4 is X3 - 8,
  creerArc(X4).


creerArc(X):-
  X < 90,
  X3 is X +1,
  assert(arc(X, X3,1)),
  assert(arc(X3, X,1)),
  X4 is X +10,
  assert(arc(X, X4,1)),
  assert(arc(X4, X,1)),
  creerArc(X3).

creerArc(X):-
  XA is X+1,
  X2 is XA mod 10,
  X2 =:= 0.

creerArc(X):-
  X < 100,
  X3 is X +1,
  assert(arc(X, X3,1)),
  assert(arc(X3, X,1)),
  creerArc(X3).




jouer :-
  gagne(1).

jouer :-          %vérifie si le J1 à gagné
  gagne(2).

jouer :-
  joueur(X),X=1,
  ansi_format([bold,fg(green)], 'Joueur 1', []), nl,
  write('Que voulez vous faire ? Tapez m. pour poser un mur ou d. pour vous deplacer'),nl,
  read(Action),
  retractall(joueur(_)),
  assert(joueur(2)),
  tourJoueur(1,Action), nl, nl,
  afficheGrille.

jouer :-
  joueur(X),X=2,
  ansi_format([bold,fg(cyan)], 'Joueur 2', []), nl,
  write('Que voulez vous faire ? Tapez m. pour poser un mur ou d. pour vous deplacer'),nl,
  read(Action),
  retractall(joueur(_)),
  assert(joueur(1)),
  tourJoueur(2,Action), nl, nl,
  afficheGrille.

tourJoueur(1,m) :-                          %vérifie si il reste des murs à poser au J1
  compteurJoueur(1,NbMurRestant),
  NbMurRestant < 1,
  
  write('plus de mur,vous ne pouvez que vous deplacer'), nl,
  deplacer(1,1).

tourJoueur(1,m) :- 
  poserMur(1), 
  compteur(1,compteurJoueur).

tourJoueur(1,d) :- 
  deplacer(1,1).

tourJoueur(2,m) :-                          %vérifie si il reste des murs à poser au J2
  compteurJoueur(2,NbMurRestant),
  NbMurRestant < 1,
  write('plus de mur, vous ne pouvez que vous deplacer'), nl,
  deplacer(2,1).

tourJoueur(2,m) :- 
  poserMur(1), 
  compteur(2, compteurJoueur).

tourJoueur(2,d) :- 
 deplacer(2, 1).

gagne(1):-          %vérifie si le J1 à gagné
  positionJoueur(1, Position),
  Position > 90, 
  ansi_format([bold,fg(green)], 'Le joueur 1 gagne !', []).

gagne(2):-          %vérifie si le J2 à gagné
  positionJoueur(2, Position),
  Position < 20, 
   ansi_format([bold,fg(cyan)], 'Le joueur 2 gagne !', []).


afficheGrilleJeu :- grilleJeu(G), printGrid(G). %affichage de la grille de jeu




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            GESTION DES DEPLACEMENTS                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deplacer(Joueur, 1) :- 
  write('Direction ? (g. pour gauche, d. pour droite, h. pour haut, b. pour bas)'),nl,
  read(Direction),
  deplace(Joueur, Direction).

deplacer(Joueur, 2) :- 
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),
  PositionJ1 == PositionJ2,
  write('Vous etes sur l autre joueur !'),nl,
  deplacer(Joueur, 1).

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

deplace(1,g) :-
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ1 - 1,
  Position2 == PositionJ2,
  retractall(positionJoueur(1,_)),
  assert(positionJoueur(1, Position2)),
  deplace(1,g).

deplace(2,g) :-
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ2 - 1,
  Position2 == PositionJ1,
  retractall(positionJoueur(2,_)),
  assert(positionJoueur(2, Position2)),
  deplace(2,g).

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

deplace(1,d) :-
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ1 + 1,
  Position2 == PositionJ2,
  retractall(positionJoueur(1,_)),
  assert(positionJoueur(1, Position2)),
  deplace(1,d).

deplace(2,d) :-
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ2 + 1,
  Position2 == PositionJ1,
  retractall(positionJoueur(2,_)),
  assert(positionJoueur(2, Position2)),
  deplace(2,d).

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

deplace(1,h) :-
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ1 - 10,
  Position2 == PositionJ2,
  retractall(positionJoueur(1,_)),
  assert(positionJoueur(1, Position2)),
  deplace(1,h).

deplace(2,h) :-
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ2 - 10,
  Position2 == PositionJ1,
  retractall(positionJoueur(2,_)),
  assert(positionJoueur(2, Position2)),
  deplace(2,h).

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

deplace(1,b) :-
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ1 + 10,
  Position2 == PositionJ2,
  retractall(positionJoueur(1,_)),
  assert(positionJoueur(1, Position2)),
  deplace(1,b).

deplace(2,b) :-
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ2 + 10,
  Position2 == PositionJ1,
  retractall(positionJoueur(2,_)),
  assert(positionJoueur(2, Position2)),
  deplace(2,b).

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

poseMur(Position,_) :-        %si on coupe un mur
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
  Position2 is Position +10, \+mur(Position2,v,_),          
  assert(mur(Position, v, debut)),
  assert(mur(Position2, v, fin)),
  Position3 is Position +1,
  retractall(arc(Position,Position3,_)),
  retractall(arc(Position3,Position,_)),
  Position4 is Position2 +1,
  retractall(arc(Position2, Position4,_)),
  retractall(arc(Position4, Position2,_)),
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),
  poseMurPossibleJ1(PositionJ1),
  poseMurPossibleJ2(PositionJ2).

poseMur(Position,v) :-
  Position2 is Position +10,          
  retractall(mur(Position, v, _)),
  retractall(mur(Position2, v, _)),
  Position3 is Position +1,
  assert(arc(Position,Position3,1)),
  assert(arc(Position3,Position,1)),
  Position4 is Position2 +1,
  assert(arc(Position2, Position4,1)),
  assert(arc(Position4, Position2,1)),
  poserMur(2).

poseMur(Position,h) :- 
  Position2 is Position +1, \+mur(Position2,h,_),           
  assert(mur(Position, h, debut)),
  assert(mur(Position2, h, fin)),
  Position3 is Position +10,
  retractall(arc(Position,Position3,_)),
  retractall(arc(Position3,Position,_)),
  Position4 is Position2 +10,
  retractall(arc(Position2, Position4,_)),
  retractall(arc(Position4, Position2,_)),
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),
  poseMurPossibleJ1(PositionJ1),
  poseMurPossibleJ2(PositionJ2).

poseMur(Position,h) :- 
  Position2 is Position +1,           
  retractall(mur(Position, h, _)),
  retractall(mur(Position2, h, _)),
  Position3 is Position +10,
  assert(arc(Position,Position3,1)),
  assert(arc(Position3,Position,1)),
  Position4 is Position2 +10,
  assert(arc(Position2, Position4,1)),
  assert(arc(Position4, Position2,1)), 
  poserMur(2).

coupeMur(Position) :-                                          %on vérifie qu'on ne coupe pas un mur  
  mur(Position, _, debut).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,91, _, _).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,92, _, _).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,93, _, _).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,94, _, _).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,95, _, _).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,96, _, _).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,97, _, _).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,98, _, _).

poseMurPossibleJ1(PositionJ1):- 
  dijkstra(PositionJ1,99, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,11, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,12, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,13, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,14, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,15, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,16, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,17, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,18, _, _).

poseMurPossibleJ2(PositionJ2):- 
  dijkstra(PositionJ2,19, _, _).


compteur(1, compteurJoueur) :-                                      %compteur de mur restant pour le joueur 1
  compteurJoueur(1,NbMurRestant),
  retractall(compteurJoueur(1,_)),
  NbMurRestant2 is NbMurRestant-1,
  assert(compteurJoueur(1,NbMurRestant2)),
  ansi_format([bold,fg(green)], 'Le joueur 1, il vous reste ~w mur(s)', [NbMurRestant2]).

compteur(2, compteurJoueur) :-                                      %compteur de mur restant pour le joueur 1
  compteurJoueur(2,NbMurRestant),
  retractall(compteurJoueur(2,_)),
  NbMurRestant2 is NbMurRestant-1,
  assert(compteurJoueur(2,NbMurRestant2)),
  ansi_format([bold,fg(cyan)], 'Le joueur 2, il vous reste ~w mur(s)', [NbMurRestant2]).



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
  ansi_format([bold,fg(green)], 'J1', []),
  afficheMurV,
  X2 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X2)),
  afficheCase.

afficheCase :-
  compteurCase(X),
  positionJoueur(2, X),
  ansi_format([bold,fg(cyan)], 'J2', []),
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  Dijkstra                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dijkstra
%   + Start        : Point de départ
%   + Finish       : Point de d'arrivée
%   - ShortestPath : Chemin le plus court
%   - Len          : Longueur de ce chemin
%

dijkstra(Start, Finish, ShortestPath, Len) :-
  dijk( [0-[Start]], Finish, RShort, Len),
  reverse(RShort, ShortestPath).


% Le dernier point visité est le point d'arrivée => on s'arrête
%

dijk( [ Len-[Fin|RPath] |_], Fin, [Fin|RPath], Len) :- !.


dijk( Visited, Fin, RShortestPath, Len) :-
  % Recherche du meilleur candidat (prochain point à ajouter au graphe)
  %   et appel récursif au prédicat
  %

  bestCandidate(Visited, BestCandidate), 
  dijk( [BestCandidate|Visited], Fin, RShortestPath, Len).

%
% Recherche toutes les arrêtes pour lesquelles on a:
%  - un point dans le graphe (visité)
%  - un point hors du graphe (candidat)
%
% Retourne le point qui minimise la distance par rapport à l'origine
%

bestCandidate(Paths, BestCandidate) :-

  % à partir d'un point P1 :
  
  findall(
     NP            % on fait la liste de tous les points P2 tels que:
  ,
    (
      member( Len-[P1|Path], Paths),  % - le point P2 a déjà été visité
      arc(P1,P2,Dist),                % - il existe un arc allant de P1 à P2, de distance Dist
      \+isVisited(Paths, P2),         % - le point P2 n'a pas encore été visité

      NLen is Len+Dist,               % on calcule la distance entre l'origine et le point P2

      NP=NLen-[P2,P1|Path]            % on met chaque élément de la liste sous la forme: Distance-Chemin
                                      % pour pouvoir les trier avec le prédicat keysort/2
    )
  ,
    Candidates
  ),

  % On trie et on retient le chemin le plus court
  minimum(Candidates, BestCandidate).

%
% Sort le meilleur candidat parmi une liste de candidats
% (= celui de chemin le moins long)
%

minimum(Candidates, BestCandidate) :-
  keysort(Candidates, [BestCandidate|_]).
%
% Teste si un point P a déjà été visité
%
isVisited(Paths, P) :-
  memberchk(_-[P|_], Paths).