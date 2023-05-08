# WTF Cairo极简教程: 5. 函数

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 1.0.0`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.wtf.academy)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本章中，我们将介绍 Cairo 中的函数，包括用于控制可见性的 `#[view]` 和 `#[external]` 修饰器。

## 函数

Cairo 与 Rust 类似，函数使用 `fn` 关键字声明。参数类型像声明变量一样需要标明，当函数返回一个值时，必须在箭头 `->` 之后指定返回类型。

以下是 `sum_two()` 函数的示例。它接受两个 `u128` 类型的参数，并返回一个 `u128` 值。

```rust
fn sum_two(x: u128, y: u128) -> u128 {
    return x + y;
}
```

在类似 Rust 的语言中，函数的返回值由其函数体中的最后一个表达式确定。虽然你可以使用 `return` 关键字提前退出函数并指定一个值，但大多数函数会隐式返回最后一个表达式。下面的 `sum_two_expression()` 函数与 `sum_two()` 函数的行为完全相同。请注意，表达式不以分号 `;` 结尾。

```rust
fn sum_two_expression(x: u128, y: u128) -> u128 {
    x + y
}
```
## 可见性

默认情况下，函数是私有的，这意味着它们只能在内部访问。但是，你可以使用 `#[view]` 或 `#[external]` 修饰器声明公共函数。

### View

带有 `#[view]` 修饰器的函数可以被外部访问。它们可以读取状态变量，但不能更改合约的状态，例如更新状态变量或释放事件。

```rust
// 声明状态变量
struct Storage{
    balance: u128,
    }

// view 函数：可以读取但不能写入状态变量
#[view]
fn read_balance() -> u128 {
    return balance::read();
}
```

### External

带有 `#[external]` 修饰器的函数也可以被外部访问。与 `#[view]` 函数不同，它们可以修改合约的状态，例如更新状态变量或释放事件。

```rust
// External：可以读取和写入状态变量
#[external]
fn write_balance(new_balance: u128) {
    balance::write(new_balance);
}
```

## 总结

在本章中，我们探讨了 Cairo 中的函数。虽然函数默认是私有的，但你可以使用 `#[view]` 或 `#[external]` 修饰器使它们具有外部访问性。