---
title: 14. 类型转换
tags:
  - cairo
  - starknet
  - into
  - try_into
---

# WTF Cairo极简教程: 14. 类型转换

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在这一章中，我们将探讨 Cairo 中的基本类型的类型转换。

## 类型转换

Cairo 利用 `Into` 和 `TryInto` 特质（Trait）提供了一种安全的类型转换机制，可以在整数类型（`u8`、`u16`等）和 `felt252` 之间进行转换。你首先需要导入这些特质：

```rust
// 导入 Into 特质
use traits::Into;
// 导入 TryInto 特质
use traits::TryInto;
use option::OptionTrait;
```

### into()

`Into` 特质提供了 `into()` 方法，用于在保证成功的情况下进行类型转换。从较小到较大类型的转换是保证成功的，例如 `u8` -> `u16` -> `u32` -> `u64` -> `u128` -> `felt252`。在使用 `into()` 时，必须注明新变量的类型。

```rust
#[external(v0)]
fn use_into(self: @ContractState){
    // from larger types to smaller types, success is guranteed
    // u8 -> u16 -> u32 -> u64 -> u128 -> felt252
    let x_u8: u8 = 13;
    let x_u16: u16 = x_u8.into();
    let x_u128: u128 = x_u16.into();
    let x_felt: felt252 = x_u128.into();
}
```

### try_into()

`TryInto` 特质提供了 `try_into()` 方法，在目标类型可能无法容纳源值时进行安全的类型转换。这通常发生在从较大转换到较小类型时：`u8` <- `u16` <- `u32` <- `u64` <- `u128` <- `felt252`。`try_into()` 方法返回一个 `Option` 类型，你需要调用 `unwrap()` 方法来获取新值。与 `into()` 类似，在使用 `try_into()` 时，必须明确注明新变量的类型。

```rust
#[external(v0)]
fn use_try_into(self: @ContractState){
    // from smaller types to smaller types, may fail
    // u8 <- u16 <- u32 <- u64 <- u128 <- felt252
    // try_into() returns an Option, you need to unwrap to get value
    let x_felt: felt252 = 13;
    let x_u128: u128 = x_felt.try_into().unwrap();
    let x_u16: u16 = x_u128.try_into().unwrap();
    let x_u8: u8 = x_u16.try_into().unwrap();
}
```

## 总结

在这一章中，我们介绍了 Cairo 中的类型转换。当转换保证成功时，应该使用 `into()` 方法；对于无法保证成功的情况，应使用 `try_into()` 方法。