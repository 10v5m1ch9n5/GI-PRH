% Use this editor as a MiniZinc scratch book
include "globals.mzn";

%PARAMETERS ...to be continued
set of int: horizon;

int: nbTasks;
int: nbEmployees;
int: nbSkill;
int: Dwork;

set of int: T=1..nbTasks;
set of int: E=1..nbEmployees;
set of int: S=1..nbSkill;

array[T] of int: Risk;
array[T] of int: ProcessingTime;
array[T] of int: Predecessor;
array[T] of int: DeliveryDate;
array[T,S] of int: Qualification;
array[E] of int: Availability;
array[E] of int: Experience;
array[E,S] of int: Competence;
array[E,T] of int: Preferences;


% VARIABLES

array[T] of var E: assignation;
array[T] of var horizon: startTime;
var int: risqueTotal;
var int: affinite;
var int: heureDeFin;

% CONSTRAINTS

constraint forall(t in T, s in S)(Qualification[t,s] == Competence[assignation[t],s]); % Les employés ont les compétences requises pour chaque tâche qu'ils effectuent

constraint forall(t in T where Predecessor[t] != 0)(startTime[t] >= startTime[Predecessor[t]]+ProcessingTime[Predecessor[t]]); % Chaque tâche commence après son prédecesseur (s'il existe !)
constraint forall(t in T) (startTime[t]+ProcessingTime[t] <= DeliveryDate[t]); % La tâche finit avant la date butoir
constraint forall(t in T) (startTime[t] >= Availability[assignation[t]]); % La tâche est débutée par l'employé une fois qu'il est disponible

constraint risqueTotal = sum([ max(0, Risk[t] - Experience[assignation[t]]) | t in T]); % Somme des différences entre le risque d'une tâche et l'expérience de l'employé qui l'exécute.

constraint forall(e in E)(sum ([ProcessingTime[t] | t in T where assignation[t] == e]) <= 35); % Vérifier qu'aucun employé ne dépasse les 35h

constraint affinite = sum([sum([Preferences[e,t] | t in T where assignation[t] == e]) | e in E]); % Somme des affinités des employés pour les tâches qui leur sont assignées

constraint heureDeFin = max([startTime[t]+ProcessingTime[t] | t in T]); % Heure à laquelle finit la dernière tâche du projet

% SOLVE

% solve minimize heureDeFin;
solve maximize affinite;

% OUTPUT

output["employe \(e) fait les tâches \([t | t in T where assignation[t] = e]) avec les préférences \([Preferences[e,t] | t in T where assignation[t] == e]) pour un total de \(sum([ProcessingTime[t] | t in T where assignation[t] == e])) heures ouvrées\n" | e in E];

% output[]

output["\nRisque total : \(risqueTotal)\n"];
output["Affinite totale : \(affinite)\n"];
output["Heure de fin du projet : \(heureDeFin)"];

