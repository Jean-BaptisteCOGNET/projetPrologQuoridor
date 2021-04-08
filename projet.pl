:- dynamic mur/3, 
joueur/1,                     %Determine la personne qui doit jouer   
compteurJoueur/2,             %Contient le NbMur restant par joueur
positionJoueur/2,             %Contient la position de chaque joueur
arc/3,                        %Contient les case voisines d'une case
compteurCase/1,               %Permet d'afficher les cases dans la console
compteurMur/1.                %Permet d'afficher les murs dans la console


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           FONCTIONS PRINCIPALES                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
demarrer :-  
    nl,
    write('Bienvenue dans Quoridor ! '), nl,
    regle,
    initialisation,
    instructions,
    
    jouer.                    %appel jouer

regle :-
  nl,
  write('Le jeu Quoridor est un jeu de strategie combinatoire, qui se joue sur un plateau de 81 cases carrees (9x9) et qui se joue ici a 2 joueurs.'), nl, nl,
  write('Les joueurs sont representes par un pion J1 et un pion J2 sur le plateau et commencent chacun au centre de leur ligne de fond, en haut au milieu pour le joueur J1 (case 15) et en bas au milieu pour le joueur J2 (case 95).'), nl, nl,
  write('Chaque case du plateau est representee par un numero et constitue une position potentielle ou les pions des joueurs peuvent se trouver.'),nl, nl,
  write('Chaque joueur dispose d un certains nombre de murs chacun, pour entraver la progression du joueur adverse. Un mur peut etre place entre deux ensembles de deux cases. Deux murs ne peuvent ni se croiser, ni etre poses au meme endroit, ni etre poses sur les bords du plateau de jeu.'),nl, nl,
  write('Chaque joueur a son tour choisit de deplacer son pion ou de poser un mur. Lorsqu il n a plus de murs, le joueur doit deplacer son pion.'),nl,nl,
  write('Le but du jeu est d arriver le premier sur la ligne de fond adverse. '), nl,nl.

instructions :-
  nl, nl, write('Pour pouvoir jouer, entrez les differentes commandes suivantes en respectant la syntax Prolog (pas de majuscule et avec un point a la fin de la commande).'), nl,
  write('Les differentes commandes du jeu sont :'), nl,
  write('demarrer.                -- pour lancer le jeu.'), nl,
  write('jouer.                   -- pour jouer.'), nl,
  write('instructions.            -- revoir ce message.'), nl,
  write('halt.                    -- fermer prolog.'), nl,nl,
  write('La grille de jeu quant a elle est constituee des cases suivantes : '), nl,
  nl, afficheGrille,          %appel de l'affichage de la grille de jeu
  nl,nl.

initialisation:-              %Initialise les paramètre du jeu
  retractall(mur(_,_,_)),
  retractall(compteurJoueur(_,_)),
  retractall(joueur(_)),
  retractall(positionJoueur(_,_)),
  retractall(compteurCase(_)),
  retractall(compteurMur(_)),
  retractall(arc(_,_,_,_)),
  write('Combien de murs voulez-vous avoir au debut de la partie (10 est le nombre standard) ?'),nl,
  read(NbMur),
  assert(compteurJoueur(1,NbMur)),
  assert(compteurJoueur(2,NbMur)),
  assert(joueur(1)),
  assert(positionJoueur(1,15)),
  assert(positionJoueur(2,95)),
  assert(compteurCase(11)),
  assert(compteurMur(11)),
  creerArc(11).

%Crée l'ensemble des voisins de chaque case
creerArc(X):-                 %Ajoute des arcs avec les voisins du dessous
  X < 90,  
  X3 is X +10,
  assert(arc(X, X3,1)),       %crée un liaison orientéentre une case et son voisin du bas
  assert(arc(X3, X,1)),       %crée un liaison orientéentre un voisin du bas et une case
  XA is X+1,
  X2 is XA mod 10,
  X2 =:= 0,
  X4 is X3 - 8,
  creerArc(X4).

creerArc(X):-                 %Si ce n'est pas la denière colonne, ajoute en plus des voisins à droite
  X < 99,
  X3 is X +1,
  assert(arc(X, X3,1)),       %crée un liaison orienté entre une case et son vosin de droite
  assert(arc(X3, X,1)),       %crée un liaison entre un voisin de droite et une case
  creerArc(X3).

creerArc(X):-                 %cas des voisins de la dernière colone de la dernière ligne (pas de voisin à droite et en bas)
  XA is X+1,
  X2 is XA mod 10,
  X2 =:= 0.


jouer :-                      %vérifie si le J1 à gagné
  gagne(1).

jouer :-                      %vérifie si le J2 à gagné
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

tourJoueur(Joueur,m) :-       %vérifie si il reste des murs à poser au joueur
  compteurJoueur(Joueur,NbMurRestant),
  NbMurRestant < 1,  
  write('Plus de mur,vous ne pouvez que vous deplacer'), nl,
  deplacer(Joueur,1).

tourJoueur(Joueur,m) :-       %le Joueur pose un mur
  poserMur(1), 
  compteur(Joueur,compteurJoueur).

tourJoueur(Joueur,d) :-       %le Joueur se deplace
  deplacer(Joueur,1).


gagne(1):-                    %vérifie si le J1 à gagné
  positionJoueur(1, Position),
  Position > 90, 
  ansi_format([bold,fg(green)], 'Le joueur 1 gagne !', []).

gagne(2):-                    %vérifie si le J2 à gagné
  positionJoueur(2, Position),
  Position < 20, 
   ansi_format([bold,fg(cyan)], 'Le joueur 2 gagne !', []).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            GESTION DES DEPLACEMENTS                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deplacer(Joueur, 1) :-        %demande au joueur le sens de déplacement
  write('Direction ? (g. pour gauche, d. pour droite, h. pour haut, b. pour bas)'),nl,
  read(Direction),
  deplace(Joueur, Direction).

deplacer(Joueur, 2) :-        %indique que le déplacement n'est pas possible car il est arrivé sur l'autre joueur
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),
  PositionJ1 == PositionJ2,
  write('Vous etes sur l autre joueur !'),nl,
  deplacer(Joueur, 1).

deplacer(Joueur, 2) :-        %indique que le déplacement n'est pas possible car il y a un mur ou il sort de la grille
  write('Deplacement impossible, recommencez !'),nl,
  deplacer(Joueur, 1).

deplace(Joueur,g) :-          %vérifie si le joueur est sur la gauche de la grille 
  positionJoueur(Joueur, Position),
  Position2 is Position -1,
  Position3 is Position2 mod 10, 
  Position3 =:= 0,
  deplacer(Joueur, 2).

deplace(Joueur,g) :-          %vérifie si il y a un mur à gauche
  positionJoueur(Joueur, Position),
  Position2 is Position -1,
  mur(Position2, v, _),
  deplacer(Joueur, 2).

deplace(1,g) :-               %saute par dessus le J2 si il est sur la gauche
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ1 - 1,
  Position2 == PositionJ2,
  retractall(positionJoueur(1,_)),
  assert(positionJoueur(1, Position2)),
  deplace(1,g).

deplace(2,g) :-               %saute par dessus le J1 si il est sur la gauche
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ2 - 1,
  Position2 == PositionJ1,
  retractall(positionJoueur(2,_)),
  assert(positionJoueur(2, Position2)),
  deplace(2,g).

deplace(Joueur,g) :-          %déplace le joueur à gauche dans le cas idéal
  positionJoueur(Joueur, Position),
  Position2 is Position - 1,
  retractall(positionJoueur(Joueur,_)),
  assert(positionJoueur(Joueur, Position2)).

deplace(Joueur,d) :-          %vérifie si le joueur est sur la droite de la grille
  positionJoueur(Joueur, Position),
  Position2 is Position +1,
  Position3 is Position2 mod 10, 
  Position3 =:= 0,
  deplacer(Joueur, 2).

deplace(Joueur,d) :-          %vérifie si il y a un mur à droite
  positionJoueur(Joueur, Position),
  mur(Position, v, _),
  deplacer(Joueur, 2).

deplace(1,d) :-               %saute par dessus le J2 si il est sur la droite
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ1 + 1,
  Position2 == PositionJ2,
  retractall(positionJoueur(1,_)),
  assert(positionJoueur(1, Position2)),
  deplace(1,d).

deplace(2,d) :-               %saute par dessus le J1 si il est sur la droite
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ2 + 1,
  Position2 == PositionJ1,
  retractall(positionJoueur(2,_)),
  assert(positionJoueur(2, Position2)),
  deplace(2,d).

deplace(Joueur,d) :-          %déplace le joueur à droite dans le cas idéal
  positionJoueur(Joueur, Position),
  Position2 is Position + 1,
  retractall(positionJoueur(Joueur,_)),
  assert(positionJoueur(Joueur, Position2)).

deplace(Joueur,h) :-          %vérifie si le joueur est en haut de la grille
  positionJoueur(Joueur, Position),
  Position =< 20,
  deplacer(Joueur, 2).

deplace(Joueur,h) :-          %vérifie si il y a un mur en haut
  positionJoueur(Joueur, Position),
  Position2 is Position -10,
  mur(Position2, h, _),
  deplacer(Joueur, 2).

deplace(1,h) :-               %saute par dessus le J2 si il est en haut
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ1 - 10,
  Position2 == PositionJ2,
  retractall(positionJoueur(1,_)),
  assert(positionJoueur(1, Position2)),
  deplace(1,h).

deplace(2,h) :-               %saute par dessus le J1 si il est en haut
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ2 - 10,
  Position2 == PositionJ1,
  retractall(positionJoueur(2,_)),
  assert(positionJoueur(2, Position2)),
  deplace(2,h).

deplace(Joueur,h) :-          %déplace le joueur vers le haute dans le cas idéal
  positionJoueur(Joueur, Position),
  Position2 is Position - 10,
  retractall(positionJoueur(Joueur,_)),
  assert(positionJoueur(Joueur, Position2)).

deplace(Joueur,b) :-          %vérifie si le joueur est en bas de la grille
  positionJoueur(Joueur, Position),
  Position >= 90,
  deplacer(Joueur, 2).

deplace(Joueur,b) :-          %vérifie si il y a un mur en bas
  positionJoueur(Joueur, Position),
  mur(Position, h, _),
  deplacer(Joueur, 2).

deplace(1,b) :-               %saute par dessus le J2 si il est en bas
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ1 + 10,
  Position2 == PositionJ2,
  retractall(positionJoueur(1,_)),
  assert(positionJoueur(1, Position2)),
  deplace(1,b).

deplace(2,b) :-               %saute par dessus le J1 si il est en bas
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),  
  Position2 is PositionJ2 + 10,
  Position2 == PositionJ1,
  retractall(positionJoueur(2,_)),
  assert(positionJoueur(2, Position2)),
  deplace(2,b).

deplace(Joueur,b) :-          %déplace le joueur vers le bas dans le cas idéal
  positionJoueur(Joueur, Position),
  Position2 is Position + 10,
  retractall(positionJoueur(Joueur,_)),
  assert(positionJoueur(Joueur, Position2)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              GESTION DES MURS                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
poserMur(1):-                 %demande la position et le sens du mur à poser
  write('position ?'),
  read(Position),
  write('sens ?'),
  read(Sens),
  poseMur(Position,Sens).

poserMur(2):-                 %indique que la pose d'un mur n'est pas possible car il y a un mur ou il sort de la grille ou coupe un mur
  write('Impossible de poser un mur ici. Recommencez !'),nl,
  poserMur(1).

poseMur(Position,Sens) :-     %si il y a déjà un mur de placé ici
  mur(Position,Sens,_), 
  poserMur(2).

poseMur(Position,_) :-        %si on coupe un mur
  coupeMur(Position), 
  poserMur(2).

poseMur(Position,_) :-        %si le mur dépasse à droite
  Position >= 90, 
  poserMur(2).

poseMur(Position,_) :-        %si le mur dépasse à gauche
  Position =< 10, 
  poserMur(2).

poseMur(Position,_) :-        %si le mur est sur la dernière colonne
  Position2 is Position +1, 
  Position3 is Position2 mod 10, 
  Position3 =:= 0,
  poserMur(2).

poseMur(Position,v) :-        %pose le mur vertical si c'est possible
  Position2 is Position +10, \+mur(Position2,v,_),          
  assert(mur(Position, v, debut)),          %crée le debut du mur
  assert(mur(Position2, v, fin)),           %crée la fin du mur
  Position3 is Position +1,
  retractall(arc(Position,Position3,_)),    %supprime la liasion entre les case séparé par le mur
  retractall(arc(Position3,Position,_)),    %supprime la liasion entre les case séparé par le mur
  Position4 is Position2 +1,
  retractall(arc(Position2, Position4,_)),  %supprime la liasion entre les case séparé par le mur
  retractall(arc(Position4, Position2,_)),  %supprime la liasion entre les case séparé par le mur
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),
  poseMurPossibleJ1(PositionJ1),
  poseMurPossibleJ2(PositionJ2).

poseMur(Position,v) :-        %supprime le mur créé si il bloque le jeu et remets les liaisons entre les cases
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

poseMur(Position,h) :-        %pose le mur horitzontal si c'est possible 
  Position2 is Position +1, \+mur(Position2,h,_),           
  assert(mur(Position, h, debut)),          %crée le debut du mur
  assert(mur(Position2, h, fin)),           %crée la fin du mur
  Position3 is Position +10,
  retractall(arc(Position,Position3,_)),    %supprime la liasion entre les case séparé par le mur
  retractall(arc(Position3,Position,_)),    %supprime la liasion entre les case séparé par le mur
  Position4 is Position2 +10,
  retractall(arc(Position2, Position4,_)),  %supprime la liasion entre les case séparé par le mur
  retractall(arc(Position4, Position2,_)),  %supprime la liasion entre les case séparé par le mur
  positionJoueur(1, PositionJ1),
  positionJoueur(2, PositionJ2),
  poseMurPossibleJ1(PositionJ1),
  poseMurPossibleJ2(PositionJ2).

poseMur(Position,h) :-        %supprime le mur créé si il bloque le jeu et remets les liaisons entre les cases
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

coupeMur(Position) :-         %on vérifie qu'on ne coupe pas un mur  
  mur(Position, _, debut).


%test si il existe toujours un chemin entre le J1 et l'arrivée
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

%test si il existe toujours un chemin entre le J2 et l'arrivée
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


compteur(1, compteurJoueur) :-              %compteur de mur restant pour le joueur 1
  compteurJoueur(1,NbMurRestant),
  retractall(compteurJoueur(1,_)),
  NbMurRestant2 is NbMurRestant-1,
  assert(compteurJoueur(1,NbMurRestant2)),
  ansi_format([bold,fg(green)], 'Le joueur 1, il vous reste ~w mur(s)', [NbMurRestant2]).

compteur(2, compteurJoueur) :-              %compteur de mur restant pour le joueur 1
  compteurJoueur(2,NbMurRestant),
  retractall(compteurJoueur(2,_)),
  NbMurRestant2 is NbMurRestant-1,
  assert(compteurJoueur(2,NbMurRestant2)),
  ansi_format([bold,fg(cyan)], 'Le joueur 2, il vous reste ~w mur(s)', [NbMurRestant2]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           GESTION DE L'AFFICHAGE                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
afficheGrille :-              %Si compteurCase >=99 (a terminé d'afficher la grille)
  compteurCase(X),
  X>=99,
  retractall(compteurCase(_)),
  assert(compteurCase(11)),
  retractall(compteurMur(_)),
  assert(compteurMur(11)).

afficheGrille :-              %affiche la grille tant que le compteurCase < 99
  afficheCase.

afficheCase :-                %à la fin de la ligne appel affichage de la ligne destiné au mur  
  compteurCase(X), X2 is X mod 10, X2=:=0,
  X3 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X3)),
  nl,
  afficheMur.

afficheCase :-                %affiche J1 si J1 est sur la case à afficher
  compteurCase(X),
  positionJoueur(1, X),  
  ansi_format([bold,fg(green)], 'J1', []),
  afficheMurV,                %appel à afficheMurV pour afficher un mur si besoin
  X2 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X2)),
  afficheCase.

afficheCase :-                %affiche J2 si J2 est sur la case à afficher
  compteurCase(X),
  positionJoueur(2, X),
  ansi_format([bold,fg(cyan)], 'J2', []),
  afficheMurV,
  X2 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X2)),
  afficheCase.

afficheCase :-                %affiche le numéro de la case
  compteurCase(X),
  write(X),
  afficheMurV,
  X2 is X +1,
  retractall(compteurCase(_)),
  assert(compteurCase(X2)),
  afficheCase.

afficheMurV :-                %affiche un mur vertical entre les cases si besoin
  compteurCase(X),
  mur(X,v,_),
  write("|").

afficheMurV :-                %affiche un blanc si il n'y a pas de mur vertical
  write(" ").

afficheMur :-                 %fin de la ligne, passage à la ligne suivante
  compteurMur(X), X2 is X mod 10, X2=:=0,
  X3 is X +1,
  retractall(compteurMur(_)),
  assert(compteurMur(X3)),
  nl,
  afficheGrille.

afficheMur :-                 %affiche un mur horizontal entre les cases si besoin
  compteurMur(X),
  mur(X, h, _),
  write("---"),
  X2 is X +1,
  retractall(compteurMur(_)),
  assert(compteurMur(X2)),
  afficheMur.

afficheMur :-                 %affiche un blanc si il n'y a pas de mur horizontal
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