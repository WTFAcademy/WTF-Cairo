# WTF Cairo: 8. Structure

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce `struct` (structure) in Cairo.

## Struct

A struct is a custom type that allows you to package together multiple related values that make up a meaningful group and assign a name to it.

### Storage struct
In Chapter 3, we used a special struct `Storage` to declare storage variables:

```rust
// Declare storage variables with struct
struct Storage{
    var_felt: felt252,
    var_bool: bool,
    var_uint: u8,
}
```

### Custom struct

We can define a custom `struct` in your contract with the `struct` keyword. Below, we have defined a `Student` struct:

```rust
// Create a custom struct
#[derive(Copy, Drop, Serde)] // ignore this line for now
struct Student {
    name: felt252,
    score: u128,
}
```

`#[derive(Copy, Drop, Serde)]` is a [macro](https://doc.rust-lang.org/book/ch19-06-macros.html) that adds more functionality to `struct`. We need `Copy` & `Drop` macros to automatically generate code for copying and dropping instances of the struct (manipulate them in functions), and `Serde` macro to use a struct as the return type in functions.

### Create struct

You can create a `struct` in functions with the following syntax:

```rust
// create struct
let student = Student{ name: '0xAA', score: 100_u128 };
// or
// let student: Student = Student{ name: '0xAA', score: 100_u128 };
```

### Read values

You can read a specific value from a `struct` with dot notation:

```rust
// get values from struct
let student_name = student.name;
let student_score = student.score;
```

### Struct array

`struct` can be used as an element in arrays.

```rust
// create an array of Student struct
let mut student_arr = ArrayTrait::<Student>::new();
student_arr.append(student);
```

### Struct as return type

You can use a `struct` as a return type of functions. To do this, you need the `Serde` macro. Serde stands for serializing and deserializing the data structure.

```rust
// create and return a Student struct
#[view]
fn create_struct() -> Student{
    // create struct
    let student = Student{ name: '0xAA', score: 100_u128 };
    return student;
}
```

## Summary

In this chapter, we introduced struct in Cairo, including how to define, create, and read values from them, and use them as return types in functions.