---
title: 10. 映射和其他类型
tags:
  - cairo
  - starknet
  - mapping
---

# WTF Cairo极简教程: 10. 映射和其他类型

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍如何在Cairo中使用“映射”和其他常用类型。

## Mapping

`mapping`（映射）类型允许用户通过`键`来查询相应的`值`。例如，可以通过账户地址查询账户余额。在Cairo中，可以使用`LegacyMap`来创建映射。

在下面的示例中，我们在存储变量中创建了一个名为`balances`的映射。此映射存储了相应地址（键的`ContractAddress`类型）的余额（值的`u256`类型）。

```rust
// balances存储变量：从账户地址映射到u256
#[storage]
struct Storage {
    balances: LegacyMap::<ContractAddress, u256>,
}
```

你可以查询给定地址的余额。请注意，Cairo不像Solidity那样原生支持`address`类型。相反，你需要使用`use starknet::ContractAddress;`来导入它。

```rust
// 读取余额
#[external(v0)]
fn read_balance(self: @ContractState, account: ContractAddress) -> u256 {
    self.balances.read(account)
}
```

可以使用以下函数更新给定地址的余额：

```rust
// 更新余额
#[external(v0)]
fn write_balance(ref self: ContractState, account: ContractAddress, new_balance: u256){
    self.balances.write(account, new_balance);
}
```

## 总结

在本章中，我们讨论了如何在Cairo中使用`映射`类型和其他有用的类型来创建和管理智能合约中的键值对。这些概念将帮助你在Starknet上开发更高效、更有组织的智能合约。