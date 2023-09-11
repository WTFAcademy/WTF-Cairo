# WTF Cairo: 5. Function

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce functions in Cairo, covering `#[view]` and `#[external]` decorators for visibility control.

## Functions

Cairo shares similarities with Rust, as functions are declared using the `fn` keyword. Argument types are annotated just like variables, and when a function returns a value, the return type must be specified after an arrow `->`.

Here's an example of the `sum_two()` function. It accepts two `u128` type parameters and returns a `u128` value.

```rust
fn sum_two(x: u128, y: u128) -> u128 {
    return x + y;
}
```

In Rust-like languages, a function's return value is determined by the last expression in its body. While you can use the `return` keyword for an early exit and specify a value, most functions implicitly return the final expression. The `sum_two_expression()` function below behaves identically to the `sum_two()` function. Keep in mind that expressions do not end with semicolons `;`.

```rust
fn sum_two_expression(x: u128, y: u128) -> u128 {
    x + y
}
```

## Visibility

By default, functions are private, which means they can only be accessed internally. However, you can use `#[view]` or `#[external]` decorators to declare public functions.

### View

Functions with the `#[view]` decorator can be accessed externally. They can read storage variables but cannot change the contract's state, such as updating storage variables or emitting events.

```rust
// Declare storage variables
struct Storage{
    balance: u128,
    }

// View function: can read but not write storage variables
#[view]
fn read_balance() -> u128 {
    return balance::read();
}
```

### External

Functions with the `#[external]` decorator can also be accessed externally. Unlike `#[view]` functions, they can modify the contract's state, such as updating storage variables or emitting events.

```rust
// External: can read and write storage variables
#[external]
fn write_balance(new_balance: u128) {
    balance::write(new_balance);
}
```

## Summary

In this chapter, we explored functions in Cairo. While functions are private by default, you can utilize `#[view]` or `#[external]` decorators to control their visibility.