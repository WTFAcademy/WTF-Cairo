---
title: snfoundry测试框架第一讲：Starting Point
tags:
  - cairo
  - starknet
  - wtfacademy
---

# snfoundry测试框架第一讲：Starting Point

[Foundry](https://github.com/foundry-rs/foundry) 是 solidity 智能合约领域极具影响力的测试套件，由 Rust 语言编写完成。为了便于开发者做 Cairo 智能合约测试，Starknet Network 生态也为 Cairo 语言量身打造了具有同等地位的 [starknet foundry](https://github.com/foundry-rs/starknet-foundry/)，简称 `snfoundry`。

本系列专题供任何想要进阶学习 Cairo 智能合约编程（特别是合约功能与安全测试）的同志们提供便利。

## 1. 简介

`snfoundry` 工具套件是由前 [Protostar](https://github.com/software-mansion/protostar) 团队基于原生 Cairo test Runner 和 [Blockifier](https://github.com/starkware-libs/blockifier) 使用 Rust 语言开发而成。

`snfoundry` 工具大量借鉴了 `foundry` 测试工具套件的设计亮点，同样的，也分为两个工具 `snforge` 和 `sncast`，我们将在之后的专题中逐步学习他们如何帮助我们测试智能合约。

- snforge：是 Starknet 的智能合约测试框架
- sncast：是与 Starknet 网络中智能合约交互的一体化工具，包括发送交易以及获得链状态。

## 2. 安装与使用

### 安装
方法 1：使用 `snfoundryup` 管理套件版本（个人不太习惯）

```bash
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
```

下载完成后，可以使用它来下载指定版本的工具套件：

```bash
snfoundryup -v 0.9.0 # 如果不带 -v 就默认最新版本
```

方法 2：使用 `asdf` 工具管理套件版本（个人比较推荐）

推荐使用 [asdf](https://asdf-vm.com/) 工具是因为它也同样可以管理 `scarb` 版本，非常有助于我们管理工具版本：

```bash
# 管理 starknet foundry 套件
asdf add plugin starknet-foundry
asdf install starknet-foundry 0.17.0
asdf global starknet-foundry 0.17.0

# 管理 scarb 工具
asdf add plugin scarb
asdf install scarb 2.5.3
asdf global scarb 2.5.3
```

综上，我们用 asdf 工具可以完成 Cairo 合约开发中两个非常重要的工具的版本管理，非常奶思。

### 使用

#### snforge

- 初始化新的测试项目： `snforge init new-project`，这个空项目的目录结构为：

  ```
  .
  ├── README.md
  ├── Scarb.toml
  ├── src
  └── tests
  ```
  其中 src 文件夹存放合约源代码文件，tests 文件夹存放测试合约代码文件。

  对比来看，**`snforge` 阉割 `forge` 中的 scripts 文件夹，即无法执行一些脚本去跟实际的链交互**。

- 开始测试： `snforge test` 。会使用 snforge 的 test runner 运行项目中的所有测试文件，包括 src 文件夹中源代码中可能存在的单元测试代码，还有 tests 文件夹中的测试代码。

  这里需要在 `Scarb.toml` 文件中配置工具：

  ```bash
  [tool.snforge]
  exit_first = true
  ```
  上述配置是说：当执行到第一个返回错误的测试文件时就终止测试，如果是 `false` 表示执行全部测试文件。

  如果只想执行某个特定的测试函数，直接执行 `snforge test test_function_name`。snforge 会去捕获所有匹配 `test_function_name*()` 的测试函数（注意不是精确匹配）。

  snforge 提供一个强大的测试库，在写测试合约时会经常使用，使用时需要引入依赖：

  ```toml
  # in Scarb.toml
  [dev-dependencies]
  snforge_std = { git = "https://github.com/foundry-rs/starknet-foundry.git", tag = "v0.12.0" }
  ```

  请注意 **引入这个依赖库版本与你使用的工具版本需要保持一致** 。

  我们也可以通过命令行方式引入上述依赖：

  ```bash
  scarb add snforge_std \ 
  --dev \
  --git https://github.com/foundry-rs/starknet-foundry.git \
  --tag v0.12.0
  ```

#### sncast

  sncast 经常用于直接与链进行交互：发送交易和获取链信息。

  于是，在发送交易时，sncast 就需要被指定一个账户信息，用于签名交易。

  一般而言，我们有两种方式指明账户：
  - 第一种就是直接 sncast 命令行中指定参数 `--keystore path/to/keystore.json --account path/to/account.json`。这种显然是复杂的，但是对于那些从 ArgentX 导出账户信息的伙计们是实用的。
  - 另一种方式是在配置文件中直接配置好账户信息（profile），这个配置信息需要写在 `snfoudnry.toml` 文件中，比如：
  
    ```toml
    [sncast.myprofile]
    account = "user"
    accounts-file = "~/my_accounts.json"
    url = "http://127.0.0.1:5050/rpc"
    ```

  于是，我们只需要命令行中指定 `sncast sncast --profile myprofile call ...` 信息即可。

  注意： `snfoundry.toml` 必须在命令执行的当前文件夹或者父文件夹中出现。并且这个文件夹中可以配置多个 profile 。

  不仅如此，sncast还允许配置默认 profile ：
  ```toml
  [sncast.default]
  account = "user123"
  accounts-file = "~/my_accounts.json"
  url = "http://127.0.0.1:5050/rpc"
  ```

  这样执行 sncast 命令时都不需要指定 profile 信息了，直接使用这个默认的配置信息。

  > 在这些配置文件中，允许使用环境变量。

留一个小任务：
- 如何把 Argent X 钱包中的账户信息导出到本地，并在一个项目中配置文件中配置 profile？

  <details><summary>我的解决方案👀</summary>

  1. 首先用 starkli 把账户合约 fetch 到本地。
   
    ```bash
    starkli signer keystore from-key ~/.starkli-wallets/deployer/keystore.json
    starkli account fetch <SMART_WALLET_ADDRESS> --output ~/.starkli-wallets/deployer/account.json --rpc <YOUR_RPC_ENDPOINT_HERE>
    ```

    > 注意可以使用 `starkli -vV` 查看 RPC-JSON 版本， 然后选择 RPC 节点链接。我这边是 `JSON-RPC version: 0.7.1`
  
  2. 然后构建 `snfoundry.toml` 配置文件:
   
    ```toml
    [sncast.xor0v0]
    account = "xor0v0"
    accounts-file = "~/.starkli-wallets/deployer/account.json"
    url = "https://starknet-mainnet.reddio.com/rpc/v0_7/YOUR-RPC"
    ```
   
    ```bash
    sncast --profile xor \   
    call \
    --contract-address 0x01a730fb914b6e79e6e05af2996b423306652c1c2d5036a455f3979d20161c8f \
    --function get_name \
    --block-id latest
    ```

    收到响应为：
    ```bash
    command: call
    response: [0x417267656e744163636f756e74]
    ```
    十六进制转成字节数组为： `b'ArgentAccount'`，即成功交互。

  </details>

## 3.  Starknet & Cairo


### 关键版本更新

由于 Starknet 和 Cairo 目前均处于快速迭代时期，因此我们应该
https://docs.starknet.io/documentation/starknet_versions/version_notes/

- Starknet 于 2021 年 10 月份上线主网，直到 2023 年 5 月 31 日 Starknet 更新至 0.11.2 版本之前，这个阶段的主网都是用 Cairo 0 作为合约开发语言；
- 2023 年 5 月 31 日，Starknet 0.11.2 正式使用 Cairo 1 作为合约语言；
- 很快，2023 年 7 月 12 日 Starknet 主网迭代至 0.12.0，启用 Cairo 2作为合约语言。
- 2024 年 1 月 10 日，Starknet 主网更新至 0.13.0 版本，使用 STRK 支付手续费，此时 Cairo 2版本为 2.4.0；
- 2024 年 3 月 13 日， Starknet 使用 DA 策略，大幅下降手续费。
- 目前，很大部分项目更愿意在 Cairo 2.5.3 版本上开发，对应的 snfoundry 的版本号为 0.17.0。
- 截止到 2024 年 5 月 20 日，目前 Starknet 最新版本为 0.13.0，Cairo 版本为 2.6.3.
- 补充：Cairo 语言也采用了 Rust 中 edition 概念，每一个 Cairo edition 会启用某些功能，目前默认 `edition = 2023_10` 。而如果你在 `Scarb.toml` 中指定 `edition = 2023_11` ，这个 edition 会启用 `pub` 关键字，进而使得你的代码中如果需要关心 module 可见性的部分变得不可用，因此需要特别注意。


## 4. 总结

本小节，主要是对 snfoundry 测试工具套件的介绍、下载和使用进行介绍。接下来，就是对 snfoundry 套件中两个命令行工具分别进行深入的挖掘与学习。