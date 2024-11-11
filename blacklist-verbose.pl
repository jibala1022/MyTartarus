% Dynamic predicate to store the IP, count, and time of blacklisting
:- dynamic ip_record/3.  % ip_record(IP, Count, BlacklistTime)

% Adds an IP and increments its count, if blacklist time expired, reset count to 1
add_ip(IP, K, Duration) :-
    get_time(CurrentTime),
    (   ip_record(IP, Count, BlacklistTime)
    ->  % If the IP is already recorded, check if it's blacklisted and expired
        retract(ip_record(IP, Count, BlacklistTime)),
        TimeElapsed is CurrentTime - BlacklistTime,
        (   TimeElapsed > Duration  % Blacklist time expired, reset count
        ->  assert(ip_record(IP, 1, CurrentTime)),  % Reset count to 1, update time
            format('IP ~w: Blacklist expired, count reset to 1 at time ~2f.~n', [IP, CurrentTime])
        ;   % Otherwise, increment count and update
            NewCount is Count + 1,
            assert(ip_record(IP, NewCount, CurrentTime)),
            format('IP ~w: Count incremented to ~w.~n', [IP, NewCount])
        )
    ;   % If the IP is not recorded, add it with count 1 and no blacklist
        assert(ip_record(IP, 1, CurrentTime)),
        format('IP ~w: Added with count 1.~n', [IP])
    ).

is_blacklisted(IP, K, Duration) :-
    get_time(CurrentTime),
    (   ip_record(IP, Count, BlacklistTime)
    ->  (TimeElapsed is CurrentTime - BlacklistTime,
        TimeElapsed =< Duration
        ->  (Count > K
            -> format('IP ~w is blacklisted. Time left: ~2f seconds.~n', [IP, Duration - TimeElapsed])
            ; format('IP ~w is not blacklisted. Count: ~w.~n', [IP, Count]), fail
            )
        ;   (Count > K
            -> format('IP ~w is not blacklisted. IP expired.~n', [IP])
            ; format('IP ~w is not blacklisted.~n', [IP])
            ), fail
        )
    ;   format('IP ~w is not in the record.~n', [IP]),
        fail
    ).