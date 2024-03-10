---
title: 04. 变量可变性
tags:
  - cairo
  - starknet
  - variable
  - mut
  - const
---
# WTF Cairo极简教程: 4. 变量可变性

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍 Cairo 中的变量可变性，包括变量遮蔽和 `let`、`mut` 和 `const` 关键字。

## 不可变变量

Cairo使用的是不可变的内存模型（immutable memory model），即在默认情况下，Cairo 中的变量是不可变的。一旦为变量分配一个值，就不能再改变他，只能读取。

```rust
// 在 Cairo 中，变量默认是不可变的
let x_immutable = 5;
// 下面的代码将导致错误
// x_immutable = 10
```

编译时会出现以下错误：

```
error: Cannot assign to an immutable variable.
 --> 04_Mutability/mutability.cairo:12:9
        x_immutable = 10;
        ^**************^
```

## 可变变量

但是，可变性可能非常有用，并且可以使代码编写更方便，此时我们可以在变量名前添加mut来使它们可变。

前面说过，Cairo使用的是不可变的内存模型，变量存储在内存中时为什么可变？答案是：值是不可变的，但变量不是。与变量相关联的值可以被改变。为一个可变变量重新赋值本质上等同于重新声明它以引用另一个内存单元中的另一个值。这其中的过程由编译器来完成，而在代码层面，该变量并没有被重新声明，所以其类型是不能改变的。

```rust
// 使用 `mut` 关键字声明可变变量
let mut x_mutable = 5;
x_mutable = 10;
```

## 常量

与不可变变量类似，常量是绑定到名称且不允许更改的值。然而，常量和变量之间存在一些差异：

1. 常量使用 `const` 关键字声明，而不是 `let`。
2. 必须注解值的类型。
3. 常量只能在全局范围内声明和分配（在合约内且在函数外）。
4. 不能将 `mut` 与 `const` 一起使用。
5. 只能被设置为常量表达式，而不能是计算量表达式（除了consteval_int!（））。
6. 只能使用字面量给常量赋值(bool类型和ByteArray类型无法被设置为常量)。

注：常量命名约定是使用全大写字母，单词之间用下划线分隔。

```rust
const CONST_NUMBER: felt252 = 888;
const CONST_ONE_HOUR: u32 = consteval_int!(60 * 60);
// error: Function call is not supported outside of functions.
// error: Only literal constants are currently supported.
//const CONST_ONE_HOUR_SECOND: u32 = 60 * 60;

//error: Only literal constants are currently supported.
//const CONST_BOOL: bool = true;
//error: A literal of type core::bool cannot be created.
//error: Mismatched types. The type `core::bool` cannot be created from a numeric literal.
//const CONST_BOOL: bool = 1;

const CONST_CHAR: felt252 = 'C';
const CONST_CHAR_IN_HEX: felt252 = 0x43;
const CONST_STRING: felt252 = 'Hello world';
const CONST_STRING_IN_HEX: felt252 = 0x48656C6C6F20776F726C64;

//error: Only literal constants are currently supported.
//const CONST_LONG_STRING: ByteArray = "this is a string which has more than 31 characters";

#[external(v0)]
fn mutable_and_const(self: @ContractState) {
    // 可以将常量赋给变量
    let y_immutable = CONST_ONE_HOUR + 2;
}
```

## 遮蔽 Shadowing

在 Cairo 中，您可以使用与先前变量相同的名称声明一个新变量，从而有效地“遮蔽”先前的变量。这与使用 `mut` 不同，因为当您再次使用 `let` 关键字时，您实际上是创建了一个新变量。这允许您更改值的类型或可变性，同时重用相同的名称。

```rust
#[external(v0)]
fn shadow(self: @ContractState) -> felt252 {
    // shadow: you can declare a new variable with the same name as previous ones.
    let x_shadow = 5;
    // you can change the data type or mutability with shadowing
    let x_shadow = 10_u8;
    let mut x_shadow = 15;
    return x_shadow;
}
```

## 总结

在本章中，我们深入探讨了 Cairo 中的变量可变性，包括遮蔽和 `let`、`mut` 和 `const` 关键字。
