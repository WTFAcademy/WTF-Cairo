# WTF Cairo极简教程: 18. 所有权-范围

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 1.0.0`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.wtf.academy)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

我们将开始探讨Cairo中的所有权（Ownership）概念，本章从最基本的范围（Scope）概念开始。

## 所有权

Cairo借鉴了Rust的所有权系统，以实现内存安全和高性能。

在Cairo中，每个数据都有一个“所有者”（owner），这个所有者的范围决定了该值的生命周期。当所有者超出范围时，Cairo会自动清理该值及其使用的任何资源，这个过程被称为“Drop”。

Cairo的所有权规则如下：

1. Cairo中的每个值都有一个被称为其所有者的变量。
2. 一次只能有一个所有者。
3. 当所有者超出范围时，该值将被丢弃。

## 范围

为了理解规则#3，我们首先需要理解什么是“范围”。

在Cairo中，范围是您的代码中一个变量有效并可以使用的部分。它由一对花括号`{}`定义。当一个变量进入范围时，它是有效的，直到它超出范围。当它超出范围时，其值被丢弃，任何它持有的内存或资源都被释放。

以下是函数范围的一个简单例子：

```rust
fn scope_function() {
    let x = 'hello';   // x进入范围

    // 这里可以使用x
    let y = x;

} // x在此处超出范围并被丢弃
```

在这个例子中，变量`x`在声明的地方进入范围。它在`scope_example()`函数的整个过程中保持在范围内，然后在`scope_example()`的末尾超出范围，它的值被丢弃。

在Cairo中，您可以在函数内创建嵌套范围。嵌套范围是通过新的一组花括号`{}`创建的。在内部范围中创建的变量在外部范围中不可访问。

```rust
fn scope_nested() {
    let outer_var = 'outer'; // outer_var在外部范围内

    {
        let inner_var = 'inner'; // inner_var在内部范围内
    }

    // inner_var在此处超出范围

    // outer_var在此处仍然在范围内
    let x = outer_var;
}
```

在所有这些例子中，您可以看到一个变量的范围是由它声明的地方决定的。一旦一个变量超出范围，Cairo会自动清理与该变量相关联的任何资源。

## 总结

在这一章中，我们介绍了Cairo的所有权规则和范围的概念。我们将在下一章中介绍“移动”（Move）这个概念。