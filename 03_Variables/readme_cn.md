# WTF Cairo极简教程: 3. 局部和状态变量

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 1.0.0`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍 Cairo 中的两种变量类型：`local` 和 `storage`。

## 局部变量（Local Variables）

`local` 变量在函数内声明。它们是临时的，不会存储在链上。

```rust
// local 变量
#[view]
fn local_var(){
    // 使用 `let` 关键字声明局部变量
    let local_felt: felt252 = 5;
    let local_bool;
    local_bool = true;
    let local_uint = 1_u8;
}
```

## 状态变量（Storage Variables）

与 Solidity 类似，Cairo 支持 `storage` 变量。它们被存储在链上。你需要在合约中的一个名为 `Storage` 的特殊结构中声明状态变量，每个合约最多可以有一个 `Storage` 结构。

```rust
// 声明存储变量
struct Storage{
    var_felt: felt252,
    var_bool: bool,
    var_uint: u8,
}
```

每个存储变量有两个成员函数：`read()` 和 `write()`。所有的 `storage` 变量默认都是 `private` 的。您需要显式声明读写函数以使其公开。

```rust
// 读取存储变量
#[view]
fn read_bool() -> bool {
    return var_bool::read();
}

// 写入存储变量
#[external]
fn write_bool(bool_: bool) {
    var_bool::write(bool_);
}
```

## 总结

在本章中，我们深入探讨了 Cairo 中的 `local` 和 `storage` 变量。