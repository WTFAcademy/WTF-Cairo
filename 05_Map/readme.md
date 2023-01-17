# WTF Cairo极简教程: 5. 映射

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 0.10.3`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.wtf.academy)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

这一讲，我们将介绍 Cairo 中的哈希表：映射（Map）类型。

## 映射

在映射中，人们可以通过键（`Key`）来查询对应的值（`Value`），比如：通过一个人的地址来查询他的钱包地址。

声明映射的方式与声明 `felt` 类型的状态变量类似，您必须定义映射的类型，并在 `Key` 和 `Value` 之间使用 `->` 符号。在下面的例子中，我们定义了一个 `balance` 映射，`Key` 和 `Value` 的类型均为 `felt`：
```python
@storage_var
func balance(address : felt) -> (amount : felt){
}
```  
`Cairo` 映射的规则与 `Solidity` 有一些不同：
1. `Key` 的类型不仅可以是基本类型 `felt`，也可以是自定义的结构体或元组（包含多个变量）。
2. `Value` 可以是单个 `felt`，结构体，也可以是元组（包含多个变量）。
