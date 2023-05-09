# WTF Cairo: 11. Control Flow

In this section, we are going to take a look at basic control flows (if-else and loops) available in Cairo. Control flow constructs basically allow you run a code logic depending on whether a condition is true or for repetitive tasks.

## If-else Expressions
If-else expressions enable you run code logics depending on certain conditions. More like "if this condition is met, run this logic else do something different"

```cairo
use debug::PrintTrait;

fn main() {
    let number = 6_u8;

    if number < 10_u8 {
        'number is less than 10'.print();
    } else {
        'number is not less than 10'.print();
    }
}
```

If expressions are started with the `if` keyword followed by the condition to be met. We could optionally include an `else` block specifying the logic to carry out if the condition is not met. 

In our example above, we say if the `number` variable is less than 10, print "number is less than 10", else print "number is not less than 10".

**NB:** It's important to note that your condition must always evaluae to a `bool`, else the compiler will panic.

You could also assign the results of an if-else expression to a variable:

```cairo
use debug::PrintTrait;

fn main() -> u8 {
    let number = 6_u8;

    let new_number = if number < 10_u8 {
        number
    } else {
        0
    };

    new_number
}
```

In here, we assign the `number` to the `new_number` variable if it's less than `10`, else we assign `0`.


## Loops
Loops are very useful for creating logics that executes repetitively whilst a specific condition stands.

Unlike other programming languages with multiple loop types (for, while etc), Cairo has just one type `loop`:

```cairo
use debug::PrintTrait;

fn main() {
    let counter = 1_u8;

    loop {
        if counter <= 10_u8 {
            break();
        } 

        counter.print();
    }
}
```

Running this program, will print out numerals 1-10 on the terminal, and stops immediately it gets to 10, as the condition stated while `counter` is less than or equal to 10.

The `break` keyword is used to end or break out of a loop. 

**NB:** You can prevent infinite loops by including a gas meter. The gas meter is a mechanism used to to limit the amount of computation that can be done in a program.