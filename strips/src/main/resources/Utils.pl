
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logging
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic(indentation/1).

indentation(0).

indent :-
    indentation(N),
    retract(indentation(N)),
    M is N + 4,
    assert(indentation(M)).

unindent :-
    indentation(N),
    N > 0, !,
    retract(indentation(N)),
    M is N - 4,
    assert(indentation(M)).
unindent :-
    indentation(_).

newline :-
    nl,
    indentation(N),
    write_indentation(N).

write_indentation(0) :- !.
write_indentation(N) :-
    N > 0,
    write(' '),
    M is N - 1,
    write_indentation(M).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inclusion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

in(X, [Y | YS]) :-
    member(X, [Y | YS]).

in(X, Set) :-
    Set =.. ['{}', Args], !,
    in(X, Args).

in(X, (Y, YS)) :-
    in_conj(X, (Y, YS)).

in_conj(X, (X, _)).
in_conj(X, (_, X)) :-
    not(X = (_, _)).
in_conj(X, (_, YS)) :-
    YS = (_, _), in_conj(X, YS).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

member(E, [E | Xs], [], Xs).
member(E, [X | Xs], [X | L], R) :- member(E, Xs, L, R).
member(E, Xs, Xs1) :- member(E, Xs, L, R), append(L, R, Xs1).

union([], [], []) :- !.
union(S, [], S) :- !.
union([], S, S) :- !.
union(S1, S2, [X | S3]) :-
    member(X, S1, S1_2),
    member(X, S2, S2_2), !,
    union(S1_2, S2_2, S3).
union(S1, S2, [X | S3]) :-
    member(X, S1, S1_2), !,
    union(S1_2, S2, S3).

intersection([], [], []) :- !.
intersection(_, [], []) :- !.
intersection([], _, []) :- !.
intersection(S1, S2, [X | S3]) :-
    member(X, S1, S1_2),
    member(X, S2, S2_2), !,
    intersection(S1_2, S2_2, S3).
intersection(S1, S2, S3) :-
    member(_, S1, S1_2),
    intersection(S1_2, S2, S3).

subtract(S1, S2, S3) :-
     difference(S1, S2, S3).

difference(S, [], S) :- !.
difference(S, [], S) :- !.
difference([], _, []) :- !.
difference(S1, S2, S3) :-
    member(X, S2, S2_2),
    member(X, S1, S1_2), !,
    difference(S1_2, S2_2, S3).
difference(S1, S2, S3) :-
    member(_, S2, S2_2), !,
    difference(S1, S2_2, S3).

setrel([], [_ | _], neq) :- !.
setrel([], [_ | _], subset) :- !.
setrel([], [_ | _], subseteq) :- !.
setrel([], [], subseteq) :- !.
setrel([], [], eq) :- !.
setrel([], [], superseteq) :- !.
setrel([_ | _], [], neq) :- !.
setrel([_ | _], [], superset) :- !.
setrel([_ | _], [], superseteq) :- !.
setrel(S1, S2, Rel) :-
    member(X, S1, S1_2), !,
    member(X, S2, S2_2),
    setrel(S1_2, S2_2, Rel).
setrel(S1, S2, Rel) :-
    member(X, S2, S2_2),
    member(X, S1, S1_2),
    setrel(S1_2, S2_2, Rel).
setrel(_, _, neq) :- !.

superset(S1, S2) :- setrel(S1, S2, superset).
subset(S1, S2) :-
    setrel(S1, S2, subset).
subseteq(S1, S2) :-
    setrel(S1, S2, subseteq).
superseteq(S1, S2) :- setrel(S1, S2, superseteq).
neq(S1, S2) :- setrel(S1, S2, neq).
eq(S1, S2) :- setrel(S1, S2, eq).
