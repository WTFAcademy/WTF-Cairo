# Functions

As in every programming language, a function in Cairo 1 is a block of code that performs a specific task. Functions are defined using the `fn` keyword, and like other languages, they take input parameters, execute some code, and return an output value. Functions are a fundamental building block of Cairo 1 and are used to organize code into reusable and modular units.

```rust
fn add_numbers(x: u32, y: u32) -> u32{
    let result = x + y;
    return result; 
}
```
In the example above, we defined a function as `fn add_numbers`, followed by parameter declarations `(x: u32, y: u32)` and the return type, denoted by `->` followed by the variable type. It's worth noting that in Cairo 1, the convention for naming variables and functions is `snake_case`, where words are all in lower case and separated by underscores.


Functions can have specific roles that can be denoted using attribute macros. These macros are defined using the `#[attribute]` syntax and are placed at the top of the function. Some commonly used attribute macros include the following:

- `#[contract]` 
- `#[constructor]` 
- `#[external]` 
- `#[view]` 
- `#[event]`
- `#[abi]`

---
### Defining your contract
Every Starknet contract is annotated at the beginning of the file with the `#[contract]` attribute. This attribute is used to declare the file as a Starknet contract.

```rust
#[contract]
mod ERC20 {
    // Your code
}
```

---
### Constructor function
In each smart contract, we can have only one constructor defined. The constructor is the first function that runs when the smart contract is deployed, and is denoted using the `#[constructor]` attribute.

```rust
#[contract]
mod ERC20 {

    struct Storage {
        name: felt252,
        symbol: felt252,
    }

    #[constructor]
    fn constructor(
        name_: felt252, 
        symbol_: felt252,
        ) 
        {
        name::write(name_);
        symbol::write(symbol_);
    }
}
```
In the example above, we take `name_` and `symbol_` as inputs and write these values to our `Storage`. To store a variable in a contract, we need to declare the Storage struct type (see [link to CH8 struct]). It is important to keep the name as `Storage` as this is a reserved name in Cairo 1.

---
### External functions
External functions in a contract are denoted using the #[external] attribute. These functions can be accessed or called by any other contract or user on Starknet, and can modify the state of a query. 


```rust
#[contract]
mod ERC20 {

    struct Storage {
        name: felt252,
        symbol: felt252,
        counter: u32,
    }

    #[constructor]
    fn constructor(
        name_: felt252, 
        symbol_: felt252,
        ) 
        {
        name::write(name_);
        symbol::write(symbol_);
    }

    #[external]
    fn increase_counter() {
        let current_counter = counter::read();
        counter::write(current_counter + 1_u32);
    }
}
```
In the example above, we defined a new `u32` type variable called `counter` in our storage. We then defined an `increase_counter()` function with the `#[external]` attribute, which indicates that this function can be called from outside the contract. Inside this function, we first read the current value of `counter` and then increment it by 1.

---
### View functions
View functions in a contract are denoted using the `#[view]` attribute. This function is similar to the `#[external]` function, however, the #[view] attribute indicates that this function is a read-only operation and does not modify the state of the contract.

```rust
#[contract]
mod ERC20 {

    struct Storage {
        name: felt252,
        symbol: felt252,
        counter: u32,
    }

    #[constructor]
    fn constructor(
        name_: felt252, 
        symbol_: felt252,
        ) 
        {
        name::write(name_);
        symbol::write(symbol_);
    }

    #[view]
    fn get_symbol() -> felt252 {
        symbol::read()
    }

    #[external]
    fn increase_counter() {
        let current_counter = counter::read();
        counter::write(current_counter + 1_u32);
    }
}
```
In the example above, we defined the `get_symbol()` function with the `#[view]` attribute. This function reads the `symbol` variable and returns its current value. 

---
### Internal Functions
Internal functions do not have any attribute macros defined at the top of their function. These functions are only accessible within the module or contract and are not available to the public. This level of encapsulation can help to improve the security and maintainability of your code by hiding implementation details and limiting access to sensitive parts of the code.

```rust
#[contract]
mod ERC20 {

    struct Storage {
        name: felt252,
        symbol: felt252,
        counter: u32,
    }

    #[constructor]
    fn constructor(
        name_: felt252, 
        symbol_: felt252,
        ) 
        {
        name::write(name_);
        symbol::write(symbol_);
    }

    #[external]
    fn reset_conter() {
        internal_function();
    }

    fn internal_function(){
        counter::write(0_u32);
    }
}
```
In the example above, we defined an internal function called `increment_counter(),` which can only be accessed by the `reset_counter()` external function. 

---
### Event functions
Event functions in a contract are denoted using the `#[event]` attribute. These functions are mechanisms that allow a contract to output information during its execution and can be used outside of Starknet.


```rust
#[contract]
mod ERC20 {

    #[event]
    fn Update_Counter(counter: u32){}

    struct Storage {
        name: felt252,
        symbol: felt252,
        counter: u32,
    }

    #[constructor]
    fn constructor(
        name_: felt252, 
        symbol_: felt252,
        ) 
        {
        name::write(name_);
        symbol::write(symbol_);
    }

    #[view]
    fn get_symbol() -> felt252 {
        symbol::read()
    }

    #[external]
    fn increase_counter() {
        let current_counter = counter::read();
        counter::write(current_counter + 1_u32);
        Update_Counter(counter::read());
    }
}
```
In the example above, we define the `Update_Counter()` function with the `#[event]` attribute. This function takes `counter` as input, and returns the current value when it's called.