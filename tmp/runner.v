import json

struct Thing {
    s string
    i int
    b bool
    a []string
    m map[string]int
}

// simple object, all good.
fn ok1()? {
    s := '{
        "s": "foo",
        "i": 1,
        "b": true,
        "a": [ "a", "b" ],
        "m": { "a": 1, "b": 2 }
    }'
    t := json.decode(Thing, s)?
    println(t)
}

// "s", "i", and "b" missing, still fine.
fn ok2()? {
    s := '{
        "a": [ "a", "b" ],
        "m": { "a": 1, "b": 2 }
    }'
    t := json.decode(Thing, s)?
    println(t)
}

// "a" removed, panic
fn nope1()? {
    s := '{
        "s": "foo",
        "m": { "a": 1, "b": 2 }
    }'
    t := json.decode(Thing, s)?
    println(t)
}

// "m" removed, panic
fn nope2()? {
    s := '{
        "s": "foo",
        "a": [ "a", "b" ]
    }'
    t := json.decode(Thing, s)?
    println(t)
}

fn main() {
    ok1()?
    ok2()?
    nope1()? // comment this to check nope2
    nope2()?
}


