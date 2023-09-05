# WTF Cairo: 4. Variable Mutability

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce variable mutability in Cairo, including shadowing and the `let`, `mut`, and `const` keywords.

## Immutable Variables

For safety reasons, variables in Cairo are immutable by default, similar to Rust. Once a variable is assigned a value, it cannot be changed afterwards.

```rust
// In Cairo, variables are immutable by default
let x_immutable = 5;
// The following code will result in an error
// x_immutable = 10
```

## Mutable Variables

Mutability can be very useful and can make code more convenient to write. Like in Rust, you can use the `mut` keyword to declare mutable variables:

```rust
// Use the `mut` keyword to declare mutable variables
let mut x_mutable = 5;
x_mutable = 10;
```

## Constants

Similar to immutable variables, constants are values bound to a name and are not allowed to change. However, there are a few differences between constants and variables:

1. Constants are declared with the `const` keyword, not `let`.
2. The type of the value must be annotated.
3. Constants can only be declared and assigned in the global scope (within a contract and outside of functions).
4. You can't use `mut` with `const`.

```rust
const CONST_NUMBER: felt252 = 888;

#[view]
fn mutable_and_const() {
    // You can assign a const to a variable
    let y_immutable = CONST_NUMBER + 2;
}
```

## Shadowing

In Cairo, you can declare a new variable with the same name as a previous variable, effectively `shadowing` the previous one. This is different from using `mut`, as you are creating a new variable when you use the `let` keyword again. This allows you to change the type or mutability of the value while reusing the same name.

```rust
#[view]
fn shadow() -> felt252 {
    // Shadowing: you can declare a new variable with the same name as previous ones.
    let x_shadow = 5;
    // You can change the data type or mutability with shadowing
    let x_shadow = 10_u8;
    let mut x_shadow = 15;
    return x_shadow;
}
```

## Summary

In this chapter, we delved into variable mutability in Cairo, including shadowing and the `let`, `mut`, and `const` keywords.