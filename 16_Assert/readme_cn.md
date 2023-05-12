# WTF Cairo极简教程: 16. 断言

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 1.0.0`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.wtf.academy)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在这一章中，我们将探讨 Cairo 中的Assert。

## Assert

Assert用于在合约中发送错误信息和访问控制，你可以在Cairo中创建自定义错误，这些错误在执行失败时会呈现给用户，这对于实施检查和正确访问非常有用的控制机制。

在Cairo中，你可以很轻松的使用与`Solidity`中的`require`语句类似的方式来使用`assert`语句

```rust
assert(sender != 0, 'ERC20: transfer from 0');
```
错误信息必须少于31个字符


## 总结

在这一章中，我们介绍了 Cairo 中的`assert`。Cairo的`assert`的语法与`Solidity`中的`require`语法基本上保持一致。