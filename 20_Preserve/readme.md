---
title: 20. 所有权 III 保留所有权
tags:
  - cairo
  - starknet
  - ownership
  - preserve
---

# WTF Cairo极简教程: 20. 所有权 III 保留所有权

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在 Cairo 中，当数据从一个变量分配到另一个变量或作为函数参数传递时，该数据的所有权会被转移。然而，有时我们希望能够操作数据但又保留其所有权。本章将探讨几种实现此目标的方法。

## 1. 通过函数返回所有权

你可以设计一个函数，让它将所有权返回给原变量。示例：

```rust
use array::ArrayTrait;

// 示例函数，移动然后返回所有权
fn return_function(){
    let mut x = ArrayTrait::<felt252>::new();  // x 进入作用域
    x = return_ownership(x);             // 返回 x 的值的所有权
    let y = x;     // 这行代码有效     
}

// 返回所有权的函数
fn return_ownership(some_array: Array<felt252>) -> Array<felt252> {
    some_array
}
```

虽然这种方法允许原变量重新获得所有权，但它需要你自己编写返回值，从而增加了代码的复杂性。

## 2. `Copy` 特性

如之前章节所述，如果一个类型实现了 `Copy` 特性，将其赋值给新变量或传递给函数时，将传递该值的副本，而不会转移所有权。

```rust
#[derive(Copy, Drop)]
struct Point {
    x: u128,
    y: u128,
}

// 示例，Point 结构体实现了 Copy 特性
fn copy_struct(){
    let p1 = Point { x: 5, y: 10 };
    let p2 = p1;
    let p3 = p1;
}
```

但请注意，`Array` 和 `Dictionary` 类型不能实现 `Copy` 特性。

## 3. 克隆

Cairo 允许你使用 `clone()` 方法手动创建一个变量的深复制（deep copy）。

```rust
use array::ArrayTrait;
use clone::Clone;
use array::ArrayTCloneImpl;

fn clone_example(){
    let x = ArrayTrait::<felt252>::new();  // x 进入作用域
    let y = x.clone();   // 深度复制 x 并绑定到 y
    let z = x;  // 这有效     
}
```

`clone()` 的缺点是深度复制一个变量可能会消耗大量的计算资源和 gas。

## 4. 引用

在 Cairo 中，你可以使用 `ref` 关键字创建一个值的可变引用（mutable reference）。这个引用在函数结束时会隐式返回，将所有权返回给调用上下文。

```rust
fn reference_example(){
    let mut x = ArrayTrait::<felt252>::new();  // x 进入作用域
    use_reference(ref x); // 将 x 的可变引用传递给函数
    let y = x; // 这有效     
}

fn use_reference(ref some_array: Array<felt252>) {
}
```

请注意，只有可变变量才可以使用 `ref` 关键字作为引用传递。我们将在下一章更深入地探讨这个话题。

## 5. 快照

Cairo 中的快照（snapshot）为某个时间点上的值提供了一个不可变的视图。当一个函数接受一个快照作为参数时，它并不接管底层值的所有权。你可以使用快照操作符 `@` 创建快照：

```rust
fn snapshot_example(){
    let x = ArrayTrait::<felt252>::new();  // x 进入作用域
    use_snapshot(@x); // 将 x 的快照传递给函数
    let y = x; // 这有效     
}

fn use_snapshot(some_array: @Array<felt252>) {
}
```

我们将在第22章更深入地探讨快照。

## 总结

在本章中，我们学习了几种在 Cairo 中保留所有权的情况下操纵数据的实用方法。掌握他们会让你写出更好的 Cairo 合约。