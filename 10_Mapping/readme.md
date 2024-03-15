---
title: 10. 映射和其他类型
tags:
  - cairo
  - starknet
  - mapping
---

# WTF Cairo极简教程: 10. 映射和字典

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍如何在Cairo中使用“映射”和“字典”类型。

## Mapping

`mapping`（映射）类型允许用户通过`键`来查询相应的`值`。例如，可以通过账户地址查询账户余额。在Cairo中，可以使用`LegacyMap`来创建映射。

需要注意的是:

1. `LegacyMap`类型只允许作为状态变量使用，不能用作合约函数的参数或返回参数，也不能用作结构体内的类型。

2. 可以使用多个key对应一个value。

在下面的示例中，使用到了`ContractAddress`类型，即合约地址，需要使用`use starknet::ContractAddress;`导入。

```rust
use starknet::ContractAddress;
    
#[storage]
struct Storage {
    balances: LegacyMap::<ContractAddress, felt252>,
    allowance: LegacyMap::<(ContractAddress,ContractAddress),flet252>
}
```

对于Mapping的状态变量地址的计算，需要用到sn_keccak和[pedersen hash](https://docs.starknet.io/documentation/architecture_and_concepts/Cryptography/hash-functions/#poseidon_hash) (记为h)，具体算法为：对于一个名为variable_name，有n个key的mapping状态变量，其地址为h(...h(h(sn_keccak(variable_name),k_1),k_2),...,k_n),并将最终结果取模2^251-256。

与mapping的状态变量交互的函数如下:

```rust
// 读取余额
#[external(v0)]
fn read_balance(self: @ContractState, account: ContractAddress) -> u256 {
    self.balances.read(account)
}
```

可以使用以下函数更新给定地址的余额：

```rust
// 更新余额
#[external(v0)]
fn write_balance(ref self: ContractState, account: ContractAddress, new_balance: u256){
    self.balances.write(account, new_balance);
}
```

## Dictionaries

Cairo中还有一种使用键值对的数据类型-字典(dictionaries)。通过`Felt252Dict<T>`来进行创建，其中键唯一且只能是`felt252`类型，值为设定的`T`类型，与键相关联。你还可以进行以下两个基本操作：

1. `insert(felt252,T)->()`：用于向字典实例写入值。

2. `get(felt252)->T`：用于从字典读取值。

```rust
#[external(v0)]
fn dictionaries(self: @ContractState) -> u64{
    let mut balances: Felt252Dict<u64> = Default::default();

    balances.insert('Alex',100);
    balances.insert('Maria',200);

    let alex_balance = balances.get('Alex');
    return alex_balance;
}
```

需要注意的是，虽然cairo使用的是不可改内存，但字典相同键对应的值是可以修改的。

```rust
#[external(v0)]
fn dictionaries_extern(self: @ContractState) -> (u64,u64){
    let mut balances: Felt252Dict<u64> = Default::default();

    balances.insert('Alex',100);

    let alex_balance_first = balances.get('Alex');

    balances.insert('Alex',200);

    let alex_balance_second = balances.get('Alex');
    return (alex_balance_first,alex_balance_second);
}
```

## 总结

在本章中，我们讨论了如何在Cairo中使用`映射`类型和`字典`类型来创建和管理智能合约中的键值对。这些概念将帮助你在Starknet上开发更高效、更有组织的智能合约。
