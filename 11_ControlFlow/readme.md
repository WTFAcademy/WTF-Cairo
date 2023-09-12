---
title: 11. 控制流
tags:
  - cairo
  - starknet
  - flow
  - if-else
  - loop
---

# WTF Cairo极简教程: 11. 控制流

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将探讨Cairo中的控制流（if-else和循环）。控制流使你能够根据条件执行特定代码逻辑。

## If-else

If-else表达式允许你根据特定条件执行代码逻辑：如果满足特定条件，则执行一段代码，否则将执行另一段代码。在以下示例中，如果x为0，则`is_zero()`函数返回`true`，否则返回`false`。

```rust
// if-else 示例
#[external(v0)]
fn is_zero(self: @ContractState, x: u128) -> bool{
    // if-else
    if( x == 0_u128 ){
        true
    } else {
        false
    }
}
```

`if`表达式以`if`关键字开始，后跟要满足的条件。我们可以在`if`之后包含一个`else`块，指定条件不满足时要执行的逻辑。值得注意的是，你的条件必须始终为`bool`，否则编译器将报错。

### else-if

你可以使用else-if表达式创建多个条件，这对于处理复杂逻辑非常有用。

```rust
// else-if 示例
#[external(v0)]
fn compare_256(self: @ContractState, x: u128) -> u8{
    // else-if
    if( x < 256_u128 ){
        0_u8
    } else if (x == 256_u128 ){
        1_u8
    } else {
        2_u8
    }
}
```

### 从if-else返回值

因为if-else是一个表达式，所以你可以将if-else表达式的结果分配给一个变量。这可以简化你的代码。

```rust
// 示例：从if-else返回值
#[external(v0)]
fn is_zero_let(self: @ContractState, x: u128) -> bool{
    // return value from if-else
    let isZero = if( x == 0_u128 ){
        true
    } else {
        false
    };
    return isZero;
}
```

## 循环

循环允许你在特定条件下反复执行代码。与其他具有多种循环类型（`for`，`while`等）的编程语言不同，Cairo目前仅支持一种循环类型：`loop`。

`loop`关键字将反复执行一段代码，直到见到`break`关键字才停止。

```rust
// 循环示例
#[external(v0)]
fn sum_until(self: @ContractState, x: u128) -> u128{
    let mut i: u128 = 1;
    let mut sum: u128 = 0;
    // loop
    loop {
        if (i > x) {
            break ();
        } 
        sum += i;
        i += 1;
    };
    return sum;
}
```


### 从循环返回值

你可以通过在`break`关键字后添加表达式从循环返回值。在下面的示例中，循环完成后，我们返回`sum_i`的值。

```rust
// 示例：从循环返回值
#[external(v0)]
fn sum_until_let(self: @ContractState, x: u128) -> u128{
    let mut i: u128 = 1;
    let mut sum_i: u128 = 0;
    // return value from loop
    let sum = loop {
        if (i > x) {
            break sum_i;
        } 
        sum_i += i;
        i += 1;
    };
    return sum;
}
```

## 总结

在本章中，我们介绍了Cairo中的基本控制流结构，包括if-else表达式和循环。