---
title: 12. 模式匹配
tags:
  - cairo
  - starknet
  - match
  - enum
---

# WTF Cairo极简教程: 12. 模式匹配

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍如何利用 Cairo 中的 `match` 关键字进行模式匹配。它提供了一种强大且安全的机制来处理 enum 不同的值。

## `match` 表达式

Cairo 中的 `match` 属于控制流运算符，它允许你以清晰、简洁的方式处理枚举的不同可能值。它类似于其他语言中的 `switch` 语句，但表达能力更强，也更安全。

`match` 表达式由多个分支组成，每个分支包含一个模式和一个代码块，当给定的值符合该分支的模式时，就会执行该代码块。

以下是一个简单的 `match` 表达式的例子：

```rust
#[derive(Drop, Serde)]
enum Colors { 
    Red: (), 
    Green: (), 
    Blue: (), 
    }  

// return red color
#[external(v0)]
fn get_red(self: @ContractState) -> Colors {
    Colors::Red(())
}

// match pattern (Colors)
#[external(v0)]
fn match_color(self: @ContractState, color: Colors) -> u8 {
    match color {
        Colors::Red(()) => 1_u8,
        Colors::Green(()) => 2_u8,
        Colors::Blue(()) => 3_u8,
    }
}

// match color example, should return 1_u8
#[external(v0)]
fn match_red(self: @ContractState, ) -> u8 {
    let color = get_red(self);
    match_color(self, color)
}
```

此例中使用了 `match` 表达式来处理不同的 `Colors` 枚举变量。`match` 表达式会根据 `color` 的变体来执行相应的代码。

### 规则 

1. `match` 表达式中的每个分支都包括一个模式和其关联的代码，二者由 `=>` 运算符分隔。
2. `match` 是穷尽的，你必须考虑到所有 `enum` 所有可能的值。
3. `match` 分支的顺序必须与 `enum` 的顺序相同。
4. 如果一个分支的代码有多行，应使用 `{}` 来包裹这个分支的代码。

### 模式绑定

在 Cairo 中，模式绑定允许你解构与你的数据相关的数据类型，如枚举或结构体，并将他们的内部值绑定到变量。这在 `match` 表达式中特别有用，因为可以在不同模式下的代码块中使用其内部值。

```rust
#[derive(Drop, Serde)]
enum Actions { 
    Forward: u128, 
    Stop: (),
}

// return forward action
#[external(v0)]
fn get_forward(self: @ContractState, dist: u128) -> Actions {
    Actions::Forward(dist)
}

// match pattern with data (Actions)
#[external(v0)]
fn match_action(self: @ContractState, action: Actions) -> u128 {
    match action {
        Actions::Forward(dist) => {
            dist
        },
        Actions::Stop(_) => {
            0_u128
        }
    }
}

// match action example, should return 2_u128
#[external(v0)]
fn match_forward(self: @ContractState) -> u128 {
    let action = get_forward(self, 2_u128);
    match_action(self, action)
}
```

在这个例子中，`dist` 绑定了 `Actions` 枚举的 `Forward` 变体中的值：当 `action` 匹配 `Actions::Forward(dist)` 时，变量 `dist` 被赋予 `Forward` 变体内部的值，可以在匹配分支的代码块时中使用。此外，下划线 `_` 充当一个占位符，可以匹配任何值，但不将值绑定到变量。

## 总结

在这一章中，我们介绍了如何使用 `match` 关键字进行模式匹配，包括 `match` 表达式的穷尽性以及模式绑定的实用性，后者可以分解复杂的数据类型，将它们的内部部分绑定到变量，提高代码的可读性和效率。