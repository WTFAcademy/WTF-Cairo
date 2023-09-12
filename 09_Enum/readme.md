---
title: 09. 枚举
tags:
  - cairo
  - starknet
  - enum
---

# WTF Cairo极简教程: 9. 枚举

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章节中，我们将介绍在Cairo中使用`enum`（枚举）的方法。

## Cairo 中的枚举

Cairo 中的枚举是一种定义一组命名值（变量）的方法，每个值都有一个关联的数据类型。使用枚举可以提高代码的可读性并减少错误。

使用`enum`关键字定义枚举，并在其后给出一个首字母大写的名称。

```rust
#[derive(Drop, Serde)]
enum Colors { 
    Red: (), 
    Green: (), 
    Blue: (), 
}
```

与Rust不同，Cairo枚举中的变量具有关联类型。在上面的示例中，`Colors`枚举中的`Red`、`Green`和`Blue`变量具有单位类型`()`。在以下示例中，我们定义了一个具有不同变量类型的`Actions`枚举：

```rust
#[derive(Copy, Drop)]
enum Actions { 
    Forward: u128, 
    Backward: u128, 
    Stop: (),
}
```

### 创建枚举变量

您可以使用以下语法创建枚举变量：

```rust
let forward = Actions::Forward((1_u128));
```

### 在函数中返回枚举

枚举可以在函数中返回：

```rust
// 返回红色
#[external(v0)]
fn get_red(self: @ContractState) -> Colors {
    Colors::Red(())
}

#[external(v0)]
fn create_enum(self: @ContractState) {
    // create enum
    let forward = Actions::Forward((1_u128));
    let red = get_red(self);
}
```

## 总结

在本教程中，我们介绍了如何定义枚举、创建枚举变量以及在函数中返回枚举。这些知识将帮助您在Cairo中创建更具可读性和抗错误性的代码。