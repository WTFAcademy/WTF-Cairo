# WTF Cairo: 24. Generics

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

Generics are a powerful feature in Cairo that allow you to write code that can be reused with different types. This chapter will introduce you to generics in Cairo and show you how to leverage them to write flexible and reusable code.

*Please be aware that the use of generics could potentially increase the size of your Starknet contract.*

## What is Generics?

Generics in Cairo enable you to write code that can be parameterized by one or more types. By abstracting over types, you can create functions, structs, enums, and methods that work with different data types, without sacrificing type safety. 

## Generic Functions

Generic functions in Cairo are defined using type parameters. Type parameters are specified within angle brackets `< >` after the function name. For example `<T>`:

```rust
// Function to swap values with generic type
// Both 'a' and 'b' must be of the same type
fn swap<T>(a: T, b: T) -> (T, T) {
    (b, a)
}

fn test_swap() {
    // Example: swapping two u128 variables
    let a = 5_u128;
    let b = 10_u128;
    let swaped_u128 = swap(a, b);

    // Example: swapping two felt252 variables
    let c = 5;
    let d = 10;
    let swaped_felt = swap(c, d);
}
```

In the above code, `swap()` is a generic function that takes two value `a` and `b` of any type `T`. We can use this function to swap the value of `a` and `b`, given they are of the same type.

## Generic Structs and Enums

Similar to functions, you can create generic structs and enums. The type parameters are specified after the struct or enum name, within angle brackets `< >`. For example:

```rust
// generic struct
struct Pair<T> {
    first: T,
    second: T,
}

// generic enum
enum Option<T> {
    Some: T,
    None: (),
}
```

In the above code, `Pair` is a generic struct that can hold two values of the same type `T`. `Option` is a generic enum that can either hold a value of type `T` (Some) or represent no value (None).


## Implementing Generic Methods

You can also define generic methods within structs or enums. To do so, you need to specify the type parameter after the implementation name. Here's an example:

```rust
// generic trait
trait PairTrait<T> {
    fn new(a: T, b: T) -> Pair<T>;
}

// implementation generic method
impl PairImpl<T> of PairTrait<T> {
    fn new(a: T, b: T) -> Pair<T> {
        Pair { first: a, second: b }
    }
}
```

In the above code, `new` is a generic method that creates a new instance of the `Pair` struct with two values of type `T`.

## Constraints and Bounds

Cairo allows you to impose constraints on the types used with generics. Constraints ensure that the generic code only works with types that meet specific requirements. For example:

```rust
// generic trait
trait PairTrait<T> {
    fn new(a: T, b: T) -> Pair<T>;
    fn getFirst(self: @Pair<T>) -> T;
}

// implement Drop and Copy trait for Pair
impl PairDrop<T, impl TDrop: Drop<T>> of Drop<Pair<T>>;
impl PairCopy<T, impl TCopy: Copy<T>> of Copy<Pair<T>>;

// constrain on generic method
// only work with type with Copy trait
impl PairImpl<T, impl TCopy: Copy<T>> of PairTrait<T> {
    fn new(a: T, b: T) -> Pair<T> {
        Pair { first: a, second: b }
    }

    fn getFirst(self: @Pair<T>) -> T {
        return *self.first;
    }
}
```

In the above code, `PairImpl` is a generic implementation that only works with types that implement the `Copy` trait, enabling the `desnap` operation used in `getFirst` function.

## Summary

In this chapter, we provided an overview of generics in Cairo, covering generic functions, structs, enums, methods, constraints, and their benefits. With this knowledge, you can start leveraging generics in your Cairo program and unlock the full potential of code reuse and type safety.