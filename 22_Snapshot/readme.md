---
title: 22. 所有权 V 快照
tags:
  - cairo
  - starknet
  - ownership
  - snapshot
---

# WTF Cairo极简教程: 22. 所有权 V 快照

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将深入探讨 Cairo 中快照（snapshot）的概念，包括如何创建和使用快照，以及它们如何与 Cairo 的所有权系统交互。

## 使用快照

在 Cairo 中，快照是某一时刻值的不可变视图。你可以将一个值的快照传递给函数，同时保留原始值的所有权。

让我们以一个示例函数 `get_length()` 来说明，它计算数组的长度。此函数接收一个数组的快照作为参数，这使我们能够在调用上下文中保持数组的所有权：

```rust
#[external(v0)]
fn snapshot_example(self: @ContractState)->(usize,usize){
    let mut x = ArrayTrait::<felt252>::new();  
    let x_snapshot = @x;
    x.append(1);
    let first_length = get_length(x_snapshot);
    let second_length = get_length(@x);
    //返回结果为(0,1)
    return (first_length,second_length);    
}

// 获取快照的长度
fn get_length(some_array: @Array<felt252>) -> usize{
    some_array.len()
}
```

在上面的代码中：

- `get_length()` 函数使用快照操作符 `@` 将数组的快照作为参数。
- 我们使用 `@` 操作符创建 `x` 的快照，并将其传递给 `get_length()` 函数。
- 重要的是，由于我们将一个快照传递给了 `get_length()`，所以函数不应该改变数组。
- 数组的所有权仍然在 `snapshot_example` 函数中的 `x` 中，这演示了快照在保留所有权中的作用。

## 将可复制类型与快照结合使用

你可以使用 `desnap` 操作符 `*` 将快照转换回普通值。考虑一个场景，我们需要计算一个矩形的面积，但不希望在我们的计算函数中获取矩形的所有权,因为我们想在函数调用后再次使用矩形，那么您可以通过传递一个快照，然后使用`desnap`操作符`*`将快照转换为值。以下是你可以做到的方式：

```rust
#[derive(Copy, Drop)]
struct Rectangle {
    height: u64,
    width: u64,
}

#[external(v0)]
fn desnap_example(self: @ContractState) ->(u64,u64) {
    let mut rec = Rectangle { height: 5_u64, width: 10_u64 };
    let area_first = calculate_area(@rec);
    rec.height = 6_u64;
    rec.width = 11_u64;
    let area_second = rec.height * rec.width;
    return (area_first, area_second);
}

fn calculate_area(rec: @Rectangle) -> u64 {
    (*rec).height * (*rec).width
}
```

在 `calculate_area()` 函数中，我们使用 `desnap` 操作符 (`*`) 将快照转换回普通值。只有当类型是可复制的时候，这才是可能的。请注意，Cairo 中的数组不可复制，因此不能使用 `*` 操作符进行 'desnap'。

另外，在链式调用中，`*`操作符的优先级是最低的，所以需要使用括号，优先将snapshot的值取出。同时也可以避免与乘号(*)进行混淆。

## 总结

在这个教程中，我们探讨了 Cairo 中的快照，它可以使数据所有权的管理更为安全高效。




