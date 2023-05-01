# Enums and Pattern Matching


## Enums
Enums are a way to define a set of named values, each with an associated data type. They are useful for defining a fixed set of possible values for a variable or function parameter. Using enums can help to improve code readability and prevent errors.

Enums are defined with the keyword `enum`, followed by a given name with the first letter being uppercase. In the next sections, we will look at how enums can be combined with pattern matching.


```rust
enum Colours { 
    Red: (), 
    Green: (), 
    Blue: (), 
    }
```


## Pattern Matching
Pattern matching is a powerful feature that allows you to match the value of an expression against a set of patterns, and to execute different blocks of code depending on which pattern matches. It is implemented in Cairo 1 using the `match` keyword and provides both efficiency and expressiveness within the code.

```rust
enum Colours { 
    Red: (), 
    Green: (), 
    Blue: (), 
    }

fn get_colour() -> Colours {
    Colours::Red(())
}

fn main() -> felt252 {
    let new_colour = get_colour();

    let result = match new_colour {
        Colours::Red(()) => {
            1
        },
        Colours::Green(()) => {
            2
        },
        Colours::Blue(()) => {
            3
        },
    };

    // returning the value 1
    result
}
```
In this example, we define the `Colours` enum with three variants: `Red`, `Green`, and `Blue`, each with an associated empty tuple (). We then define the `get_colour()` function, which returns the `Colours::Red` variant.

Inside the `main()` function, we call `get_colour()` and store the result in the `new_colour` variable. We then perform pattern matching on `new_colour` using a `match` statement and return a certain value based on the matching pattern. In this case, since `new_colour` is `Colours::Red`, the value `1` is returned.

