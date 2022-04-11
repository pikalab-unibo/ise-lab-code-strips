
:- op(150, fx, if).
:- op(200, fx, '+').
:- op(200, fx, '-').

action(
    sum,
    if [on(X, Y), on(Y, B), top(X)],
    + [on(X + Y, B), top(X + Y)],
    - [on(X, Y), on(Y, B), top(X)],
    where(true)
).

action(
    sub,
    if [on(X, Y), on(Y, B), top(X)],
    + [on(X - Y, B), top(X - Y)],
    - [on(X, Y), on(Y, B), top(X)],
    where(true)
).

/*
action(
    swap,
    if [on(X, Y), top(X)],
    + [on(Y, X), top(Y)],
    - [on(X, Y), top(X)],
    where(true)
).
*/

action(
    push(X),
    if [top(B)],
    + [top(X), on(X, B)],
    - [top(B)],
    where(true)
) :- X = c1; X = c2; X = c3.

/*
action(
    pop,
    if [on(X, B), top(X)],
    + [top(B)],
    - [on(X, B), top(X)],
    where(true)
).
*/


