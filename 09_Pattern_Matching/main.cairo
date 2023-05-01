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
