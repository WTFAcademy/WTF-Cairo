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

Cairo 中的枚举由一组固定的命名值(变量)组成，或者可以说是多个子类型公用一个枚举类型，其中每个值都是不同的，并且具有特定的含义。使用枚举可以提高代码的可读性并减少错误。

Cairo中枚举的用法为：首先给出`derive`关键字表明该枚举对象的特性，然后使用`enum`关键字定义枚举，并在其后给出一个首字母大写的名称，最后在`{}`中给出枚举变量及其关联的值。

```rust
#[derive(Drop, Serde)]
enum Colors { 
    Red: (), 
    Green: (), 
    Blue: (), 
}
```

枚举还可以存储自定义类型数据。在以下示例中，我们定义了一个具有不同变量类型的`Actions`枚举：

```rust
#[derive(Copy, Drop)]
enum Actions { 
    Forward, 
    Backward: u128, 
    Stop: (felt252,felt252),
}
```

在此示例中，`Froward`没有关联任何值，`Backward`是单个u128，`stop`是两个felt252类型的元组。您甚至可以在枚举变量中定义strut或其他枚举。

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
    let backward = Actions::Backward((1_u128));
    let red = get_red(self);
}
```

### Enums storage

与结构体类似，状态变量中也可以使用枚举，其存储方式为顺序存储，开始位置与第一个变量有关，其后按照关联值和变量依次递增。

```rust
#[storage]
struct Storage{
    dir: Direction
}

#[derive(Drop, Serde, starknet::Store)]
enum Direction {
    North: u128,
    East: u128,
    South: u128,
    West: u128,
}
```

## 总结

在本教程中，我们介绍了如何定义枚举、创建枚举变量以及在函数中返回枚举。在之后学习模式匹配后，可以根据选择不同的枚举变量做出不同的应对。这些知识将帮助您在Cairo中创建更具可读性和抗错误性的代码。
