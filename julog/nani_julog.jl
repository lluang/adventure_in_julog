# NANI Search: an adventure game from Adventures in Prolog
# This is an implementation of the Adventures in Prolog adventure game
# originally written by Dennis Merritt
using Julog

clauses = @julog [
    room(office)<<= true,
    room(kitchen)<<= true,
    room(dining_room)<<= true,
    room(hall)<<= true,
    room(cellar)<<= true,

    door(office,hall)<<= true,
    door(hall,dining_room)<<= true,
    door(dining_room,kitchen)<<= true,
    door(kitchen,cellar)<<= true,
    door(kitchen,office)<<= true,
    connect(X, Y) <<= door(X,Y),
    connect(X, Y) <<= door(Y,X),
    
    location(desk, office)<<= true,
    location(apple, kitchen)<<= true,
    location(flashlight, desk)<<= true,
    location(washing_machine, cellar)<<= true,
    location(nani, washing_machine)<<= true,
    location(broccoli, kitchen)<<= true,
    location(crackers, kitchen)<<= true,
    location(computer, office)<<= true,
    location(envelope, desk)<<= true,
    location(stamp, envelope)<<= true,
    location(key, envelope)<<= true,

    is_contained_in(T1, T2) <<= location(T1, T2),
    is_contained_in(T1, T2) <<= location(X, T2) & is_contained_in(T1, X),

    edible(apple) <<= true,
    edible(crackers) <<= true,
    tastes_yucky(broccoli) <<= true,

    where_food(X,Y) <<= is_contained_in(X,Y) & edible(X),
    where_food(X,Y) <<= is_contained_in(X,Y) & tastes_yucky(X),

    here(kitchen) <<= true,

    list_things(Place) <<= location(X, Place),

    list_connections(Place) <<= connect(Place, X) & write(X),


    can_go(Place) <<= here(X) & connect(X, Place),
    move(Place) <<= retract(here(X)) & asserta(here(Place)),

    look <<= here(Place) & list_things(Place) & list_connections(Place),

    goto(Place) <<= can_go(Place) & move(Place),
    can_take(Thing) <<= here(Place) & is_contained_in(Thing, Place), 
    can_take(Thing) <<= write_prolog("There is no ") & write_prolog(Thing) & write_prolog(" here") & fail,
]

goals = @julog [is_contained_in(X, Y)];
sat, subst = resolve(goals, clauses);
subst

goal2 = @julog [can_take(X)]
sat2, subst2 = resolve(goal2, clauses);
subst2


goal3 = @julog [list_connections(X)];
sat3, subst3 = resolve(goal3, clauses);
subst3

goal4 = @julog [here(X)];
sat4, subst4 = resolve(goal4, clauses);
subst4

goal5 = @julog [can_go(X)];
sat5, subst5 = resolve(goal5, clauses);
subst5