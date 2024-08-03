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

在本章节中，我们将介绍 Cairo 中的基本数据类型，包括 `felt`、无符号整数、布尔值和字符串。

Cairo是一种静态类型语言，这意味着它在编译时必须知道所有变量的类型。编译器也可以根据值及其用法推断所需的类型。

```rust
// 以下两种定义方法效果相同
let x：felt252 = 6;
let x = 6;
```

## felt

`felt`（[域元素](https://en.wikipedia.org/wiki/Field_(mathematics))）是 Cairo 中最基本的数据类型，也是其他数据类型的构建基石。它的取值范围为0&le;x&lt;P中的整数，其中P为一个非常大的素数， ${2^{251}} + 17 \cdot {2^{192}} + 1$  。当值超过这个范围时，会发生溢出（或下溢），结果会模P。

```rust
fn overflow(self: @ContractState) -> felt252 {
    let x: felt252 = -1;
    //0x800000000000011000000000000000000000000000000000000000000000000
    //=2^251+17⋅2^192
    return x;
}
```

`felt`支持加法、减法、乘法和除法等基本运算。与整型不同，'felt'在除法时会返回满足条件的整数,例如7/3,整型的结果通常为2，而felt252的结果x则会满足(x*3)%P=7这个式子。

值得注意的是，在Cairo2.6.0版本中,felt252被禁止使用除法。

```rust
error: Trait has no implementation in context: core::traits::Div::<core::felt252>
    let x: felt252 = 5 / 2;
                     ^***^
```

## 整数

Cairo支持不同大小的无符号整数，包括 `u8`（uint8，无符号 8 位整数）、`u16`、`u32`、`u64` 、 `u128` 和 `uint256` 。在使用时，在数字的后面标记，例如'1_u8'。需要注意的是，u256是一个有两个字段的结构： `u256{ low : u128 , high : u128 }`。

```rust
// 无符号整数
// 无符号 8 位整数
let x_u8 = 1_u8;
// 无符号 16 位整数
let x_u16 = 1_u16;
// 无符号 32 位整数
let x_u32 = 1_u32;
// 无符号 64 位整数
let x_u64 = 1_u64;
// 无符号 128 位整数
let x_u128 = 1_u128;
// 无符号 256 位整数
let x_256 = u256 { low: 10, high : 0};
// 无符号大小整数（通常用于表示索引和长度）
let value_usize = 1_usize;
```

整数支持加法、减法、乘法、除法和余数的运算。

## 布尔值

Cairo支持布尔数据类型，它有两种可能的值：`true` 或 `false`。在声明时不允许使用整数文本（即0而不是false）进行声明。

```rust
// 布尔值：真或假
let x_bool = true;
let y_bool = false;
```


## 字符串

Cairo没有字符串的原生类型，但提供了两种处理它们的方法：使用简单引号的短字符串和使用双引号的ByteArray。

### 短字符串

短字符串是一个ASCII字符串，其中每个字符都按照一个字节编码（具体参考[`ASCII表`](https://www.asciitable.com/)）。

Cairo使用`felt`的形式存储短字符串，因此仅支持长度少于 31 个字符的短字符串(31*8=248位,这是适合251位的最大8倍数)。

```rust
let x_char = 'C';
let x_char_in_hex = 0x43;

let x_string = 'WTF Academy';
let x_string_in_hex = 0x5754462041636164656D79;
```

### 字节数组字符串

在Cairo2.4.0中添加ByteArray结构后，不再局限于31个字符。这些字符串用双引号书写：

```rust
// 用 felt 表示短字符串
let x_long_string: ByteArray = "this is a string which has more than 31 characters";
```

## 总结

维护良好的编程习惯很重要，其中之一就是对未使用的变量进行特殊处理，在变量名前加'_'，以标识这一点。这样不仅有助于代码的可读性，也方便后续的代码审查和维护

在本章中，我们探讨了Cairo中的基本类型，包括`felt`、无符号整数、布尔值和字符串。在接下来的章节中，我们将通过示例更深入地了解这些类型。
