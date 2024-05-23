---
title: snfoundry测试框架第二讲：Test ERC20
tags:
  - cairo
  - starknet
  - wtfacademy
---

# snfoundry测试框架第二讲：Test ERC20

[Foundry](https://github.com/foundry-rs/foundry) 是 solidity 智能合约领域极具影响力的测试套件，由 Rust 语言编写完成。为了便于开发者做 Cairo 智能合约测试，Starknet Network 生态也为 Cairo 语言量身打造了具有同等地位的 [starknet foundry](https://github.com/foundry-rs/starknet-foundry/)，简称 `snfoundry`。

本系列专题供任何想要进阶学习 Cairo 智能合约编程（特别是合约功能与安全测试）的同志们提供便利。

## 1. ERC20简介

ERC20 是一种广泛应用于以太坊区块链上的代币标准。ERC20 标准定义了一组规则和接口，允许开发者在以太坊网络上创建和部署自己的代币。这些规则确保不同的 ERC20 代币在相同的标准下运行，从而实现互操作性和兼容性。

ERC20标准功能接口：

```cairo
#[starknet::interface]
trait IERC20<TState> {
    fn total_supply(self: @TState) -> u256;
    fn balance_of(self: @TState, account: ContractAddress) -> u256;
    fn allowance(self: @TState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref self: TState, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref self: TState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
    fn approve(ref self: TState, spender: ContractAddress, amount: u256) -> bool;
}
```

同时，ERC20还需要确定 Metadata 的接口，这些信息需要在构造函数中被初始化，之后无法改变。

```cairo
#[starknet::interface]
trait IERC20Metadata<TState> {
    fn name(self: @TState) -> ByteArray;
    fn symbol(self: @TState) -> ByteArray;
    fn decimals(self: @TState) -> u8;
}
```

## 2. ERC20 Cairo实现

为了跟进最新技术，我们直接在最新版本 `starknet = 2.6.3` 版本下开发，使用的工具版本分别为： `scarb = 2.6.3, starknet-foundry = 0.23.0`。

为了方便且让大家熟悉使用组件编程，本文借助 [Open Zeppelin ERC20 Component](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/token/erc20/erc20.cairo) 进行实现。在 `Scarb.toml` 中增加依赖： `openzeppelin = { git = "https://github.com/OpenZeppelin/cairo-contracts.git", tag = "v0.13.0" }`。

首先初始化项目： `snforge init erc20` ，进入到 `src/` 目录下，编写合约代码：

```
#[starknet::contract]
mod ERC20Mock {
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin::token::erc20::interface::IERC20Metadata;
    use starknet::ContractAddress;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // ERC20核心功能接口实现
    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;
    impl InternalImpl = ERC20Component::InternalImpl<ContractState>; // initializer()

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        decimals: u8,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        decimals: u8,
        recipient: ContractAddress,
        fixed_supply: u256
    ) {
        self.erc20.initializer(name, symbol);
        self.decimals.write(decimals);
        self.erc20._mint(recipient, fixed_supply);
    }

    #[abi(embed_v0)]
    impl ERC20MetadataImpl of IERC20Metadata<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            self.erc20.name()
        }

        fn symbol(self: @ContractState) -> ByteArray {
            self.erc20.symbol()
        }

        fn decimals(self: @ContractState) -> u8 {
            self.decimals.read()
        }
    }
}
```

上述是一个非常简单的 ERC20 的实现，但是里面却有一些有趣的东西，我们盘点一下：

1. Open Zeppelin 在 `v0.12.0` 版本为 `ERC20Component` 加入了 Hooks 特性。Hooks（译为钩子），是一种设计模式，可以增强合约的灵活性和模块化，同时提供更强的扩展性和定制化能力。而 OZ 这次就为 ERC20Component 加入了 `before_update()` 和 `after_update()` 两个 Hooks 接口，开发者可以自行定义更新前后所做的操作。于是，我们在使用 ERC20Component 时必须引入 `ERC20HooksEmptyImpl` 对 ERC20HooksTrait 的实现，或者也可以自己定义 ERC20HooksTrait 实现。
2. OZ 的 ERC20Component 不知什么原因，把 token 的 `decimals` 硬编码为 18，这在很多场景下是很蹩脚的。因此这里我考虑不直接使用 `ERC20MixinImpl` 实现，而是分割开，自己重新实现一下 `IERC20Metadada` trait，以便实现自定义 decimals。
3. `#[flat]` 这个 attribute 强制要求结构体在内存中以扁平格式存储，这意味着所有字段将按顺序直接存储在内存中，而不会有任何嵌套或间接的内存引用。而事件通常需要序列化成线性数据，以便在区块链日志中存储和检索。使用 `#[flat]` 修饰的结构体可以确保其字段在事件日志中按预期顺序和格式排列。

## 3. 测试

接下来我们可以对 ERC20Mock 合约开始第一个测试了，进入 `tests` 文件夹，编写测试程序：

```cairo
use starknet::{ContractAddress, ClassHash, contract_address_const};
use openzeppelin::token::erc20::interface::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};
use snforge_std::{declare, ContractClass, ContractClassTrait};
use core::num::traits::Zero;
use openzeppelin::utils::serde::SerializedAppend;

fn deploy_erc20mock_contract(
    name: ByteArray,
    symbol: ByteArray,
    decimals: u8,
    class_hash: ClassHash,
    recipient: ContractAddress,
    fixed_supply: u256
) -> ERC20ABIDispatcher {
    let contract_class = if class_hash == Zero::zero() {
        declare("ERC20Mock").expect('Declare failed')
    } else {
        ContractClass { class_hash }
    };
    let mut constructor_calldata = array![];
    constructor_calldata.append_serde(name);
    constructor_calldata.append_serde(symbol);
    constructor_calldata.append_serde(decimals);
    constructor_calldata.append_serde(recipient);
    constructor_calldata.append_serde(fixed_supply);
    let (address, _) = contract_class.deploy(@constructor_calldata).expect('Failed to deploy');
    ERC20ABIDispatcher { contract_address: address }
}

#[test]
fn test_erc20mock() {
    let name = "tnt";
    let symbol = "TNT";
    let decimals = 20;
    let recipient = contract_address_const::<0x123>();
    let fixed_supply = 1234567890;
    let dispatcher = deploy_erc20mock_contract(
        name, symbol, decimals, Zero::zero(), recipient, fixed_supply
    );

    assert_eq!(dispatcher.name(), "tnt");
    assert_eq!(dispatcher.symbol(), "TNT");
    assert_eq!(dispatcher.decimals(), 20);
    assert_eq!(dispatcher.total_supply(), 1234567890);
}
```

同样的，我们盘点一下其中的知识点：

1. 从架构来看， `tests` 文件夹其实相当于合约的集成测试模块。
2. `snforge-std` lib 中提供了 `declare` 函数帮助我们声明合约，并获得一个叫 `ContractClass` 的对象，这个对象只包含了声明合约得到的 ClassHash。函数的返回结果是一个 Result 对象，因此需要使用 `expect()` 解包。
3. `ContractClass` 对象可以调用 `deploy()` 函数来部署合约，前提是我们需要引入 `ContractClassTrait` 把 `deploy` 函数的具体定义包含到当前的命名空间中，函数的返回结果是一个 `SyscallResult<(ContractAddress, Span<felt252>)>` 对象， 正确返回值是一个二元组，第一个元素是合约地址，第二个元素是返回值.
4. OZ 的 ERC20Component 最新实现把 `name`, `symbol` 参数定义为 `ByteArray`，即字符串类型。因此，和 `deploy()` 要求的 `@Array::<felt252>` 不符，因此我们需要把数组序列化为 felt252 格式。这里有两种方法，第一种方法直接使用 `Serde::serialize()`：
   
   ```cairo
   Serde::serialize(@name, ref constructor_calldata);
   Serde::serialize(@symbol, ref constructor_calldata);
   Serde::serialize(@decimals, ref constructor_calldata);
   ...
   ```
   
   另一种方法就是使用 OZ 提供的工具： `use openzeppelin::utils::serde::SerializedAppend;` ，可以直接调用 `append_serde()` 方法把各种类型元素到序列化到 felt252 数组中。

5. 最后就是一些基本的测试断言函数，比如 `assert!()` ，作用是断言第一个传参为 bool 值 true，否则 panic 并打印第二个传参作为错误信息； `assert_eq!()` 作用是断言两个传参相等，否则 panic。

执行 `snforge test` ，测试通过。证明 `ERC20Mock` 合约的行为在我们的预期之中。


## 4. 总结

本小节我们借助 ERC20Mock 合约，初步领略如何使用 `snforge-std` 测试框架来判断所实现的合约的行为是否在我们的预期之中。后续，我将进一步介绍 snforge 测试框架的内容，并结合 starknet 自带原声测试库 `starknet::testing` 阐述二者之间的联系，供读者学习。
