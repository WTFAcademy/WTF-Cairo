---
title: 02. 基本类型
tags:
  - cairo
  - starknet
  - felt
  - string
  - uint
---

# WTF Cairo极简教程: 2. Primitive Types

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章节中，我们将介绍 Cairo 中的基本数据类型，包括 `felt`、短字符串、布尔值和无符号整数。

## felt

`felt`（[域元素](https://en.wikipedia.org/wiki/Field_(mathematics))）是 Cairo 中最基本的数据类型，也是其他数据类型的构建基石。它可以表示 `252位`（31字节）的数据，支持加法、减法、乘法和除法等基本运算。

```rust
// Felt：域元素，可以表示 252 位整数
let x_felt = 666;
let y_felt = x_felt * 2;
```

## 短字符串

Cairo支持长度少于 31 个字符的短字符串。然而，它们实际上以 `felt` 的形式进行存储。

```rust
// 用 felt 表示短字符串
let x_shortString = 'WTF Academy';
```

## 布尔值

Cairo支持布尔数据类型，它有两种可能的值：`true` 或 `false`。

```rust
// 布尔值：真或假
let x_bool = true;
let y_bool = false;
```

## 整数

Cairo支持不同大小的无符号整数，包括 `u8`（uint8，无符号 8 位整数）、`u16`、`u32`、`u64` 和 `u128`。`uint256` 不是原生支持的，但您可以通过 `use integer::u256_from_felt252` 导入它。

```rust
// 无符号整数
// 无符号 8 位整数
let x_u8 = 1_u8;
let y_u8: u8 = 2;
// 无符号 16 位整数
let x_u16 = 1_u16;
// 无符号 32 位整数
let x_u32 = 1_u32;
// 无符号 64 位整数
let x_u64 = 1_u64;
// 无符号 128 位整数
let x_u128 = 1_u128;
// 无符号大小整数（通常用于表示索引和长度）
let value_usize = 1_usize;
```

## 总结

在本章中，我们探讨了Cairo中的基本类型，包括`felt`、短字符串、布尔值和无符号整数。在接下来的章节中，我们将通过示例更深入地了解这些类型。