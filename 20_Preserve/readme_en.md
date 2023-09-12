# WTF Cairo: 20. Ownership III: Preserving Ownership

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In Cairo, when data is assigned from one variable to another or passed as a function argument, the ownership of that data is transferred. However, there are times when we want to manipulate data but preserving its ownership. This chapter explores several methods to achieve that.

## 1. Ownership Return via Functions

You can design a function to return ownership to the original variable. Consider the following example:

```rust
use array::ArrayTrait;

// Example function that moves and then returns ownership
fn return_function(){
    let mut x = ArrayTrait::<felt252>::new();  // x comes into scope
    x = return_ownership(x);             // ownership of x's value is returned
    let y = x;     // this line works     
}

// Function that returns ownership
fn return_ownership(some_array: Array<felt252>) -> Array<felt252> {
    some_array
}
```

While this method allows the original variable to regain ownership, it necessitates writing return values yourself, thereby increasing the complexity of your code.

## 2. The `Copy` Trait

As discussed previously, if a type implements the `Copy` trait, assigning it to a new variable or passing it to a function will not transfer the ownership of the value. Instead, a copy of the value is passed.

```rust
#[derive(Copy, Drop)]
struct Point {
    x: u128,
    y: u128,
}

// Example where Point struct, which implements the Copy trait, is copied
fn copy_struct(){
    let p1 = Point { x: 5, y: 10 };
    let p2 = p1;
    let p3 = p1;
}
```

However, please note that `Array` and `Dictionary` types cannot implement the `Copy` trait.

## 3. Cloning

Cairo allows you to use the `clone()` method to create a deep copy of a variable manually.

```rust
use array::ArrayTrait;
use clone::Clone;
use array::ArrayTCloneImpl;

fn clone_example(){
    let x = ArrayTrait::<felt252>::new();  // x comes into scope
    let y = x.clone();   // deeply copy x and bound it to y
    let z = x;  // this works     
}
```

The drawback of `clone()` is that deep copying a variable can be computationally expensive and consume more gas.

## 4. Reference

In Cairo, you can use the `ref` keyword to create a mutable reference to a value. This reference is implicitly returned at the end of the function, transferring back the ownership to the calling context.

```rust
fn reference_example(){
    let mut x = ArrayTrait::<felt252>::new();  // x comes into scope
    use_reference(ref x); // pass a mutable reference of x to function
    let y = x; // this works     
}

fn use_reference(ref some_array: Array<felt252>) {
}
```

Note that only mutable variables can be passed as a reference with `ref` keyword. We'll delve deeper into this topic in the next chapter.

## 5. Snapshots

Snapshots in Cairo provide an immutable view of a value at a certain point in time. When a function accepts a snapshot as an argument, it does not take ownership of the underlying value. You can use the snapshot operator `@` to create a snapshot:

```rust
fn snapshot_example(){
    let x = ArrayTrait::<felt252>::new();  // x comes into scope
    use_snapshot(@x); // pass a snapshot of x to function
    let y = x; // this works     
}

fn use_snapshot(some_array: @Array<felt252>) {
}
```

We will explore snapshots in greater depth in Chapter 22.

## Summary

In this chapter, we outlined several techniques in Cairo for manipulating data while preserving its ownership. This is crucial for maintaining data integrity and efficiency in your programs. 