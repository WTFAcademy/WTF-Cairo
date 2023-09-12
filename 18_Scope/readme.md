---
title: 18. 所有权-作用域
tags:
  - cairo
  - starknet
  - ownership
  - scope
---

# WTF Cairo极简教程: 18. 所有权-作用域

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

我们将开始探讨Cairo中的所有权（Ownership）概念，本章从最基本的作用域（Scope）概念开始。

## 所有权

Cairo借鉴了Rust的所有权系统，以实现内存安全和高性能。

在Cairo中，每个数据都有一个“所有者”（owner），这个所有者的作用域决定了该值的生命周期。当所有者超出作用域时，Cairo会自动清理该值及其使用的任何资源，这个过程被称为“Drop”。

Cairo的所有权规则如下：

1. Cairo 中的每一个值都有一个 **所有者**（owner）。
2. 值在任一时刻有且只有一个所有者。
3. 当所有者（变量）离开作用域，这个值将被丢弃。
4. 如果一个值的所有权没有被 **转移**（move），它不能离开作用域。

## 作用域

为了理解规则#3，我们首先需要理解什么是“作用域”。

在Cairo中，作用域是您的代码中一个变量有效并可以使用的部分。它由一对花括号`{}`定义。当一个变量进入作用域时，它是有效的，直到它超出作用域。当它超出作用域时，其值被丢弃，任何它持有的内存或资源都被释放。

以下是函数作用域的一个简单例子：

```rust
fn scope_function() {
    let x = 'hello';   // x进入作用域

    // 这里可以使用x
    let y = x;

} // x在此处超出作用域并被丢弃
```

在这个例子中，变量`x`在声明的地方进入作用域。它在`scope_function()`函数的整个过程中保持在作用域内，然后在`scope_function()`的末尾超出作用域，它的值被丢弃。

在Cairo中，您可以在函数内创建嵌套作用域。嵌套作用域是通过新的一组花括号`{}`创建的。在内部作用域中创建的变量在外部作用域中不可访问。

```rust
fn scope_nested() {
    let outer_var = 'outer'; // outer_var在外部作用域内

    {
        let inner_var = 'inner'; // inner_var在内部作用域内
    }

    // inner_var在此处超出作用域

    // outer_var在此处仍然在作用域内
    let x = outer_var;
}
```

在所有这些例子中，您可以看到一个变量的作用域是由它声明的地方决定的。一旦一个变量超出作用域，Cairo会自动清理与该变量相关联的任何资源。

## 总结

在这一章中，我们介绍了Cairo的所有权规则和作用域的概念。我们将在下一章中介绍“移动”（Move）这个概念。