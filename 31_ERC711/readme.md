---
title: 31. ERC20
tags:
  - cairo
  - starknet
  - wtfacademy
  - ERC20
---

# WTF Cairo极简教程: 31. ERC711

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在这节中，我们将会讲一下非同质化代币（NFT），并介绍一下ERC20标准，并基于它发行一款NFT。

## NFT

当我们谈论`BTC`、`ETH`或`STRK`等加密数字货币时，通常指的是同质化代币。这意味着无论是第一枚还是第一千枚代币，它们之间没有区别，都是可相互替换的，并且可以被分割成任意大小。

然而，与同质化代币截然不同的是非同质化代币（Non-Fungible Token，NFT）。`NFT`的关键特征在于每一个代币都拥有独一无二的标识，使其不可替换。此外，`NFT`是不可分割的，其最小单位是1。这意味着，每一个`NFT`都是唯一的存在，就像人类每个个体都有自己独特的特质和个性一样。

## ERC721
账户抽象代表了一种在区块链网络中管理账户和交易的方法。主要涉及两个关键概念：

1. 交易灵活性
  
  - 智能合约验证其交易，摆脱了通用验证模型。

  - 好处包括智能合约支付燃料费，支持一个账户多个签名者，以及使用替代加密签名。

2.用户体验优化

  - 账户抽象使开发者能够设计灵活的安全模型，如对常规和高价值交易使用不同的密钥。

  - 它提供了种子短语用于账户恢复的替代方案，简化了用户体验。

具体可以参考[StarkNet Account Abstraction Model](https://community.starknet.io/t/starknet-account-abstraction-model-part-1/781/1)   

## 可编程交易有效性

账户抽象统一了合约账号和外部账号，它使得用户的账号具有编程性，用户可以将不同的需求适配到不同的账号，例如：

1. 当您需要一个不同于`ECDSA`的签名机制时，您可以创建一个账号来实现它。

2. 当您想要使用多个密钥来授权交易时，您可以创建一个账号来实现它。

3. 如果您想要每周更换您账号的私钥时，您可以创建一个账号来实现它。

## 账户合约

接下来，我们来实现一个账户合约。当智能合约遵循SNIP-6([Starknet改进提案6:标准账户接口](https://community.starknet.io/t/snip-starknet-standard-account/95665))
中的接口时，它就变成了账户合约。

```rust
struct Call {
    to: ContractAddress,
    selector: felt252,
    calldata: Array<felt252>
}

trait ISRC6 {
    fn __execute__(calls: Array<Call>) -> Array<Span<felt252>>;
    fn __validate__(calls: Array<Call>) -> felt252;
    fn is_valid_signature(hash: felt252, signature: Array<felt252>) -> felt252;
}
```

该接口总共有三个函数：

1. `__execute__()`:通过账户执行一个交易。

2. `__validate__()`:验证交易是否有效的执行。

3. `is_valid_signature()`:确认交易签名的真实性。

接下来我们实现该账户合约。

```
#[starknet::contract]
mod HelloAccount {
    use starknet::VALIDATED;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use super::Call;

    #[storage]
    struct Storage {} 

    #[abi(embed_v0)]
    impl SRC6Impl of super::ISRC6<ContractState> {
        fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>
        ) -> felt252 {
            VALIDATED
        }
        fn validate(self: @ContractState, calls: Array<Call>) -> felt252 {
            let hash = 0;
            let mut signature: Array<felt252> = ArrayTrait::new();
            signature.append(0);
            self.is_valid_signature(hash, signature)
        }
        fn execute(self: @ContractState, calls: Array<Call>) -> Array<Span<felt252>> {
            let sender = get_caller_address();
            assert(sender.is_zero(), 'Account: invalid caller');
            let Call{to, selector, calldata } = calls.at(0);
            let _res = starknet::call_contract_syscall(*to, *selector, calldata.span()).unwrap();
            let mut res = ArrayTrait::new();
            res.append(_res);
            res
        }
    }
}
```

## 总结

本章我们学习了账户抽象，并实现了一个简易的账户合约。
