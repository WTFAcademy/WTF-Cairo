---
title: 07. 数组
tags:
  - cairo
  - starknet
  - array
---

# WTF Cairo极简教程: 7. 数组

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍Cairo中的数组，包括它们的`8`个成员函数。

## 数组

数组是相同类型`T`的对象的集合，存储在连续的内存中，并可使用索引进行访问。数组在Cairo中并非原生支持，你需要导入`ArrayTrait`库来使用它。

```rust
use array::ArrayTrait;
```

数组对象有 8 个成员函数，我们将逐一介绍。你需要导入更多库来使用它们。

```rust
use option::OptionTrait;
use box::BoxTrait;
```

我们将在后续章节深入探讨 Cairo 库。

### `new()`

你可以使用`new()`函数创建一个新数组：

```rust
use array::ArrayTrait;

#[external(v0)]
fn create_array(self: @ContractState) -> Array<felt252> {
    // new(): 创建新数组
    let mut arr = ArrayTrait::new();

    // 返回数组
    return arr;
}
```

### `append()`

要向数组添加元素，可以使用`append()`函数：

```rust
// append(): 将元素追加到数组末尾
arr.append(1);
arr.append(2);
arr.append(3);
```

### `pop_front()`

要从数组中移除元素，可以使用`pop_front()`函数。要使用它，你需要用 `use option::OptionTrait;` 导入另一个`OptionTrait`库。

```rust
// pop_front(): 从数组中移除第一个元素
let pop_element = arr.pop_front().unwrap();
```

### `at()` 或 `get()`

要访问数组中的某个元素，可以使用`at()`或`get()`函数。区别在于`get()`函数返回一个`Option`，这是一种枚举类型，用于表示值可能存在或不存在。`Option`类型是一种通用类型，这意味着它可以与任何数据类型一起使用。要使用`get()`，你需要导入`OptionTrait`和`BoxTrait`库。

```rust
// at(): 获取特定索引处的元素
let elem_one = *arr.at(0);

// get(): 获取特定索引处的元素，返回 Option 类型。
// 需要导入 OptionTrait 和 BoxTrait
let elem_two = *arr.get(1).unwrap().unbox();
```

### `len()`

你可以使用`len()`函数获取数组的当前长度：

```rust
// len(): 数组的长度
let length = arr.len();
```

### `is_empty()`

`is_empty()`函数检查数组是否为空，如果数组没有元素，则返回`true`；如果数组至少有一个元素，则返回`false`。

```rust
// is_empty(): 检查数组是否为空并返回布尔值
let empty_arr = arr.is_empty();
```

### `span()`

跨度是包含数组快照的结构。你需要导入`SpanTrait`库来使用它。

```rust
// span(): 跨度是包含数组快照的结构。
// 需要导入 SpanTrait
let my_span = arr.span();
```

## 总结

在本章中，我们介绍了Cairo中的数组及其`8`个成员函数，包括它们的用法以及使用特定函数所需的库。