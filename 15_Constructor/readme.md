---
title: 15. 构造函数
tags:
  - cairo
  - starknet
  - constructor
---

# WTF Cairo极简教程: 15. 构造函数

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将探索 Cairo 中的 `constructor` 构造函数，用于初始化合约的状态变量。

## 构造函数

和 Solidity 类似，Cairo 中的 `constructor` 是一个特殊的函数，它会在合约部署期间自动运行一次。它通常用于初始化合约的参数，例如设置 `owner` 地址：

```rust
#[starknet::contract]
mod owner{
    // import contract address related libraries
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    // storage variable
    #[storage]
    struct Storage{
        owner: ContractAddress,
        balance: felt252,
    }

    // set owner address during deploy
    #[constructor]
    fn constructor(ref self: ContractState, balance_: felt252) {
        self.owner.write(get_caller_address());
        self.balance.write(balance_);
    }

    #[external(v0)]
    fn balance_read(self: @ContractState) -> felt252 {
        self.balance.read()
    }
}
```

在上述合约中，我们在 `Storage` 结构体中定义了存储变量 `owner`和`balance`。然后在 `constructor` 函数中将这个 `owner` 初始化为调用者的地址，并在部署时传入一个`felt252`类型的值设置为`balance`余额。

![](./img/3-1.png)

### 规则

1. 构造函数必须名为`constructor`。
2. `constructor` 函数必须带有 `#[constructor]` 属性。
3. 每个合约最多可以有一个 `constructor`。

## 总结

在这一章节中，我们介绍了 Cairo 中的 `constructor` 函数。这个特殊的函数将在合约部署期间自动运行一次，为合约的状态变量设定初始状态。
