---
title: 05. 函数
tags:
  - cairo
  - starknet
  - function
  - external
  - view
---

# WTF Cairo极简教程: 5. 函数

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍 Cairo 中的函数，包括可见性不同的`external`和`view`函数。

## 函数

函数是一门编程语言中不可或缺的基础构建块之一。一个函数一般包括：函数名、参数和返回值。在Cairo中，
1. 函数使用 `fn` 关键字来声明。
2. 函数名一般使用蛇形命名法，即都用小写字母，单词与单词直接使用`_`连接。
3. 在参数定义中必须同时给出给出参数名和参数类型。
4. 当函数有返回值时，使用箭头`->`来说明返回类型，不能命名返回值。
5. 如果有多个返回值，使用括号括起来。
6. 在调用函数时，可以直接使用`函数名(实际参数)`，也可以写`函数名(形式参数:实际参数)`，当形式参数与实际参数名字一致时，也可以省去形式参数的名字`函数名(:实际参数)`。

示例

```rust
fn add_felt(a: felt252,b: felt252) -> (felt252,u8){
    let c = a + b;
    return (c,1);
}

#[external(v0)]
fn test(self: @ContractState) -> felt252{
    let aa = 2;
    let bb = 3;
    let (c1,_d1) = add_felt(aa,bb);
    let (_c2,_d2) = add_felt(a: aa, b: bb);
    let a = 3;
    let b = 4;
    let (_c, _d) = add_felt(:a,:b);
    return c1;
}
```

当函数只有一个返回值时，可以使用`return`关键字或者表达式来退出函数。当使用表达式时，该表达式必须是最后一行，且不能以`；`结尾。

下面的 `sum_one()` 函数与 `sum_two()` 函数的行为完全相同。

```rust
fn sum_one(a: felt252,b: felt252) -> felt252{
    //或直接a + b
    let c = a + b;
    c  
}

fn sum_two(a: felt252,b: felt252) -> felt252{
    return a + b;
}
```

## 可见性

在无任何修饰时，函数是私有的，这意味着它们只能在内部访问。但是，你可以使用`#[abi(embed_v0)]`修饰器或`#[external(0)]`修饰器声明为公共函数。需要注意的是，使用`#[abi(embed_v0)]`时，无法直接在remix中的Interact中显露函数，直接交互，而使用`#[external(0)]`时，必须在参数中加入`self: @ContractState`或`ref self: ContractState`，说明该函数是`view`函数还是`External`函数。

### View

参数中包含`self: @ContractState`的函数是`view`函数。它们可以读取状态变量（`self.var_name.read()`），但不能更改状态变量，例如更新状态变量或释放事件。

```rust
#[storage]
struct Storage{
  balance: u128,
}

// view function: can read but not write storage variables.
#[external(v0)]
fn read_balance(self: @ContractState) -> u128 {
    return self.balance.read();
}
```

### External

参数中包含`ref self: ContractState`的函数也可以被外部访问。与 `view`函数不同，它们可以修改状态变量（使用`self.var_name.write(new_value)`），例如更新状态变量或释放事件。

```rust
// external: can read and write storage variables.
#[external(v0)]
fn write_balance(ref self: ContractState, new_balance: u128) {
    self.balance.write(new_balance);
}
```

## 总结

在本章中，我们探讨了Cairo中的函数。虽然函数默认为私有，但你可以使用`#[abi(embed_v0)]`或`#[external(v0)]`修饰器使它们具有外部访问性。
