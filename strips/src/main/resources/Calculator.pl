
:- op(150, fx, if).
:- op(200, fx, '+').
:- op(200, fx, '-').

action(
    inc(R),
    if [register(R, X)],
    + [register(R, X)],
    - [clear(Y), holding(X)]
).

action(
    unstack(X, Y),
    if [on(X, Y), clear(X), handempty],
    + [clear(Y), holding(X)],
    - [on(X, Y), clear(X), handempty]
).

action(
    pick(X),
    if [ontable(X), clear(X), handempty],
    + [holding(X)],
    - [ontable(X), clear(X), handempty]
).

action(
    put(X),
    if [holding(X)],
    + [ontable(X), clear(X), handempty],
    - [holding(X)]
).