# WTF Cairo极简教程: 6. 元祖 Tuple

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 1.0.0`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.wtf.academy)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍在 Cairo 中如何使用元组，包括将元组作为函数参数和返回值。

## 元组

元组是由不同类型的值组成的集合。元组使用圆括号 `(),` 构造，每个元组本身都是具有类型签名（`T1`，`T2`，...）的值，其中 `T1`、`T2` 是其成员的类型。函数可以使用元组返回多个值，因为元组可以容纳任意数量的值。

以下是 `reverse()` 函数的示例。它接受具有 `u32` 和 `bool` 类型参数的元组，并返回具有倒序的另一个元组。

```rust
#[contract]
mod tuple_reverse {
    // 元组可用作函数参数和返回值。
    #[view]
    fn reverse(pair: (u32, bool)) -> (bool, u32) {
        // 解包：可以使用 `let` 将元组的成员绑定到变量。
        let (integer, boolean) = pair;
        return (boolean, integer);
    }
}
```

## 总结

在本章中，我们介绍了在 Cairo 中使用元组，涵盖了将元组作为函数参数和返回值的用法，以及如何解包它们。