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

Cairo 中的 `match` 属于控制流运算符，它允许你将一个值与一系列模式进行比较，然后根据匹配哪个模式来执行代码。模式可以由数值，变量名，通配符和许多其他元组构成。它允许你以清晰、简洁的方式处理枚举的不同可能值。它类似于其他语言中的 `switch` 语句，但表达能力更强，也更安全。

`match` 表达式的构造首先是`match`关键字，后跟一个表达式，表明进行匹配的值。接下来是match分支，每个分支包含一个模式和一个代码块,二者由 `=>` 运算符分隔，当给定的值符合该分支的模式时，就会执行该代码块。

以下是一个简单的 `match` 表达式的例子：

```rust
#[derive(Drop, Serde)]
enum Colors { 
    Red, 
    Green, 
    Blue, 
}

// 返回 red color
fn get_red() -> Colors {
    Colors::Red
}

// 模式匹配 (Colors)
fn match_color(color: Colors) -> u8 {
    match color {
        Colors::Green => 1_u8,
        Colors::Blue => 2_u8,
        Colors::Red => 3_u8,
    }
}

// Color匹配例子，返回1_u8
#[external(v0)]
fn match_red(self: @ContractState) -> u8 {
    let color = get_red();
    match_color(color)
}
```

此例中使用了 `match` 表达式来处理不同的 `Colors` 枚举变量。`match` 表达式会根据 `color` 的变体来执行相应的代码。

### `_`和`|`

当我们的模式无法穷尽所有可能时，可以使用`_`。`_`是一个特殊模式，匹配任何值且不绑定到那个值，通常作为match表达式的最后一个分支的模式。可以认为是`switch`中的`default`。

而`|`则是或运算符，一次匹配多个模式，可以帮助我们缩减代码量。

```rust
fn match_color_second(color: Colors) -> u8 {
    match color {
        Colors::Green | Colors::Blue => 1_u8,
        _ => 2_u8,
    }
}

#[external(v0)]
fn match_test(self: @ContractState) -> (u8,u8) {
    let color_1 = Colors::Red;
    let color_2 = Colors::Blue;
    let u_1 = match_color_second(color_1);
    let u_2 = match_color_second(color_2);
    return (u_1,u_2);
}
```

### 模式绑定

在 Cairo 中，模式绑定允许你解构与你的数据相关的数据类型，如枚举或结构体，并将他们的内部值绑定到变量。这在 `match` 表达式中特别有用，因为可以在不同模式下的代码块中使用其内部值。

```rust
#[derive(Drop, Serde)]
enum Actions { 
    Forward: u128, 
    Stop,
}

// 返回 forward 动作
fn get_forward(dist: u128) -> Actions {
    Actions::Forward(dist)
}

// match pattern with data (Actions)
fn match_action(action: Actions) -> u128 {
    match action {
        Actions::Forward(dist) => {
            dist
        },
        Actions::Stop => {
            0_u128
        }
    }
}

// 匹配行动例子, 返回 2_u128
#[external(v0)]
fn match_forward(self: @ContractState) -> u128 {
    let action = get_forward(2_u128);
    match_action(action)
}
```

在这个例子中，`dist` 绑定了 `Actions` 枚举的 `Forward` 变体中的值：当 `action` 匹配 `Actions::Forward(dist)` 时，变量 `dist` 被赋予 `Forward` 变体内部的值，可以在匹配分支的代码块时中使用。

### 匹配其他类型

Cario还可以进行其他类型的匹配，包括元组，felt252和整数变量。当匹配felt252和整数变量时，存在一些限制：

1. 只支持能够适配到单个felt252的整数（即u256不被支持）。

2. 第一个分支必须是0。

3. 每个分支必须覆盖一个连续的段，与其他分支连续。

```rust
 #[external(v0)]
fn match_tuple(self: @ContractState) -> bool {
    let color = Colors::Red;
    let action = Actions::Forward(2_u128);
    match (color, action) {
        (Colors::Blue, _) => true,
        (_, Actions::Stop) | (Colors::Red, Actions::Forward) => true,
        (_, _) => false,
    }
}

#[external(v0)]
fn match_felt252(self: @ContractState, value: u8) -> u8 {
    match value {
        0 => 1,
        _ => 0,
    }
}
```

## 总结

在这一章中，我们介绍了如何使用 `match` 关键字进行模式匹配，包括 `match` 表达式的穷尽性以及模式绑定的实用性，后者可以分解复杂的数据类型，将它们的内部部分绑定到变量，提高代码的可读性和效率。
