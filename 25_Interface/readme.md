---
title: 25. 接口/ABI
tags:
  - cairo
  - starknet
  - interface
  - abi
  - erc20
---

# WTF Cairo极简教程: 25. 接口/ABI

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在这一章节中，我们将介绍 Cairo 中的接口，并比较它与 Solidity 中接口的异同。

## 接口

在 Solidity 中，接口是一组没有函数体的函数的定义列表。接口给合约规定了一组必须实现的属性和函数，方便其他合约与它们进行交互，而无需掌握它们的代码。

让我们来看看 ERC20 代币标准的 `IERC20` 接口。这个接口概述了为遵循这个标准必须实现的函数。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom( address sender, address recipient, uint amount) external returns (bool);
}
```

你可以使用 `IERC20` 合约与遵循 ERC20 标准的合约进行交互，例如 `USDC`，而无需了解其代码。

另外，接口与合约ABI（Application Binary Interface）等价，可以相互转换。

## Cairo 中的接口

在 Cairo 中，接口是用 `#[starknet::interface]` 属性标记的 `trait`，功能与 Solidity 中类似。规则如下：

1. 必须明确声明函数的装饰器。
2. 其中的函数不应被实现。
3. 不应声明构造函数。
4. 不应声明状态变量。
5. 不应声明事件（与 Solidity 不同）。
6. 所有`view`函数需要包含参数`self: @TContractState`，`external`函数需要包含参数`ref self: TContractState`。

让我们用 Cairo 重写 Solidity 的 IERC20 合约：

```rust
use starknet::ContractAddress;

#[starknet::interface]
trait IERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;

    fn symbol(self: @TContractState) -> felt252;

    fn decimals(self: @TContractState) -> u8;

    fn total_supply(self: @TContractState) -> u256;

    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;

    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;

    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;

    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}
```

## 总结

本章我们以 IERC20 为例，探讨了 Cairo 和 Solidity 中接口的异同。接口给合约规定了一组必须实现的属性和函数，方便其他合约与它们进行交互，而无需掌握它们的代码。