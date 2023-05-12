# WTF Cairo极简教程: 15. 事件

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 1.0.0`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.wtf.academy)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在这一章中，我们将探讨 Cairo 中的事件。

## 事件

在Cairo中，事件允许合约在执行生命周期中发送可以在`Starknet`链之外使用的信息，
一个事件可以按照如下方式定义：

```rust
#[event]

fn Transfer(from_: felt, to: felt, value: u256) {}
```


## 总结

在这一章中，我们介绍了 Cairo 中的事件，我们学习了如何在Cairo定义事件。