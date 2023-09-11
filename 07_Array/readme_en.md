# WTF Cairo: 7. Array

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce arrays in Cairo, including their 8 member functions.

## Array

An array is a collection of objects of the same type `T`, stored in contiguous memory and can be accessed using an index. Array is not built natively in Cairo, you need to import the `ArrayTrait` library to use it.

```rust
use array::ArrayTrait;
```

An array object has 8 member functions, which we will introduce one by one. You need to import additional libraries to use them.

```rust
use option::OptionTrait;
use box::BoxTrait;
```

We will delve into Cairo libraries in later chapters.

### `new()`
You can use the `new()` function to create a new array:

```rust
use array::ArrayTrait;

#[view]
fn create_array() -> Array<felt252> {
    // new(): create new array
    let mut arr = ArrayTrait::new();

    // returning the array
    return arr;
}
```

### `append()`

To add elements to the array, you can use the `append()` function:

```rust
// append(): append an element to the end of an array
arr.append(1);
arr.append(2);
arr.append(3);
```

### `pop_front()`
To remove elements from the array, you can use the `pop_front()` function. To use it, you need to import the `OptionTrait` library with `use option::OptionTrait;`.

```rust
// pop_front(): removes the first element from the array 
let pop_element = arr.pop_front().unwrap();
```

### `at()` or `get()`

To access a certain element within the array, you can use either the `at()` or `get()` function. The difference is that the `get()` function returns an `Option`, which is an enumeration type that represents the possibility of a value being either present or absent. The Option type is a generic type, meaning that it can be used with any data type. To use `get()`, you need to import the `OptionTrait` and `BoxTrait` libraries.

```rust
// at(): get element at a particular index
let elem_one = *arr.at(0);

// get(): get element at a particular index, returns an Option type.
// Need to import OptionTrait and BoxTrait
let elem_two = *arr.get(1).unwrap().unbox();
```

### `len()`
You can use the `len()` function to get the current length of an array:

```rust
// len(): length of the array
let length = arr.len();
```

### `is_empty()`
The `is_empty()` function checks if an array is empty or not and returns a boolean value that is `true` if the array has no elements and `false` if the array has at least one element.

```rust
// is_empty(): checks if an array is empty or not and returns a boolean value
let empty_arr = arr.is_empty();
```

### `span()`
A span is a struct containing a snapshot of an array. You need to import the `SpanTrait` library to use it.

```rust
// span(): A span is a struct containing a snapshot of an array. 
// Need to import SpanTrait
let my_span = arr.span();
```

## Summary

In this chapter, we introduced arrays in Cairo and their 8 member functions, covering their usage and the required libraries for specific functions.