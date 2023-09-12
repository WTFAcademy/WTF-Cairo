---
title: 03. 局部和状态变量
tags:
  - cairo
  - starknet
  - variable
  - let
  - storage
---
# WTF Cairo极简教程: 3. 局部和状态变量

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍Cairo中的两种变量类型：局部变量`local`和状态变量`storage`。

## 局部变量（Local Variables）

`local` 变量在函数内声明。它们是临时的，不会存储在链上。

```rust
// local 变量
#[external(v0)]
fn local_var(self: @ContractState){
    // use `let` keywods to declare local variables 
    let local_felt: felt252 = 5;
    let local_bool = true;
    let local_uint = 1_u8;
}
```

## 状态变量（Storage Variables）

与Solidity类似，Cairo支持合约状态变量。它们会被记录在链上。你需要在合约中的一个名为 `Storage` 的特殊结构中声明状态变量，每个合约最多可以有一个 `Storage` 结构。

```rust
// 声明存储变量
#[storage]
struct Storage{
    var_felt: felt252,
    var_bool: bool,
    var_uint: u8,
    }
```

每个存储变量有两个成员函数：`read()` 和 `write()`。你可以用下面的方法在函数中读取和写入状态变量。

注意：这里的`self: @ContractState`代表`view`函数，`ref self: ContractState`代表`external`函数。

```rust
// 读取存储变量
#[external(v0)]
fn read_bool(self: @ContractState) -> bool {
    return self.var_bool.read();
}

// 写入存储变量
#[external(v0)]
fn write_bool(ref self: ContractState, bool_: bool) {
    self.var_bool.write(bool_);
}
```

## 总结

在本章中，我们介绍了Cairo中的`local`和`storage`变量。