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

结构体是一种自定义类型，它允许您将多个相关值组合成一个有意义的组，并为其分配一个名称。与元组一样，结构体中各个值可以时不同的类型，但与元组不同的是，您可以为每条数据命名。这就意味着结构体比元组更灵活：您不必依赖数据的顺序来指定或访问实例的值。

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

您可以将`struct`用作函数的返回类型。

```rust
// 创建并返回一个 Student 结构体
#[external(v0)]
fn create_struct(self: @ContractState) -> Student{
    // 创建结构体
    let student = Student{ name: '0xAA', score: 100_u128 };
    return student;
}
```

## Derivable Traits

[`derive`](https://book.cairo-lang.org/appendix-03-derivable-traits.html?highlight=derive#appendix-c---derivable-traits)是一个用于描述结构体特征的关键字，它为`struct`添加更多功能，可以使用的关键字有:`Drop`、`Destruct`、`Copy`、`Clone`、`PartialEq`和`Serde`。

`Drop`可以理解为一个析构函数，当一个变量要超出它的作用域，即到达生命周期的终点时，需要使用`Drop`，来讲这个变量占用的资源清理掉。如果没有`Drop`，编译器会捕获到，并抛出错误

```rust
struct drop1{
    name: u8
}

#[external(v0)]
fn test2(self: @ContractState) {
    //报错
    //note: Trait has no implementation in context: core::traits::Drop::structTest::structTest::structTest::drop1
    let _test1 = drop1{ name: 1};
}
```

`Destruct`与`Drop`类似，也用于释放内存，但更多用在结构体中存在mapping时。

`Copy`即拷贝，当该结构体需要将值传递给函数时，`Copy`会创建一个新变量，引用相同的值进行传递。需要注意的是，数组和字典无法进行复制。

```
#[derive(Copy,Drop)]
struct Copy1 {
    x: u128
}

#[derive(Drop)]
struct Copy2 {
    x: u128
}

#[external(v0)]
fn test2(self: @ContractState) {
    let copy_test1 = Copy1{ x: 1};
    let copy_test2 = Copy2{ x: 1};
    foo(copy_test1);
    //报错
    //"structTest::structTest::structTest::Copy1", found: "structTest::structTest::structTest::Copy2".
    foo(copy_test2);
}

fn foo(p: Copy1) {}
```

`Clone`是提供了clone方法，使得我们我们可以深度复制一个数据。

```rust
#[derive(Clone, Drop)]
struct clone1 {
    item: felt252
}

#[external(v0)]
fn test3(self: @ContractState) -> felt252 {
    let clone_first = clone1{item: 1};
    let clone_secone = clone_first.clone();
    return clone_secone.item;
}
```

`PartialEq`特征使得结构体内的变量可以使用`==`和`！=`操作符进行比较。

```rust
#[derive(PartialEq, Drop)]
struct partialEq1 {
    item: felt252
}

#[external(v0)]
fn test4(self: @ContractState) -> bool {
    let partialEq_first = partialEq1{item: 2};
    let partialEq_second = partialEq1{item: 2};
    return (partialEq_first == partialEq_second);
}
```

`Serde`提供了序列化特性的实现，允许您将您的结构体转化为一个数组（或相反）。

```rust
#[derive(Serde, Drop)]
struct Serde1 {
    item_one: felt252,
    item_two: u8,
}

#[external(v0)]
fn test5(self: @ContractState) -> Array<felt252> {
    let serde_struct = Serde1{item_one: 2, item_two:99};
    //创建一个可变空数组
    let mut serde_array = array![];
    let _serialized = serde_struct.serialize(ref serde_array);
    return serde_array;
}
```

## Storage struct
在第三章中，我们使用了一个特殊的结构体 `Storage` 来声明存储变量，而Storage中还可以添加自定义结构体,但需要为其添加上`starknet::Store`特性：

```rust
struct Storage{
    var_felt: felt252,
    var_bool: bool,
    var_student: Student,
}

#[derive(Copy, Drop, Serde, starknet::Store)]
struct Student {
    name: felt252,
    score: u128,
}
```

结构体在Starknet上按照顺序存储，而其首地址与该变量名有关，通过sn_keccak计算得到。例如，name存储在var_student.address()，score存储在var_student.address()+1。

## 总结

在本章中，我们介绍了Cairo中的结构体，包括如何定义、创建、从中读取值以及将它们作为函数的返回类型。
