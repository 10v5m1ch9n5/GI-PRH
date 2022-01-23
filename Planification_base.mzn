% Use this editor as a MiniZinc scratch book
include "globals.mzn";

%PARAMETERS ...to be continued

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
%array[T] of var 0..42: startTime;
%array[T] of var 0..42: finishTime;

% var int: affinite;

% CONSTRAINTS

constraint forall(t in T, s in S)(Qualification[t,s] == Competence[assignation[t],s]); % Les employés ont les compétences requises pour chaque tâche qu'ils effectuent
%constraint forall(t in T) (Predecessor[t] != 0 \/ finishTime[Predecessor[t]] <= startTime[t]); % Chaque tâche doit commencer après la complétion de son prédecesseur

%constraint forall(t in T)(startTime[t] + ProcessingTime[t] <= DeliveryDate[t]); % La tâche doit être complétée avant la date butoir%%


% SOLVE

solve satisfy;


% OUTPUT



