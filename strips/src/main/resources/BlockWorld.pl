
:- op(150, fx, if).
:- op(200, fx, '+').
:- op(200, fx, '-').

action(
    stack(X, Y),
    if [clear(Y), holding(X)],
    + [on(X,Y), clear(X), handempty],
    - [clear(Y), holding(X)],
    where(true)
).

action(
    unstack(X, Y),
    if [on(X, Y), clear(X), handempty],
    + [clear(Y), holding(X)],
    - [on(X, Y), clear(X), handempty],
    where(true)
).

action(
    pick(X),
    if [ontable(X), clear(X), handempty],
    + [holding(X)],
    - [ontable(X), clear(X), handempty],
    where(true)
).

action(
    put(X),
    if [holding(X)],
    + [ontable(X), clear(X), handempty],
    - [holding(X)],
    where(true)
).
