# WTF Cairo: 2. Primitive Types

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce the primitive data types in Cairo 1, including `felt`, short strings, booleans, and unsigned integers.

## felt

`felt` ([field element](https://en.wikipedia.org/wiki/Field_(mathematics))) is the most fundamental data type in Cairo and serves as the building block for other data types. It can represent a `252-bit` (31 bytes) data and supports basic operations such as addition, subtraction, multiplication, and division. 

```rust
// Felt: Field Element, can represent a 252-bit integer
let x_felt = 666;
let y_felt = x_felt * 2;
```

## Short String

Cairo 1.0 supports short strings with a length of fewer than 31 characters. However, they are stored as `felt` internally.

```rust
// A short string is represented with felt
let x_shortString = 'WTF Academy';
```

## Boolean

Cairo 1.0 supports the boolean data type, which can have one of two possible values: `true` or `false`.

```rust
// Boolean: true or false
let x_bool = true;
let y_bool = false;
```

## Integers

Cairo 1 supports unsigned integers of different sizes, including `u8` (uint8, unsigned 8-bit integer), `u16`, `u32`, `u64`, and `u128`. `uint256` is not natively supported, but you can import it with `use integer::u256_from_felt252`.

```rust
// Unsigned Integers
// Unsigned 8-bit integer
let x_u8 = 1_u8;
let y_u8: u8 = 2;
// Unsigned 16-bit integer
let x_u16 = 1_u16;
// Unsigned 32-bit integer
let x_u32 = 1_u32;
// Unsigned 64-bit integer
let x_u64 = 1_u64;
// Unsigned 128-bit integer
let x_u128 = 1_u128;
// Unsigned size integer (typically used for representing indices and lengths)
let value_usize = 1_usize;
```

## Summary

In this chapter, we explored the primitive types in Cairo 1, including `felt`, short strings, booleans, and unsigned integers. We will delve deeper into these types with examples in the upcoming chapters.