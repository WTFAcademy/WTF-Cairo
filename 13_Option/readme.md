# WTF Cairo: 13. Option

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will explore `Option` enum in Cairo. It encodes the possibility of a value's presence or absence, and has advantages over `Null` values in other programming languages.

## `Option` enum

Cairo's `Option` enum denotes a value that might be present or absent. It's defined as follows:

```rust
enum Option<T> {
    Some: T,
    None: (),
}
```

The `Option` enum can hold any type of value via its `Some` variant, or it may indicate the absence of a value with its `None` variant.

The `<T>` syntax represents generic types, a concept we will introduce in later chapters. For now, it suffices to understand that the `Some` variant of the `Option` enum can hold a single piece of data of any type.

`Option` allows us to use Cairo's powerful type system to prevent null or undefined value errors. Instead of allowing a variable to be null, Cairo encourages the use of the `Option` enum to signify the absence of a value. This is a key part of Cairo's emphasis on safety and preventing runtime errors.

### Constructing `Option` Instances

Constructing `Option` variables is straightforward and similar to creating other enums:

```rust
// create Some Option
fn create_some() -> Option<u8> {
    let some_value: Option<u8> = Option::Some(1_u8);
    some_value
}

// create None Option
fn create_none() -> Option<u8> {
    let none_value: Option<u8> = Option::None(());
    none_value
}  
```

### Unwrapping an `Option`

You can extract the value held in the `Some` variant of an `Option` using the `unwrap()` method. It throws an error for `None` variants.

```rust
// get value from Some using unwrap()
#[view]
fn get_value_from_some() -> u8 {
    let some_value = create_some();
    some_value.unwrap()
}
```

### Working with `Option`

The `Option` enum provides two methods to verify its content:

- `is_some()`: Returns `true` if the `Option` is a `Some` variant.
- `is_none()`: Returns `true` if the `Option` is a `None` variant.

In the following example, the function returns the contained value if the `option` is `Some` and `0` otherwise.

```rust
// handle option with is_some() and is_none()
#[view]
fn handle_option_1(option: Option<u8>) -> u8 {
    if option.is_some() {
        option.unwrap()
    } else {
        0_u8
    }
}
```

Alternatively, you can use a `match` expression to handle an `Option`.

```rust
// handle option with match
#[view]
fn handle_option_2(option: Option<u8>) -> u8 {
    match option{
        Option::Some(value) => value,
        Option::None(_) => 0_u8,
    }
}
```

## Summary

This chapter provided a comprehensive introduction to the `Option` enum in Cairo, a powerful tool for encoding the possible absence or presence of values, thereby enhancing the safety and robustness of your Cairo programs.