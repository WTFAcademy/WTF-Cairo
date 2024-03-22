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

    fn get_name(self: @TContractState) -> felt252;

    fn get_symbol(self: @TContractState) -> felt252;
    
    fn get_decimals(self: @TContractState) -> u8;
    
    fn get_total_supply(self: @TContractState) -> u256;

    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;

    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;

    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;

    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}
```

## 实现接口

让我们实现ERC20，在实现接口时，我们需要实现其中定义的所有函数，见`IERC20Impl`部分：

```rust
mod Errors {
    pub const APPROVE_FROM_ZERO: felt252 = 'ERC20: approve from 0';
    pub const APPROVE_TO_ZERO: felt252 = 'ERC20: approve to 0';
    pub const TRANSFER_FROM_ZERO: felt252 = 'ERC20: transfer from 0';
    pub const TRANSFER_TO_ZERO: felt252 = 'ERC20: transfer to 0';
    pub const BURN_FROM_ZERO: felt252 = 'ERC20: burn from 0';
    pub const MINT_TO_ZERO: felt252 = 'ERC20: mint to 0';
}

#[starknet::contract]
mod erc20 {
    use starknet::get_caller_address;
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use super::Errors;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        decimals: u8,
        total_supply: u256,
        balances: LegacyMap::<ContractAddress, u256>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>,
    }

    #[event]
    #[derive(Drop, PartialEq, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u256,
    }
    
    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252
    ) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(18);
    }

    #[abi(embed_v0)]
    impl IERC20Impl of super::IERC20<ContractState> {
        
        fn get_name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn get_symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }

        fn get_decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }

        fn get_total_supply(self: @ContractState) -> u256 {
            self.total_supply.read()
        }

        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            self.balances.read(account)
        }

        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            self.allowances.read((owner, spender))
        }

        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let sender = get_caller_address();
            InternalImpl::_transfer(ref self,sender, recipient, amount);
            true
        }

        fn transfer_from(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            let caller = get_caller_address();
            InternalImpl::_spend_allowance(ref self, sender, caller, amount);
            InternalImpl::_transfer(ref self, sender, recipient, amount);
            true
        }

        fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
            let caller = get_caller_address();
            InternalImpl::_approve(ref self, caller, spender, amount);
            true
        }
    }

    #[generate_trait]
    impl InternalImpl of erc20 {
        fn _transfer(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {
            assert(!sender.is_zero(), Errors::TRANSFER_FROM_ZERO);
            assert(!recipient.is_zero(), Errors::TRANSFER_TO_ZERO);
            self.balances.write(sender, self.balances.read(sender) - amount);
            self.balances.write(recipient, self.balances.read(recipient) + amount);
            self.emit(Transfer { from: sender, to: recipient, value: amount });
        }

        fn _spend_allowance(
            ref self: ContractState,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: u256
        ) {
            let allowance = self.allowances.read((owner, spender));
            InternalImpl::_approve(ref self, owner, spender, allowance - amount);
        }

        fn _approve(
            ref self: ContractState,
            owner: ContractAddress,
            spender: ContractAddress,
            amount: u256
        ) {
            assert(!owner.is_zero(), Errors::TRANSFER_FROM_ZERO);
            assert(!spender.is_zero(), Errors::APPROVE_TO_ZERO);
            self.allowances.write((owner, spender), amount);
            self.emit(Approval { owner, spender, value: amount });
        }

        fn _mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            assert(!recipient.is_zero(), Errors::MINT_TO_ZERO);
            let supply = self.total_supply.read() + amount;
            self.total_supply.write(supply);
            let balance = self.balances.read(recipient) + amount;
            self.balances.write(recipient, balance);
            self.emit(Transfer {from: contract_address_const::<0>(), to: recipient, value: amount});
        }

        fn _burn(ref self: ContractState, account: ContractAddress, amount: u256) {
            assert(!account.is_zero(), Errors::BURN_FROM_ZERO);
            let supply = self.total_supply.read() - amount;
            self.total_supply.write(supply);
            let balance = self.balances.read(account) - amount;
            self.balances.write(account, balance);
            self.emit(Transfer { from: account, to: contract_address_const::<0>(), value: amount});
        }
    }
}
```

该合约在remix中，编译没有问题，但declare时有时会报错，且`#[abi(embed_v0)]`不是外部函数，无法直接在remix中进行交互，所有代码文件中，将接口改为外部函数，且删除了事件。并且为了增加交互性，添加了mint和burn函数直接为调用者铸造和销毁代币，其余过程无修改。

## 总结

本章我们以 IERC20 为例，探讨了 Cairo 和 Solidity 中接口的异同。接口给合约规定了一组必须实现的属性和函数，方便其他合约与它们进行交互，而无需掌握它们的代码。
