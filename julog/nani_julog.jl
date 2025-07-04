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

    here(office) <<= true,
    turned_off(flashlight) <<= true,

    list_things(Place) <<= location(X, Place) ,

    list_connections(Place) <<= connect(Place, X),

    can_go(Place) <<= here(X) & connect(X, Place),
    can_go(Place) <<= here(X) & 

    move(Place) <<= retract(here(X)) & asserta(here(Place)),

    # look and look_in do not work yet
    look_in(Place) <<= here(Place) & write_prolog("You are in the ") & write_prolog(Place) &
            write_prolog("You can see ") & list_things(Place) & 
            write_prolog("You can go to ") & list_connections(Place),

    look <<= here(Place) & write_prolog("You are in the ") & write_prolog(Place) &
            write_prolog("You can see ") & list_things(Place) & 
            write_prolog("You can go to ") & list_connections(Place),

    goto(Place) <<= can_go(Place) & move(Place),
    
    can_take(Thing) <<= here(Place) & is_contained_in(Thing, Place), 
    can_take(Thing) <<= write_prolog("There is no ") & write_prolog(Thing) & write_prolog(" here") & fail,
    
    take(X) <<= can_take(X) & take_object(X),
    take_object(X) <<= retract(location(X, _)) & assert(have(X)),

    write_weight(1) <<= write_prolog("1 pound"),
    write_weight(W) <<= write_prolog(W) & write_prolog(" pounds"),
    move(Place) <<=  retract(here(X)) & asserta(here(Place))


]

goals = @julog [is_contained_in(X, Y)];
sat, subst = resolve(goals, clauses);
subst

resolve(@julog(can_take(X)), clauses)

resolve(@julog(list_connections(X)), clauses)

resolve(@julog(here(X)), clauses)

resolve(@julog(can_go(X)), clauses)

resolve(@julog(where_food(X, Y)), clauses)

resolve(@julog(look), clauses)

resolve(@julog(look_in(X)), clauses)

resolve(@julog(can_take(X)), clauses)
resolve(@julog(can_take(flashlight)), clauses)
resolve(@julog(take(flashlight)), clauses)
resolve(@julog(has(X)), clauses)

