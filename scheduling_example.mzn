% Use this editor as a MiniZinc scratch book
include "globals.mzn";

% DATA

int: nbTasks=10; % number of tasks
int: nbEmployees=3; % number of employees
set of int: T=1..nbTasks; % set of tasks
set of int: E=1..nbEmployees; % set of employees
array[E,T] of int: ProcessingTime = [|4,6,2,9,1,8,7,5,3,2| % processing times per employee
5,5,1,9,2,6,9,4,5,3|                                      
3,7,1,9,2,7,8,3,5,2|];

set of int: ST=1..sum(t in T)(max(e in E)(ProcessingTime[e,t])); % domain of definition of the starting time of the tasks
set of int: ET=1..sum(t in T)(max(e in E)(ProcessingTime[e,t]))+max(e in E, t in T)(ProcessingTime[e,t]); % domain of definition of the ending time of the tasks;
int: maxd = max([ ProcessingTime[e,t] | t in T, e in E]); % maximum processing time (for the domain of definition of the duration of the task)
int: mind = min([ ProcessingTime[e,t] | t in T, e in E]); % minimum processing time (for the domain of definition of the duration of the task)

% VARIABLES

array[T] of var ST: start; % A variable that states the starting time of task t
array[T] of var ET: end; % A variable that states the ending time of task t
array[T] of var mind..maxd: duration; % A variable that states the duration of task t  
array[E,T] of var opt ST: optional; % A variable that states that the task t for employee e is optional, i.e. it means it is not necessarily done by this employee
var int: cmax; % A variable that states the objective cmax

% CONSTRAINTS

constraint forall(t in T)(end[t]=start[t]+duration[t]); % defines the end of task t 
constraint forall(t in T) (sum(e in E)(occurs(optional[e,t]))==1); % states that a task t is done only by one employee e
constraint forall(t in T, e in E) (if occurs(optional[e,t])==1 then optional[e,t]==start[t] endif); % links the task with the right employee
constraint forall(t in T, e in E) (if occurs(optional[e,t])==1 then duration[t]=ProcessingTime[e,t] endif); % states that the duration of task t is the processing time when done with employee e

constraint forall(e in E)(disjunctive([optional[e,t]|t in T],[ProcessingTime[e,t]|t in T])); % avoides overlapping tasks for each employee

constraint cmax = max(t in T)(end[t]); % computes the objective cmax

% SOLVE

solve minimize cmax; 

% OUTPUT
output[show(cmax) ++ "\n\n"];

output["employee: \(e) does task \(t) from \(start[t]) to \(end[t]) with duration \(duration[t]) \n" | e in E, t in T where show(occurs(optional[e,t]))=="true"];

%output[" \(e) ; \(t) ; \(start[t]); \(end[t]) \n" | e in E, t in T where show(occurs(optional[e,t]))=="true"];