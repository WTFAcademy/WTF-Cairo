# WTF Cairo: 14. Type Conversion

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will explore type conversion for primitive types in Cairo. 

## Type Conversion

Cairo provides a robust mechanism for type conversion between integer types (`u8`, `u16`, ...) and `felt252` by leveraging the `Into` and `TryInto` traits. To access these powerful tools, you first need to import these traits:

```rust
// Import the Into trait
use traits::Into;
// Umport the TryInto trait
use traits::TryInto;
use option::OptionTrait;
```

### into()

The `Into` trait provides an `into()` methods for type conversion when success is guaranteed. Conversions from smaller to larger types are guaranteed to succeed: `u8` -> `u16` -> `u32` -> `u64` -> `u128` -> `felt252`. When using `into()`, you must annotate the type of the new variable.

```rust
#[view]
fn use_into(){
    // From smaller to larger types, success is guaranteed
    // u8 -> u16 -> u32 -> u64 -> u128 -> felt252
    let x_u8: u8 = 13;
    let x_u16: u16 = x_u8.into();
    let x_u128: u128 = x_u16.into();
    let x_felt: felt252 = x_u128.into();
}
```

### try_into()

The `TryInto` trait provides a `try_into()` methods for safe type conversion when the target type might not fit the source value. This typically occurs during conversions from larger to smaller types: `u8` <- `u16` <- `u32` <- `u64` <- `u128` <- `felt252`. The `try_into()` method returns an `Option` type, which you need to `unwrap` to access the new value. Similar to `into()`, when using `try_into()`, the type of the new variable must be clearly annotated.

```rust
#[view]
fn use_try_into(){
    // From larger to smaller types, conversion might fail
    // u8 <- u16 <- u32 <- u64 <- u128 <- felt252
    // try_into() returns an Option, you need to unwrap to get the value
    let x_felt: felt252 = 13;
    let x_u128: u128 = x_felt.try_into().unwrap();
    let x_u16: u16 = x_u128.try_into().unwrap();
    let x_u8: u8 = x_u16.try_into().unwrap();
}
```

## Summary

In this chapter, we introduced type conversion in Cairo. We learned that when conversion success is guaranteed, the `into()` method is your go-to; for instances where success isn't assured, the `try_into()` method comes into play, ensuring safe and reliable conversions.