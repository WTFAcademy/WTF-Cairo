---
title: 16. 事件
tags:
  - cairo
  - starknet
  - event
  - emit
---

# WTF Cairo极简教程: 16. 事件

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将探索 Cairo 中的事件（events）。在释放时，事件会将传递给它们的参数存储在 Starknet 交易日志中。

## 事件

类似于 Solidity，Cairo 中的事件是存储在 Starknet 上的交易日志。事件在函数调用时被释放，并可以被外部的链下应用访问。

以下是Starknet 的[事件例子](https://starkscan.co/event/0x033d5b803df5dcf2ea3c9131d5bde1a95aa17c00b8f44b769d7addf767f5beec_2)。这是ERC20合约中的一个 `Transfer` 事件，它包含三个参数：'from'，'to'，和 'value'。

![](./img/16-1.png)

事件具有以下几个特点：

1. 将数据存储在事件中比存储在存储变量中更具成本效益。
2. 事件不能直接从合约内部读取。
3. 诸如 starknet.js 的应用程序可以通过 RPC 接口订阅这些事件，并在前端触发响应。

为了更好地说明 Cairo 中的事件，我们扩展了上一章中的 `Owner` 合约示例。具体来说，我们添加了一个 `ChangeOwner` 事件，每次更改所有者时都会释放这个事件。

```rust
#[starknet::contract]
mod owner_event{
    // 导入与合约地址相关的库
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    /// 当所有者更改时发出的事件
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ChangeOwner: ChangeOwner,
    }

    #[derive(Drop, starknet::Event)]
    struct ChangeOwner {
        #[key]
        old_owner: ContractAddress, // 旧的所有者地址
        new_owner: ContractAddress  // 新的所有者地址
    }

    // 存储变量
    #[storage]
    struct Storage{
        owner: ContractAddress,  // 合约的所有者地址
    }

    // 在部署期间设置所有者地址
    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
    }

    // 读取所有者地址
    #[external(v0)]
    fn read_owner(self: @ContractState) -> ContractAddress{
        self.owner.read()
    }

    // 更改所有者地址并发出ChangeOwner事件
    // 任何人都可以调用
    #[external(v0)]
    fn change_owner(ref self: ContractState, new_owner: ContractAddress){
        let old_owner = self.owner.read();
        self.owner.write(new_owner);
        // 通过调用事件函数发出事件
        self.emit(ChangeOwner {old_owner: old_owner, new_owner: new_owner});
    }
}
```

### 定义事件

在 Cairo 中，事件是通过事件枚举。你需要使用`#[event]`和`#[derive(Drop, starknet::Event)]`属性，每个事件变体成员必须是一个与变体同名的结构体。然后，你需要定义事件结构体，它也需要使用`#[derive(Drop, starknet::Event)]`属性，并将你想要记录的参数添加为成员。在下面的例子中，我们定义了一个 `ChangeOwner` 事件，它有两个参数：旧所有者和新所有者的地址。

```rust
/// 当所有者更改时发出的事件
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    ChangeOwner: ChangeOwner,
}

#[derive(Drop, starknet::Event)]
struct ChangeOwner {
    #[key]
    old_owner: ContractAddress, // 旧的所有者地址
    new_owner: ContractAddress  // 新的所有者地址
}
```

### 释放事件

要释放事件，你需要使用`self.emit()`方法，并把要记录的数据作为参数。在下面的例子中，`ChangeOwner` 事件在 `change_owner()` 函数中的 `owner` 更改后释放。

```rust
// 更改所有者地址并发出ChangeOwner事件
// 任何人都可以调用
#[external(v0)]
fn change_owner(ref self: ContractState, new_owner: ContractAddress){
    let old_owner = self.owner.read();
    self.owner.write(new_owner);
    // 通过调用事件函数发出事件
    self.emit(ChangeOwner {old_owner: old_owner, new_owner: new_owner});
}
```

### 读取释放的事件

可以使用 Starknet.js 库读取释放的事件，这是一个用于 Starknet 的 JavaScript 库，类似于以太坊的 Ethers.js 。有关更多信息，请参阅 [Starknet.js 文档](https://www.starknetjs.com/docs/next/guides/events)。

## 总结

在本章中，我们介绍了 Cairo 中的事件，它们提供了一种高效的存储数据和跟踪合约中状态变化的方法。它们可以用于开发响应式的去中心化应用。