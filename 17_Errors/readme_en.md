# WTF Cairo: 17. Error Handling

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will explore error handling in Cairo. With these techniques, you will be able to anticipate and respond to potential errors, providing useful feedback via error messages in your code.

## Error handling

Cairo offers several methods to handle potential errors in your code. In this chapter, we'll examine two of these, namely `assert()` (recommended) and `panic()`.

### Assert

The `assert()` function is the recommended method for handling errors in Cairo. It functions similarly to the `require()` function in Solidity and takes two arguments:

1. `condition`: a `boolean` operation expected to be true at runtime.
2. `error message`: a short string that displays when the `condition` is false.

`assert()` verifies whether a given condition is `true`, and if it isn't, it throws an error message.

In the example below, if `input` is not equal to `0`, the call will be reverted, and the error message `'Error: Input not 0!'` will be displayed.

```rust
// throw error if input is 0 with assert (recommended)
#[view]
fn assert_example(input: u128){
    assert( input == 0_u128, 'Error: Input not 0!');
}
```

### Panic

The `panic()` function is another method Cairo provides for error handling. Unlike `assert()`, `panic()` halts the function abruptly without verifying any condition. It takes a `felt252` array as arguments, which serves as an error message.

We can modify the `assert_example()` function to utilize `panic()` as shown below.

```rust
use array::ArrayTrait;
use traits::Into;
// Throw error if input is 0 with panic
// panic() accepts felt252 arrary as parameter
#[view]
fn panic_example(input: u128){
    if input == 0_u128 {
        let mut error_data = ArrayTrait::new();
        error_data.append(input.into());
        panic(error_data);
    }
}
```

Additionally, Cairo provides a `panic_with_felt252()` function. The only distinction between `panic_with_felt252()` and `panic` is that `panic_with_felt252()` takes a `felt252` as its argument.

Let's revise the `assert_example()` to use `panic_with_felt252()`.
```rust
// Throw error if input is 0 with panic_with_felt252
// panic_with_felt252() accepts felt252 as parameter
#[view]
fn panic_with_felt252_example(input: u128){
    if input == 0_u128 {
        panic_with_felt252('Error: Input not 0!');
    }
}
```

## Summary

In this chapter, we explored various techniques available in Cairo for handling errors. The recommended approach is to use `assert()`, which operates in a way similar to `require()` in Solidity. This function helps ensure your code runs as expected by verifying critical conditions and alerting you when they're not met.