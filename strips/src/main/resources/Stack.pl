
:- op(150, fx, if).
:- op(200, fx, '+').
:- op(200, fx, '-').

action(
    sum,
    if [on(X, on(Y, B))],
    + [on(Z, B)],
    - [on(X, on(Y, B))],
    where(Z is X + Y)
).


action(
    sub,
    if [on(X, on(Y, B))],
    + [on(Z, B)],
    - [on(X, on(Y, B))],
    where(Z is X - Y)
).

action(
    dup,
    if [on(X, B)],
    + [on(X, on(X, B))],
    - [on(X, B)],
    where(true)
).
