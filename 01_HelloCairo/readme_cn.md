# WTF Cairo极简教程: 1. Hello Cairo!（7行代码）

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 1.0.0`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.wtf.academy)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

## Cairo 简介

`Cairo` 是以太坊ZK-Rollup扩容方案 StarkNet 上智能合约的编程语言。它也用于编写可证明程序。Cairo主要有两个特点：

1. ZK友好: `Cairo`是图灵完备的通用可证明计算的编程语言，可以编译为 Stark 可证明程序。

2. 难学: `Cairo` 学习曲线陡峭；并且现在属于开发早期，每个版本都会有很大改变。

目前 `Cairo` 版本为 `1.0.0`，基于 Rust，所以语法也很像 Rust，与之前的 `0.x` 版本有很大不同。学习 Rust 对学习 Cairo 有很大帮助，Rust中文资料汇总见[链接](https://github.com/WTFAcademy/WTF-Rust)。

## 开发工具: Cairo cli

由于目前 `Cairo` 仍处于开发早期，工具还在开发中，并未成熟。因此我们使用 `Cairo cli` （命令行工具）来编译合约。

### 配置环境

为了使用 `Cairo cli`，我们需要安装 rust 并克隆 Cairo repo。

1. 下载 [Rust](https://www.rust-lang.org/tools/install)

2. 安装 Rust:

    ```shell
    rustup override set stable && rustup update
    ```

3. 确认 Rust 被正确安装:

    ```shell
    cargo test
    ```

4. 克隆 Cairo repo 到本地:

    ```shell
    git clone https://github.com/starkware-libs/cairo
    ```

### 编译合约

1. 切换到 Cairo repo 在本地的文件夹:
    ```shell
    cd cairo
    ```

2. 使用以下命令将 Cairo 合约编译为 Sierra ContractClass（将其中的`/path/to/input.cairo` 更换为合约文件目录，`/path/to/output.json` 更换为编译后产出的文件目录。）:

    ```shell
    cargo run --bin starknet-compile -- /path/to/input.cairo /path/to/output.json
    ```



## Hello Cairo

我们写的第一个 Cairo 合约很简单，只有7行代码：

```rust
#[contract]
mod HelloCairo {
    #[view]
    fn hello_cairo() -> felt252 {
        return 'Hello Cairo!';
    }
}
```

我们拆开分析，学习 cairo 合约源文件的结构：

第1行利用 `#[contract]` 属性声明了这段代码为 `StarkNet` 合约。如果不声明，则不能部署在 `StarkNet` 上。

```rust
#[contract]
```

第2行利用 `mod` 模块关键字创建了合约，名为 `HelloCairo`。这与 `Rust` 中的 `mod` 类似，是一系列元素的集合，包括结构体、函数等。

```rust
mod HelloCairo {
}
```

之后，我们写了一个函数 `hello_cairo`。第3行，我们用 `#[view]` 属性修饰这个函数。与`solidity`中的类似`view`类似，该函数可以被外部调用，但是只能查询但不能修改合约状态。

```rust
#[view]
```

第4-6行我们声明了 `hello_cairo` 函数。它没有参数，有一个返回值，类型为`felt252`。`felt`（field element，域元素）是 `cairo` 的基本类型之一，短字符串也是用它表示，我们会在之后的章节更详细的介绍它。在函数体中，我们将返回值设为短字符串（长度小于32个字符） `Hello Cairo!`。

```rust
fn hello_cairo() -> felt252 {
    return 'Hello Cairo!';
}
```

## 编译并部署代码

将上面的合约代码保存到 `HelloCairo.cairo` 文件中，然后使用 `Cairo cli` 进行编译（一定要在 cairo repo 的根目录下）:

```shell
cargo run --bin starknet-compile -- ./HelloCairo.cairo ./HelloCairo.json
```

编译成功后，我们可以看到一个叫 `HelloCairo.json` 的文件，其中的 `abi` 部分如下：

```json
  "abi": [
    {
      "type": "function",
      "name": "hello_cairo",
      "inputs": [],
      "outputs": [
        {
          "type": "core::felt252"
        }
      ],
      "state_mutability": "view"
    }
  ]
```

可以看到我们成功编译了第一个 Cairo 合约 `HelloCairo`，其中有一个外部函数 `hello_cairo`，没有参数，有一个类型为 `felt252` 的返回值，函数的状态可变性为 `view`（只读）。

## 总结

这一讲，我们简单介绍了`Cairo 1.0`，并编译了第一个`Cairo`智能合约--`Hello Cairo`。之后，我们将继续 `Cairo` 之旅！

## Cairo 资料参考

1. [Cairo官方文档（英文）](https://www.cairo-lang.org/docs/v1.0/)
2. [Starkling Cairo1](https://github.com/shramee/starklings-cairo1)
3. [Starknet Cairo 101](https://github.com/starknet-edu/starknet-cairo-101)