---
title: 08. 结构体
tags:
  - cairo
  - starknet
  - struct
---

# WTF Cairo极简教程: 8. 结构体

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍Cairo中的`struct`（结构体）。

## 结构体

结构体是一种自定义类型，它允许您将多个相关值组合成一个有意义的组，并为其分配一个名称。

### Storage struct
在第三章中，我们使用了一个特殊的结构体 `Storage` 来声明存储变量：

```rust
// 使用结构体声明存储变量
#[storage]
struct Storage{
    var_felt: felt252,
    var_bool: bool,
    var_uint: u8,
}
```

### 自定义结构体

我们可以在您的合约中使用`struct`关键字定义自定义`struct`。下面我们定义了一个`Student`结构体：

```rust
// 创建自定义结构体
#[derive(Copy, Drop, Serde)] // 暂时忽略此行
struct Student {
    name: felt252,
    score: u128,
}
```

`#[derive(Copy, Drop, Serde)]` 是一个[宏](https://doc.rust-lang.org/book/ch19-06-macros.html)，它为`struct`添加更多功能。我们需要`Copy`和`Drop`宏以自动生成用于复制和删除结构体实例的代码（在函数中操作它们），以及`Serde`宏将结构体用作函数的返回类型。

### 创建结构体

您可以使用以下语法在函数中创建`struct`：

```rust
// 创建结构体
let student = Student{ name: '0xAA', score: 100_u128 };
// 或者
// let student: Student = Student{ name: '0xAA', score: 100_u128 };
```

### 读取值

您可以使用点表示法从`struct`中读取特定值：

```rust
// 从结构体中获取值
let student_name = student.name;
let student_score = student.score;
```

### 结构体数组

`struct`可以用作数组中的元素。

```rust
// 创建 Student 结构体的数组
let mut student_arr = ArrayTrait::<Student>::new();
student_arr.append(student);
```

### 结构体作为返回类型

您可以将`struct`用作函数的返回类型。为此，您需要`Serde`宏。Serde代表序列化和反序列化数据结构。

```rust
// 创建并返回一个 Student 结构体
#[external(v0)]
fn create_struct(self: @ContractState) -> Student{
    // 创建结构体
    let student = Student{ name: '0xAA', score: 100_u128 };
    return student;
}
```

## 总结

在本章中，我们介绍了Cairo中的结构体，包括如何定义、创建、从中读取值以及将它们作为函数的返回类型。