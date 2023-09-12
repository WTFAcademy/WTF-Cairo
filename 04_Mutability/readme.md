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

出于安全原因，与 Rust 类似，Cairo 中的变量默认是不可变的。一旦为变量分配一个值，就不能再更改它。

```rust
// 在 Cairo 中，变量默认是不可变的
let x_immutable = 5;
// 下面的代码将导致错误
// x_immutable = 10
```

## 可变变量

可变性非常有用，可以使代码更方便编写。与 Rust 类似，您可以使用 `mut` 关键字声明可变变量：

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

```rust
const CONST_NUMBER: felt252 = 888;

#[external(v0)]
fn mutable_and_const(self: @ContractState) {
    // 可以将常量赋给变量
    let y_immutable = CONST_NUMBER + 2;
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