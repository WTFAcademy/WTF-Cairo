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

## ERC20 合约

[ERC20Mock](./erc20mock/src/lib.cairo) 通过 OpenZeppelin 的组件实现标准 ERC-20。
构造函数初始化名称和符号，将自定义的精度存入合约，并把固定供应量铸给给定地址。
`ERC20Impl` 导出标准代币方法，`ERC20CamelOnlyImpl` 提供驼峰命名的兼容方法。
`IERC20Metadata` 的三个入口返回名称、符号和精度。

项目使用 Cairo 和 Scarb 2.21.0、Starknet Foundry 0.64.1 和 OpenZeppelin Cairo 4.0.1。
直接依赖的版本见 [Scarb.toml](./erc20mock/Scarb.toml)。

## 本地运行

安装 Scarb、Starknet Foundry 和 Universal Sierra Compiler。进入示例目录并运行：

```sh
cd erc20mock
scarb test
```

[集成测试](./erc20mock/tests/test_erc20mock.cairo) 通过 `declare` 获取合约类。
使用 `Serde::serialize` 按构造函数顺序编码参数，再调用 `deploy` 获得合约地址。
最后通过 `ERC20ABIDispatcher` 检查元数据、总供应量与收款人的余额。
