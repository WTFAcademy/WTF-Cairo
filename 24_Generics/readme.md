---
title: 24. 泛型
tags:
  - cairo
  - starknet
  - generics
  - option
---


# WTF Cairo极简教程: 24. 泛型

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在 Cairo 中，泛型（generics）是一种通用编程机制，允许你编写可重用的代码来处理不同类型的数据，而不必在每种情况下都重新编写相似的代码。本章将向你介绍 Cairo 中的泛型，并向你展示如何利用它们编写灵活且可重用的代码。

*请注意，使用泛型可能会增加 Starknet 合约的大小。*

## 什么是泛型？

在 Cairo 中，泛型（generics）是一种通用编程机制，允许你编写可重用的代码来处理不同类型的数据，而不必在每种情况下都重新编写相似的代码。使用泛型，你可以编写函数、结构体、枚举和方法，使它们能够接受不同类型的参数或具有不同类型的字段。这样的代码被称为“泛型代码”，因为它们在一般情况下适用于多个具体类型。

## 泛型函数

Cairo 中的泛型函数是使用类型参数定义的。类型参数在函数名后的尖括号 `< >` 中指定。例如 `<T>`：

```rust
// 交换值的泛型函数
// 'a' 和 'b' 必须为相同的类型
fn swap<T>(a: T, b: T) -> (T, T) {
    (b, a)
}

fn test_swap() {
    // 示例：交换两个 u128 变量
    let a = 5_u128;
    let b = 10_u128;
    let swaped_u128 = swap(a, b);

    // 示例：交换两个 felt252 变量
    let c = 5;
    let d = 10;
    let swaped_felt = swap(c, d);
}
```

在上述代码中，`swap()` 是一个接受任何类型 `T` 的两个值 `a` 和 `b` 的泛型函数。我们可以使用这个函数来交换 `a` 和 `b` 的值，只要它们是相同的类型。

## 泛型结构体和枚举

与函数类似，你也可以创建泛型结构体和枚举。类型参数在结构体或枚举名之后的尖括号 `< >` 中指定。例如：

```rust
// 泛型结构体
struct Pair<T> {
    first: T,
    second: T,
}

// 泛型枚举
enum OptionExample<T> {
    Some: T,
    None: (),
}
```

在上述代码中，`Pair` 是一个可以保存两个相同类型 `T` 的值的泛型结构体。`OptionExample` 是一个泛型枚举，可以保存任何类型 `T` 的值（Some）或表示没有值（None）。

## 实现泛型方法

你还可以在结构体或枚举中定义泛型方法。为此，你需要在实现名（Implementation Name）之后指定类型参数。

```rust
// 泛型特征
trait PairTrait<T> {
    fn new(a: T, b: T) -> Pair<T>;
}

// 实现泛型方法
impl PairImpl<T> of PairTrait<T> {
    fn new(a: T, b: T) -> Pair<T> {
        Pair { first: a, second: b }
    }
}
```

在上述代码中，`new()` 是一个泛型方法，会创建一个新的 `Pair` 结构体实例，该实例包含两个类型 `T` 的值。

## 约束

Cairo 允许你对用泛型的类型施加约束。约束确保泛型代码只与满足特定要求的类型一起工作。例如：

```rust
// 泛型特征
trait PairTrait<T> {
    fn new(a: T, b: T) -> Pair<T>;
    fn getFirst(self: @Pair<T>) -> T;
}

// 实现 Pair 的 Drop 和 Copy 特征
impl PairDrop<T, impl TDrop: Drop<T>> of Drop<Pair<T>>;
impl PairCopy<T, impl TCopy: Copy<T>> of Copy<Pair<T>>;

// 对泛型方法的约束
// 仅适用于具有 Copy 特征的类型
impl PairImpl<T, impl TCopy: Copy<T>> of PairTrait<T> {
    fn new(a: T, b: T) -> Pair<T> {
        Pair { first: a, second: b }
    }

    fn getFirst(self: @Pair<T>) -> T {
        return *self.first;
    }
}
```

在上述代码中，`PairImpl` 是一个仅与实现 `Copy` 特征的类型一起工作的泛型实现，它支持在 `getFirst()` 函数中使用的 `desnap` 操作。

## 总结

在这一章中，我们概述了 Cairo 中的泛型，包括泛型函数、结构体、枚举、方法、约束及其优点。有了这些知识，你可以开始在你的 Cairo 程序中利用泛型，解锁代码重用和类型安全的全部潜力。