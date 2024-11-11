% Check if the current frame was invoked by the user
is_called_by_user(Frame) :-
    prolog_frame_attribute(Frame, parent, ParentFrame),
    (   ParentFrame == 0  % This is the root frame
    ->  prolog_frame_attribute(Frame, goal, Goal),
        (   Goal = user:_  % Check if the goal is a top-level user query
        ->  writeln('Called by user.'), true
        ;   writeln('Not called by user.'), fail
        )
    ;   is_called_by_user(ParentFrame)  % Keep checking the parent frames
    ).

% Restricted predicate (can only be called by user)
res :-
    prolog_current_frame(Frame),
    is_called_by_user(Frame),
    writeln('Restricted predicate called by user.').

% Unrestricted predicate (can be called by other predicates)
unrestricted_predicate :-
    writeln('Unrestricted predicate called.').

% Caller predicate to test
caller :-
    res,
    writeln('This should not be printed.').

a:-prolog_current_frame(Frame), prolog_frame_attribute(Frame, goal, Goal), writeln(Goal).
b:-prolog_current_frame(Frame), writeln(Frame), prolog_frame_attribute(Frame, parent, Parent), writeln(Parent), prolog_frame_attribute(Parent, predicate_indicator, Goal), writeln(Goal).
c:-b.

at:-current_atom(Atom),writeln(Atom).