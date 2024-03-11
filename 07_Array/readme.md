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

数组是相同类型`T`的对象的集合，存储在连续的内存中，并可使用索引进行访问。在当前版本(Cairo2.6.0)，数组的相关库都已变为原生支持，可以直接使用，包括ArrayTrait,BoxTrait,OptionTrait,SpanTrait库。

数组对象有 9 个成员函数，包括`new()`、`append()`、`pop_front()`、`pop_front_consume()`、`get()`、`at()`、`len()`、`is_empty()`和`span()`，我们将逐一介绍。

### `new()`

你可以使用`new()`函数创建一个新数组,如果有需要，可以在实例化数组时在数组内传递预期的项类型，或者显示定义变量类型。

```rust
let mut arr = ArrayTrait::new();
let mut arr = ArrayTrait::<felt252>::new();
let mut arr:Array<u128> = ArrayTrait::new();
```

### `append()`

要向数组末尾添加元素，可以使用`append()`函数：

```rust
#[abi(embed_v0)]
fn create_array() -> Array<felt252> {
    // new(): 创建新数组
    let mut arr = ArrayTrait::<felt252>::new();
    // append(): 将元素追加到数组末尾
    arr.append(1);
    arr.append(2);
    arr.append(3);

    // 返回数组
    return arr;
}   
```

注意：`Array`类型的返回值包括数组长度和数组中元素的值。

### `pop_front()`

使用`pop_front()`函数，可以从数组中移除元素，但只能移除最前面的元素。

```rust
#[external(v0)]
fn pop_front(self: @ContractState) -> (Array<felt252>,felt252,felt252) {
    let mut arr = create_array();
    let x = arr.pop_front().unwrap();
    let y = arr.pop_front().unwrap();
    return (arr, x, y);
}
```

### `pop_front_consume()`

`pop_front_consume()`与`pop_front()`函数类似，可以移除数组最前面的元素，但其返回值为`(新数组,被删除的值)`。

```rust
#[external(v0)]
fn pop_front_consume(self: @ContractState) -> (Array<felt252>,felt252,Array<felt252>,felt252) {
    let mut arr = create_array();
    let mut arr1 = create_array();
    let (arr1, x) = arr1.pop_front_consume().unwrap();
    let (arr, _y) = arr.pop_front_consume().unwrap();
    let (arr, z) = arr.pop_front_consume().unwrap();
    return (arr1,x,arr,z);
}
```

注意：`pop_front_consume()`处理过的原数组无法继续使用，例如`let (arr1, x) = arr.pop_front_consume().unwrap();`,此时arr无法在之后的代码中进行操作。

### `at()` 或 `get()`

要访问数组中的某个元素，可以使用`at()`或`get()`函数。区别在于`get()`函数返回一个`Option<Box<@T>>`，这是一种枚举类型，这意味着如果数组中存在指定索引的元素，它将返回一个Box类型；如果元素不存在，get返回None。而`at()`函数直接返回指定索引处元素的快照(span)，如果索引超出界限，则会报错。

```rust
#[external(v0)]
fn get(self: @ContractState) -> felt252 {
    let mut arr = create_array();
    //这种写法，索引超出时也会报错
    let x = *arr.get(1).unwrap().unbox();
    return x;
}

#[external(v0)]
fn at(self: @ContractState) -> felt252 {
    let mut arr = create_array();
    let x = *arr.at(0);
    return x;
}
```

### `len()`

你可以使用`len()`函数获取数组的当前长度，其返回值为usize(u32)类型。

```rust
#[external(v0)]
fn len(self: @ContractState) -> (u32,u32) {
    let mut arr = create_array();
    let l1 = arr.len();
    let _x = arr.pop_front().unwrap();
    let l2 = arr.len();
    return (l1,l2);
}
```

### `is_empty()`

`is_empty()`函数检查数组是否为空，如果数组没有元素，则返回`true`；如果数组至少有一个元素，则返回`false`。

```rust
#[external(v0)]
fn is_empty(self: @ContractState) -> (bool,bool) {
    let mut arr = create_array();
    let empty_1 = arr.is_empty();
    let _x1 = arr.pop_front().unwrap();
    let _x2 = arr.pop_front().unwrap();
    let _x3 = arr.pop_front().unwrap();
    let empty_2 = arr.is_empty();
    return (empty_1,empty_2);
}
```

### `span()`

span时一个结构体，代表了一个数组的快照，旨在提供对数组元素的安全受控的访问，而不修改原始数组。

```rust
#[external(v0)]
fn span(self: @ContractState) -> Span<felt252> {
    let mut arr = create_array();
    let my_span = arr.span();
    return my_span;
}
```

## 拷贝

如果想拷贝一个数组，可以使用`clone()`函数。这会在另一个地址中复制出与原对象一样的数组。

```rust
#[external(v0)]
fn clone(self: @ContractState) -> Array<felt252> {
    let mut arr = create_array();
    let mut arr1 = arr.clone();
    return arr1;
}  
```


## 总结

在本章中，我们介绍了Cairo中的数组及其`9`个成员函数，包括它们的用法，还有数组的拷贝。
