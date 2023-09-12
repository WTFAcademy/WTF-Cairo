---
title: 13. Option
tags:
  - cairo
  - starknet
  - option
  - enum
---

# WTF Cairo极简教程: 13. Option

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将探讨 Cairo 中的 `Option` 枚举。它编码了一个值可能存在或不存在的情况，比其他编程语言中的 `Null` 值更安全。

## `Option` 枚举

Cairo 中的 `Option` 枚举表示一个值可能存在或不存在。它的定义如下：

```rust
enum Option<T> {
    Some: T,
    None: (),
}
```

`Option` 枚举可以通过其 `Some` 变体容纳任何类型的值，或者通过其 `None` 变体表示值的缺失。

`<T>` 语法表示泛型类型，目前我们只需要了解 `Option` 枚举的 `Some` 变体可以容纳任何类型的单个数据。我们将在后续章节中介绍泛型的概念。

`Option` 允许我们利用 Cairo 强大的类型系统来防止空值或未定义值错误。与其允许变量为空，Cairo 更鼓励使用 `Option` 枚举来表示值的缺失，增加了 Cairo 的安全性。

### 构建 `Option` 实例

构建 `Option` 变量非常简单，类似于创建其他枚举：

```rust
// 创建 Some Option
fn create_some() -> Option<u8> {
    let some_value: Option<u8> = Option::Some(1_u8);
    some_value
}

// 创建 None Option
fn create_none() -> Option<u8> {
    let none_value: Option<u8> = Option::None(());
    none_value
}  
```

### 解包 `Option`

你可以使用 `unwrap()` 方法提取 `Option` 的 `Some` 变体中的值。对于 `None` 变体，它会抛出错误。

```rust
// 使用 unwrap() 从 Some 中获取值
#[external(v0)]
fn get_value_from_some(self: @ContractState) -> u8 {
    let some_value = create_some();
    some_value.unwrap()
}
```

### 使用 `Option`

`Option` 枚举提供了两种方法来验证其内容是否为空：

- `is_some()`: 如果 `Option` 是 `Some` 变体，则返回 `true`。
- `is_none()`: 如果 `Option` 是 `None` 变体，则返回 `true`。

在以下示例中，如果 `option` 是 `Some`，则函数返回所包含的值，否则返回 `0`。

```rust
// 使用 is_some() 和 is_none() 处理选项
#[external(v0)]
fn handle_option_1(self: @ContractState, option: Option<u8>) -> u8 {
    // is_some() Returns `true` if the `Option` is `Option::Some`.
    // is_none()  Returns `true` if the `Option` is `Option::None`.
    if option.is_some() {
        option.unwrap()
    } else {
        0_u8
    }
}
```

或者，你可以使用 `match` 表达式处理 `Option`。

```rust
// 使用 match 处理选项
#[external(v0)]
fn handle_option_2(self: @ContractState, option: Option<u8>) -> u8 {
    match option{
        Option::Some(value) => value,
        Option::None(_) => 0_u8,
    }
}
```

## 总结

本章全面介绍了 Cairo 中的 `Option` 枚举。它用于编码值可能的存在或缺失，并增强 Cairo 程序的安全性和鲁棒性。