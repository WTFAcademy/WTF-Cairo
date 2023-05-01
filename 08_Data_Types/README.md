# Data Types

In Cairo 1, data types are a classification of data that specifies the kind of value that a particular variable or object can hold.



## Arrays
An array is a collection of elements of the same type that is used to represent a fixed-size sequence of elements that can be accessed using an index.


### `new()`
To create a new array, you can use the `new()` function: 
```rust
use array::ArrayTrait;

fn create_array() -> Array<felt252> {

    // creating an empty array
    let mut a = ArrayTrait::new(); 

    // returning the array
    a
}
```
Note: Arrays must be defined as mutable  since we will be performing various functions such as append, remove, etc. 

### `append()`
To add elements to the array, you can use the `append()` function:
```rust
use array::ArrayTrait;

fn create_array() -> Array<felt252> {

    // creating an empty array
    let mut a = ArrayTrait::new(); 

    // appending elements
    a.append(0);
    a.append(1);
    a.append(1);

    // returning the array
    a
}
```
### `pop_front()`
To remove elements from the array, you can use the `pop_front()` function:  

```rust
use array::ArrayTrait;
use option::OptionTrait;

fn create_array() -> Array<felt252> {

    // creating an empty array
    let mut a = ArrayTrait::new(); 

    // appending elements
    a.append(0);
    a.append(1);
    a.append(1);

    // removes the first element from the array 
    a.pop_front().unwrap();

    // returning the array
    a
}
```
In order to remove the first element from the array, you will need to import a new library called `option::OptionTrait`. 

### `at()` or `get()`
The access a certain element within the array you can use either `at()` or `get()` function. The difference is that the `get()` function returns an `Option` which is an enumeration type that is used to represent the possibility of a value being either present or absent. The Option type is a generic type, which means that it can be used with any data type.

```rust
use array::ArrayTrait;
use option::OptionTrait;
use box::BoxTrait;

fn create_array() -> Array<felt252> {

    // creating an empty array
    let mut a = ArrayTrait::new(); 

    // appending elements
    a.append(0);
    a.append(1);

    let elem_one = a.at(0_usize);
    let elem_two = a.get(1_usize).unwrap().unbox();

    // returning the array
    a

}
```
### `len()`
The retrieve the current length of an array you can use the `len()` function: 
```rust
use array::ArrayTrait;

fn create_array() -> Array<felt252> {

    // creating an empty array
    let mut a = ArrayTrait::new(); 

    // appending elements
    a.append(0);
    a.append(1);

    // length of the array
    let length = a.len();

    // returning the array
    a
}
```
### `is_empty()`
The `is_empty()` function checks if an array is empty or not and returns a boolean value that is `true` if the array has no elements and `false` if the array has at least one element.
```rust
use array::ArrayTrait;

fn create_array() -> Array<felt252> {

    // creating an empty array
    let mut a = ArrayTrait::new(); 

    // appending elements
    a.append(0);

    // length of the array
    if (a.is_empty()) {
        // array is empty
    } else {
        // array not empty
    }

    // returning the array
    a
}
```

### `span()`
A span is a struct containing a snapshot of an array. 
```rust
use array::ArrayTrait;
use array::SpanTrait;

fn main() {

    // creating an empty array
    let mut a = ArrayTrait::new(); 

    // appending elements
    a.append(0);

    // creating a span 
    let my_span = a.span();
}
```
## Structs
A struct is a collection of values that can contain different data types. It provides a way to group the values together and define them as a single entity.

```rust
#[derive(Copy, Drop)]
struct Collection{
    lucky_number: u8,
    is_true: bool,
    unlucky_number: u16,
}

fn main() {
    let new_collection = Collection{lucky_number: 7_u8, is_true: true, unlucky_number: 420_u16};
}

```
In the example above, we defined a `Collection` struct that contains three fields of different types. We used the `#[derive(Copy, Drop)]` attribute macro to automatically generate code for copying and dropping instances of the struct.

In the `main()` function, we created a new instance of the `Collection` struct called `new_collection`, with values for each of its fields. 


## Constants
Constants are values that are immutable and not allowed to be changed. They are declared globally using the `const` keyword, and their notation type is `UPPER_CASE`.

```rust
const LUCKY_NUMBER: u8 = 7_u8;
```

## Tuples
A tuple is a collection of values that can contain different data types. The number of values in a tuple is fixed and cannot be changed once the tuple is created. 

```rust
fn main() {
    let tuple: (u8, bool, u16) = (7_u8, true, 420_u16);
}
```

The tuple can also be destructured into individual variables, as shown below:

```rust
fn main() {
    let tuple: (u8, bool, u16) = (7_u8, true, 420_u16);

    let (lucky_number, is_true, unlucky_number) = tuple;
}
```



