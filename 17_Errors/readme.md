---
title: 17. 异常处理
tags:
  - cairo
  - starknet
  - error
  - assert
  - panic
---

# WTF Cairo极简教程: 17. 异常处理

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将探索Cairo中的异常处理。通过这些技术，你将能够应对代码中潜在的异常，并通过异常消息提供反馈。

## 异常处理

Cairo提供了多种方法来处理代码中的异常。在本章中，我们将介绍其中的两种：`assert()`（推荐使用）和`panic()`。

### Assert

在Cairo中，`assert()`函数是被推荐使用的异常处理方法。它的功能类似于Solidity中的`require()`函数，接受两个参数：

1. `condition`：条件，在程序运行时预期为`true`。
2. `error message`：当`condition`为`false`时显示的异常消息（短字符串类型）。

`assert()`会在运行时验证给定条件是否为`true`，如果不是，它将抛出一个异常消息。

在下面的例子中，如果`input`不等于`0`，程序将被中断，并显示异常消息`'Error: Input not 0!'`。

```rust
// 如果输入为0，则使用assert抛出错误（推荐）
#[external(v0)]
fn assert_example(self: @ContractState, input: u128){
    assert( input == 0_u128, 'Error: Input not 0!');
}
```

### Panic

`panic()`函数是Cairo提供的另一种异常处理方法。与`assert()`不同，`panic()`在不验证任何条件的情况下突然中止程序运行。它接受一个 `felt252` 数组作为参数（异常消息）。

我们可以改写`assert_example()`函数，使用`panic()`抛出异常：

```rust
use array::ArrayTrait;
use traits::Into;
// 如果输入为0，则用panic抛出异常
// panic()以felt252数组作为参数
#[external(v0)]
fn panic_example(self: @ContractState, input: u128){
    if input == 0_u128 {
        let mut error_data = ArrayTrait::new();
        error_data.append(input.into());
        panic(error_data);
    }
}
```

此外，Cairo还提供了一个`panic_with_felt252()`函数。`panic_with_felt252()`和`panic`之间的唯一区别是`panic_with_felt252()`接受`felt252`作为参数，而不是数组。

让我们修改`assert_example()`以使用`panic_with_felt252()`抛出异常。
```rust
// 如果输入为0，则使用panic_with_felt252抛出异常
// panic_with_felt252()接受felt252作为参数
#[external(v0)]
fn panic_with_felt252_example(self: @ContractState, input: u128){
    if input == 0_u128 {
        panic_with_felt252('Error: Input not 0!');
    }
```

## 总结

在本章中，我们探索了Cairo中可用于处理异常的各种技术。推荐的方法是使用`assert()`。它的运作方式类似于Solidity中的`require()`，验证条件，并在条件不满足时抛出异常消息，帮助确保你的代码按预期运行。