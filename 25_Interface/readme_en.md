# WTF Cairo: 24. Interface/ABI

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---


We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will compare the interface in Solidity and Cairo, a key element that facilitates interactions between different contracts.

## Interface

In Solidity, an interface is a list of function definitions without implementation. An interface enforces a defined set of properties and functions on a contract and allows you to interact with other contracts without having their code.

Let's examine the interface of the ERC20 token standard `IERC20`. This interface outlines the functions that must be implemented to comply with this standard.

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

You can use the `IERC20` contract to interact with the contracts following the ERC20 standard, such as `USDC`, without knowing its code.

## Interface in Cairo

In Cairo, an interface is represented by a `trait` marked with the #[abi] attribute. The rules are as follows:

1. Must explicitly declare the function's decorator.
2. Should not have implementations.
3. Should not declare a constructor.
4. Should not declare state variables.
5. Should not declare events (different from Solidity).

Let's rewrite the IERC20 contract in Cairo:

```rust
use starknet::ContractAddress;

#[abi]
trait IERC20 {
    #[view]
    fn total_supply() -> u256;

    #[view]
    fn balance_of(account: ContractAddress) -> u256;

    #[view]
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;

    #[external]
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn approve(spender: ContractAddress, amount: u256) -> bool;
}
```

Since interfaces in Cairo cannot contain events, we don't have the `Transfer` and `Approval` events within the interface. These must be declared in the implementation contract, a topic that we'll discuss in subsequent chapters.

## Summary

This chapter provided a deep-dive into the notion of interfaces in Cairo. Interfaces enforces a defined set of functions on a contract, enabling interaction with other contracts without having their source code.
