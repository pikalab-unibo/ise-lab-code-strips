
:- op(150, fx, if).
:- op(200, fx, '+').
:- op(200, fx, '-').

action(
    inc(R),
    if [register(R, X)],
    + [register(R, X + 1)],
    - [register(R, X)],
    where(true)
).

action(
    dec(R),
    if [register(R, X)],
    + [register(R, X - 1)],
    - [register(R, X)],
    where(true)
).
