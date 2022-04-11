
:- op(900, xfx, in).

strips(InitState, GoalList, Plan) :-
    strips(InitState, GoalList, 1, 1, Plan).

strips(_, _, _, Max, _) :- max_depth(Max), !, fail.

strips(InitState, GoalList, N, Max, Plan) :-
    write("Trying with target plan length to: "), write(Max), newline,
    strips_impl(InitState, GoalList, [], N, Max, _, RevPlan),
    N =< Max,
    reverse(RevPlan, Plan).

strips(InitState, GoalList, N, Max, Plan) :-
    NewMax is Max + 1,
    strips(InitState, GoalList, 0, NewMax, Plan).

strips_impl(State, Goal, Plan, N, Max, State, Plan) :-
    N =< Max,
    subseteq(Goal, State),
    write("Reached goal "), write(Goal), write(" in "), write(State),
    reverse(Plan, ActualPlan),
    write(" through plan "), write(ActualPlan), unindent, newline.

strips_impl(State, Goal, Plan, N, Max, FinalState, FinalPlan) :-
    N =< Max,
    write("Need to reach "), write(Goal), write(" from "), write(State), indent, newline,
    SubGoal in Goal,
    not(SubGoal in State),
    write('Attempting goal:  '), write(SubGoal), newline,
    action(Action, 'if'(PrecList), '+'(AddList), _, _),
    member(SubGoal, AddList),
    write('Choosing Action:  '), write(Action), newline,
    write('Need to satisfy preconditions of '), write(Action), write(", that are: "), write(PrecList), newline,
    N1 is N + 1,
    strips_impl(State, PrecList, Plan, N1, Max, TmpState, TmpPlan),
    apply(TmpState, Action, NewState),
    strips_impl(NewState, Goal, [Action | TmpPlan], N1, Max, FinalState, FinalPlan).

strips_impl(_, _, _, N, M, _, _) :-
    (N > M -> write("Reached depth limit, trying another way"), unindent, newline; unindent),
    !, fail.

apply(State, Action, NewState) :-
    write('Simulating '), write(Action), newline,
    write('Transition: '), write(State),
    action(Action, 'if'(PrecList), '+'(AddList), '-'(DelList), where(Conditions)),
    write(' - '), write(DelList),
    difference(State, DelList, TmpState),
    write(" + "),
    subseteq(PrecList, State),
    call(Conditions),
    write(AddList), write(" = "),
    union(AddList, TmpState, NewState),
    write(NewState), newline.
