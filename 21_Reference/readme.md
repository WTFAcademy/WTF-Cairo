---
title: 21. 所有权 IV 引用
tags:
  - cairo
  - starknet
  - ownership
  - reference
---

# WTF Cairo极简教程: 21. 所有权 IV 引用

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

让我们继续学习所有权的相关内容，在本章中，我们将学习如何使用 Cairo 中的引用。

## 引用

在 Cairo 中，如果我们希望一个函数更改参数的值同时保留其所有权，就可以使用可变引用（mutable reference）。可变引用在函数执行结束时会被隐式返回，允许函数修改它的值，并且该值在调用函数的作用域中仍可使用。

你可以使用 `ref` 关键字创建可变引用。

需要注意的是，只有当变量被mut修饰为可变变量时，才能使用`ref`修饰符作为可变引用传递，并且在传递结构体时需要满足序列化(`Serde`)特性。

```rust
#[derive(Drop,Serde)]
struct Rectangle {
    height: u64,
    width: u64,
}

#[external(v0)]
fn reference_example(self: @ContractState)-> Rectangle {
    let mut rec = Rectangle { height : 3, width : 10};
    use_reference(ref rec);
    return rec;
}

fn use_reference(ref rec: Rectangle) {
    let temp = rec.height;
    rec.height = rec.width;
    rec.width = temp;
}

#[external(v0)]
fn reference_array(self: @ContractState)-> Array<felt252> {
    let mut arr = ArrayTrait::new();
    fill_array(ref arr);
    return arr;
}

fn fill_array(ref arr: Array<felt252>) {
    arr.append(11);
    arr.append(22);
    arr.append(33);
}
```

引用其实可以认为是两个move操作，首先将传入的变量move到调用的函数中，再隐式将所有权move回来。

## 总结

在这一章中，我们探讨了 Cairo 中的可变引用，进一步理解了该语言如何管理变量的所有权以及如何修改它们。
