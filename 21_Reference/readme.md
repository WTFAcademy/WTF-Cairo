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

```rust
use array::ArrayTrait;

fn reference_example(){
    let mut x = ArrayTrait::<felt252>::new();  // x 进入作用域
    use_reference(ref x); // 将 x 的可变引用传递给函数
    let y = x; // 这是有效的    
}

fn use_reference(ref some_array: Array<felt252>) {
}
```

在 Cairo 中，只有可变变量可以用 `ref` 标记，因为它们在函数结束时被隐式更新。以下代码将无法编译：

```rust
// 不可变变量不能作为引用传递
let z = ArrayTrait::<felt252>::new(); 
use_reference(ref z); 
// error: Plugin diagnostic: ref argument must be a mutable variable.
```

## 总结

在这一章中，我们探讨了 Cairo 中的可变引用，进一步理解了该语言如何管理变量的所有权以及如何修改它们。