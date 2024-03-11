---
title: 06. 元组 Tuple
tags:
  - cairo
  - starknet
  - tuple
---

# WTF Cairo极简教程: 6. 元组 Tuple

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍在Cairo中如何使用元组，包括将元组作为函数参数和返回值。

## 元组

元组是将多个值组合在一起的方法，这些值可以是不同类型的。

元组使用中间逗号分隔值的圆括号`(,)`构造，每个元组本身都是具有类型签名（`T1`，`T2`，...）的值，其中`T1`、`T2`是其成员的类型。

对于一个元组，可以使用模式相同的多个变量来解构这个元组，或是在声明元组时指明值和类型并同时进行解包。

函数可以使用元组返回多个值，因为元组可以容纳任意数量的值。

值得注意的一点是，当元组被声明后，其容纳变量的数量和类型就无法再进行改变。

```rust
// 元组可用作函数参数和返回值。
#[abi(embed_v0)]
fn reverse(pair: (u32, bool)) -> (bool, u32) {
    // 解包：可以使用 `let` 将元组的成员绑定到变量。
    let (integer, boolean) = pair;
    return (boolean, integer);
}

#[external(v0)]
fn tuple(self: @ContractState)->(bool,u32) {
    let (x, y):(u32, bool) = (1, true);
    let (boolean, integer)=reverse((x,y));
    return (boolean, integer);
}
```

## 总结

在本章中，我们介绍了在 Cairo 中使用元组，涵盖了将元组作为函数参数和返回值的用法，以及如何解包它们。
