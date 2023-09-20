---
title: 26. 合约调度器
tags:
  - cairo
  - starknet
  - interface
  - abi
  - erc20
  - dispatcher
---

# WTF Cairo极简教程: 26. 合约调度器

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在这一章节中，我们将介绍Cairo中的合约调度器（Dispatcher），它由接口合约自动生成，帮助你调用其他合约，使用起来像Solidity中的接口（interface）。

## 合约调度器

在定义合约时，编译器会自动生成合约调度器，帮助你调用该合约。以我们上一讲中的`IMiniERC20`接口合约为例：

```rust
#[starknet::interface]
trait IMiniERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
}
```

它在编译时会生成一个合约调度器`IMiniERC20Dispatcher`和一个对应的trait `IMiniERC20DispatcherTrait`。`IMiniERC20Dispatcher`是一个`struct`，记录了合约地址，并包装了`call_contract_syscall`，方便开发者调用目标合约的函数。

```rust
#[derive(Copy, Drop, starknet::Store, Serde)]
struct IMiniERC20Dispatcher {
    contract_address: starknet::ContractAddress,
}

trait IMiniERC20DispatcherTrait<T> {
    fn name(self: T) -> felt252;
    fn symbol(self: T) -> felt252;
}

impl IMiniERC20DispatcherImpl of IMiniERC20DispatcherTrait<IMiniERC20Dispatcher> {
    fn name(
        self: IMiniERC20Dispatcher
    ) -> felt252 { 
        // 使用starknet::call_contract_syscall调用相应函数
    }
    fn symbol(
        self: IMiniERC20Dispatcher
    ) {         
        // 使用starknet::call_contract_syscall调用相应函数
    }
}
```

下面我们写一个合约，利用`Dispatcher`调用`mini_erc_20`合约。

```rust
#[starknet::contract]
mod call_mini_erc_20 {
    use starknet::ContractAddress;
    use super::IMiniERC20DispatcherTrait;
    use super::IMiniERC20Dispatcher;

    #[storage]
    struct Storage {
    }

    #[external(v0)]
    fn get_name(self: @ContractState, contract_address: ContractAddress) -> felt252 {
        IMiniERC20Dispatcher{ contract_address }.name()
    }

    #[external(v0)]
    fn get_symbol(self: @ContractState, contract_address: ContractAddress) -> felt252 {
        IMiniERC20Dispatcher{ contract_address }.symbol()
    }
}
```

需要注意的几点：
- 合约中，你需要在合约中引入`DispatcherTrait`和`Dispatcher`。
- 调用时，你需要使用`IMiniERC20Dispatcher`并传入目标合约地址。

## 总结

这一讲，我们介绍了Cairo中的合约调度器，由接口合约自动生成，方便你调用其他合约。