% Declare the dynamic predicate to store the information
:- dynamic predicate_info/3.  % predicate_info(IP, PredicateName, Arity)

% Example predicates for testing
p1 :- p2.
p2 :- writeln('Hello World').
p3 :- p1.

% Function to add predicate info
% add_predicate_info(IP, PredicateName, Arity) :-
%     assertz(predicate_info(IP, PredicateName, Arity)).

% % Function to analyze a predicate for calls to other predicates
% analyze_predicate(IP, PredicateName) :-
%     % Check if the predicate exists
%     current_predicate(PredicateName/Arity),
%     % Construct the functor
%     functor(Head, PredicateName, Arity),
%     % Add predicate info
%     add_predicate_info(IP, PredicateName, Arity),
%     % Get the clause body for the predicate
%     clause(Head, Body),
%     % Analyze the body of the predicate
%     analyze_body(IP, Body).

% % Analyze the body of the predicate for nested calls
% analyze_body(_, true).  % Base case for recursion (no body)

% analyze_body(IP, (Body1, Body2)) :-  % Conjunction
%     analyze_body(IP, Body1),
%     analyze_body(IP, Body2).

% analyze_body(IP, (Body1; Body2)) :-  % Disjunction
%     analyze_body(IP, Body1),
%     analyze_body(IP, Body2).

% analyze_body(IP, Body) :-  % Handle calls to other predicates
%     callable(Body),
%     Body =.. [PredicateName | _],
%     \+ predicate_info(_, PredicateName, _),  % Avoid duplicates
%     add_predicate_info(IP, PredicateName, Arity),
%     analyze_predicate(IP, PredicateName).

% Predicate to analyze a predicate's clauses and add non-built-ins to the list
analyze_predicate(IP, PredicateName) :-
    callable(PredicateName),
    functor(PredicateName, Functor, Arity),
    current_predicate(Functor/Arity),
    % Skip built-in predicates
    \+ predicate_property(Functor/Arity, built_in),
    % Add predicate info
    add_predicate_info(IP, Functor, Arity),
    % Get the clause body for the predicate
    clause(PredicateName, Body),
    % Analyze the body of the predicate for further calls
    analyze_body(IP, Body).

% If it's a built-in or invalid predicate, skip it
analyze_predicate(_, PredicateName) :-
    (   \+ callable(PredicateName)
    ;   functor(PredicateName, Functor, Arity),
        predicate_property(Functor/Arity, built_in)
    ),
    writeln('Skipping built-in or invalid predicate.').

% Analyze the body of a predicate recursively (conjunctions or single goals)
analyze_body(IP, (FirstGoal, RestGoals)) :-  % For conjunctions
    analyze_predicate(IP, FirstGoal),
    analyze_body(IP, RestGoals).
analyze_body(IP, Goal) :-  % For single goals
    analyze_predicate(IP, Goal).
analyze_body(_, true).  % Stop at the end

% Add predicate info to the list (if not built-in)
add_predicate_info(IP, Functor, Arity) :-
    assertz(predicate_info(IP, Functor, Arity)).



% Example Usage
% This will analyze predicates and store their info
analyze_all_predicates(IP) :-
    forall(current_predicate(Name/Arity),
           analyze_predicate(IP, Name)).

% To see the stored information
list_predicates :-
    findall((IP, Name, Arity), predicate_info(IP, Name, Arity), List),
    format('Stored predicates: ~w~n', [List]).
