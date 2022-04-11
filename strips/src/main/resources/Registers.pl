
:- op(150, fx, if).
:- op(200, fx, '+').
:- op(200, fx, '-').

action(
    inc(R),
    if [register(R, X)],
    + [register(R, Y)],
    - [register(R, X)],
    where(Y is X + 1)
).

action(
    dec(R),
    if [register(R, X)],
    + [register(R, Y)],
    - [register(R, X)],
    where(Y is X - 1)
).
