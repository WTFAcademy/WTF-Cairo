---
title: 19. 所有权-Move
tags:
  - cairo
  - starknet
  - ownership
  - move
---

# WTF Cairo极简教程: 19. 所有权-Move

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将探讨 Cairo 中的 `Move` 概念，即从一个变量向另一个变量转移所有权。

## 回顾 Cairo 中的所有权

在我们继续之前，让我们简要回顾一下 Cairo 中的所有权规则：

1. Cairo 中的每一个值都有一个 **所有者**（owner）。
2. 值在任一时刻有且只有一个所有者。
3. 当所有者（变量）离开作用域，这个值将被丢弃。
4. 如果一个值的所有权没有被 **转移**（move），它不能离开作用域。

在上一章中，我们探讨了规则 #3。在这一章中，我们将专注于规则 #1 和 #2。

## 理解 Move

在 Cairo 中，`Move` 指的是一个变量向另一个变量转移所有权的过程。当数据从一个变量分配给另一个变量或作为函数参数传递时，该数据的所有权被移动到新变量。移动之后，原始变量将变得无效。

这是一个简单的例子：

```rust
let x = ArrayTrait::<felt252>::new();  // x 成为数据的所有者
let y = x;                      // 所有权从 x 移动到 y
let z = x;              // 这将导致编译错误：error: Variable was previously moved
```

在上述代码中，`x` 最初拥有 `array`。当我们将 `x` 分配给 `y` 时，`array` 的所有权从 `x` 移动到 `y`。此次移动之后，`x` 不再有效，试图使用它（如 `let z = x` ）将导致编译错误。

以下是带有函数的另一个例子：

```rust
fn move_function(){
    let x = ArrayTrait::<felt252>::new();  // x 进入作用域

    takes_ownership(x);             // x 的值移动到函数中
                                    // ... 因此在这里不再有效

    let y = x;           // 这将导致编译错误，因为 x 不再有效

} // 这里，x 超出范围，但因为它的值被移动了，所以什么都没发生
```

在上述代码中，`x` 最初拥有 `array`。当我们将 `x` 传递给 `takes_ownership()` 函数时，`array` 的所有权从 `x` 移动到 `takes_ownership()`。此次移动后，`x` 不再有效，尝试使用它（如 `let y = x` ）将导致编译错误。

## `Copy` 和 `Drop`

Cairo 中的 `Copy` 和 `Drop` 特性直接与 `Move` 语义相关。如果没有正确理解这些特性，你的程序可能会经常遇到 `error: Variable not dropped.` 和 `error: Variable was previously moved.` 这样的错误。

### `Copy` 特性

实现 `Copy` 特性的类型不被 `Move` 语义约束。当一个 `Copy` 类型的值被分配给一个新的变量或传递给一个函数时，会创建一份原始值的副本传递给它，而不会转移原始值的所有权。Cairo 中，整数和 felt252 类型默认实现了 `Copy` 特性，下面的程序可以正常运行。

```rust
// uint 和 felt 默认实现 Copy 特性
let x = 5; // x 成为值 5 的所有者
let y = x; // 生成了一份 x 的值的拷贝，并绑定到 y
let z = x; // 又生成了一份 x 的值的拷贝，并绑定到 z
```

此外，你可以通过在类型定义上添加 `#[derive(Copy)]` 注解来在自定义类型上实现 Copy 特性。注意 Arrays 和 Dictionaries 不能被复制。以下是一个带有实现了 Copy 特性的 struct 的例子：

```rust
#[derive(Copy, Drop)]
struct Point {
    x: u128,
    y: u128,
}

// copy 结构体示例，Point 在合约中手动实现了 Copy 特性
fn copy_struct(){
    // Point 结构体实现了 Copy 特性
    let p1 = Point { x: 5, y: 10 };
    foo(p1); // p1 的所有权没有被移动，而是生成了一份拷贝传递给 foo()
    foo(p1); // p1 可以被再次使用
}

fn foo(p: Point) {
    // 对 p 做一些操作
}
```

### `Drop` 特性

Cairo 中有一个规则：一个值如果之前没被 `Move` 过，超出范围（Scope）的时候就会报错。实现 `Drop` 特性的类型被允许没被 `Move` 就超出范围。你可以通过向你的自定义类型添加 `#[derive(Drop)]` 属性来实现这一点。

```rust
#[derive(Drop)]
struct Point_Drop {
    x: u128,
    y: u128,
}

// drop 示例
fn drop_struct(){
    let p1 = Point_Drop { x: 5, y: 10 };
}
```

默认情况下，整数和 felt252 实现了 `Drop` 特性。所有自定义类型都需要标注 `Drop`，以便在它们超出范围时可以被正确地丢弃。

## 总结

在本节中，我们讨论了 Cairo 中的 Move 概念，包括 `Copy` 和 `Drop` 特性。理解这些基本原理将使你能够在 Cairo 中编写更高效且无bug的代码。在我们进入更复杂的主题之前，请确保你掌握了这些概念。