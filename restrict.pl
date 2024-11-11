% check_user_frame(Frame) :-
%     % Keep traversing the parent frames until you reach the root
%     (   prolog_frame_attribute(Frame, parent, ParentFrame)
%     ->  (   format('Current Frame: ~w, ParentFrame: ~w~n', [Frame, ParentFrame]),
%             ParentFrame == 0  % Reached the ultimate parent
%         ->  prolog_frame_attribute(Frame, goal, Goal),
%             (   Goal == user:_  % Final goal should be 'user:_'
%             ->  true  % Success, top-level user called this predicate
%             ;   writeln('Error: This predicate can only be called by the user.'), fail
%             )
%         ;   check_user_frame(ParentFrame)  % Keep checking further up the call stack
%         )
%     ;   writeln('Error: Could not determine the parent frame.'), fail
%     ).

% Helper predicate to print the current frame and its goal
print_frame(Frame) :-
    prolog_frame_attribute(Frame, goal, Goal),
    format('Current Frame: ~w, Goal: ~w~n', [Frame, Goal]).

check_user_frame(Frame) :-
    % Print the current frame and goal
    print_frame(Frame),
    
    % Keep traversing the parent frames until you reach the root
    (   prolog_frame_attribute(Frame, parent, ParentFrame)
    ->  (   ParentFrame == 0  % Reached the ultimate parent
        ->  prolog_frame_attribute(Frame, goal, Goal),
            (   Goal == user:_  % Final goal should be 'user:_'
            ->  true  % Success, top-level user called this predicate
            ;   writeln('Error: This predicate can only be called by the user.'), fail
            )
        ;   check_user_frame(ParentFrame)  % Keep checking further up the call stack
        )
    ;   writeln('Error: Could not determine the parent frame.'), fail
    ).


% Restricted predicate (can only be called by user)
restricted_predicate :-
    prolog_current_frame(Frame),
    check_user_frame(Frame),
    writeln('Restricted predicate called by user.').

% Unrestricted predicate (can be called by other predicates)
unrestricted_predicate :-
    writeln('Unrestricted predicate called.').

% Caller predicate to test
caller :-
    restricted_predicate,
    writeln('This should not be printed.').
