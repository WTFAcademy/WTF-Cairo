# WTF Cairo: 11. Control Flow

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will explore basic control flow structures (if-else and loops) in Cairo. Control flows enable the execution of specific code logic based on whether a condition is `true` or for repetitive tasks.

## If-else

If-else expressions allow you to execute code logic depending on certain conditions. Essentially, if a specific condition is met, one block of code will be executed, otherwise, a different block will be executed. 

`if` expressions start with the `if` keyword, followed by the condition to be met. We can include an `else` block specifying the logic to execute if the condition is not met. It is important to note that your condition must always evaluate to a `bool`, otherwise, the compiler will panic.

In the following example, the `is_zero()` function returns `true` if x is 0, and `false` otherwise.

```rust
// Example of if-else
#[view]
fn is_zero(x: u128) -> bool {
    // if-else
    if x == 0_u128 {
        true
    } else {
        false
    }
}
```

### else-if

You can create multiple conditions with else-if expressions, which is useful for handling complex logic.

```rust
// Example of else-if
#[view]
fn compare_256(x: u128) -> u8 {
    // else-if
    if x < 256_u128 {
        0_u8
    } else if x == 256_u128 {
        1_u8
    } else {
        2_u8
    }
}
```

### Return values from if-else

Since if-else is an expression, you can assign the results of an if-else expression to a variable. This may simplify your code.

```rust
// Example of return value from if-else
#[view]
fn is_zero_let(x: u128) -> bool {
    // Return value from if-else
    let isZero = if x == 0_u128 {
        true
    } else {
        false
    };
    return isZero;
}
```

## Loop

Loops are useful for creating logic that executes repetitively while a specific condition holds. Unlike other programming languages with multiple loop types (`for`, `while`, etc.), Cairo currently supports only one type of loop: `loop`.

The `loop` keyword will repeatedly execute a block of code until stopped by the `break` keyword.

```rust
// Example of loop
#[view]
fn sum_until(x: u128) -> u128 {
    let mut i: u128 = 1;
    let mut sum: u128 = 0;
    // loop
    loop {
        if i > x {
            break ();
        }
        sum += i;
    };
    return sum;
}
```

### Return values from loop

You can return values from a `loop` by adding an expression after the `break` keyword. In the example below, we return the value of `sum_i` after the loop is completed.

```rust
// Example of return value from loop
#[view]
fn sum_until_let(x: u128) -> u128 {
    let mut i: u128 = 1;
    let mut sum_i: u128 = 0;
    // Return value from loop
    let sum = loop {
        if i > x {
            break sum_i;
        }
        sum_i += i;
    };
    return sum;
}
```

## Summary

In this chapter, we covered the basic control flow structures in Cairo, including if-else expressions and loops.
