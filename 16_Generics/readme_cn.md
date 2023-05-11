# WTF Cairo: 16. 范型

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 1.0.0`版本

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.wtf.academy)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

这一章，我们学习Cairo编程语言对范型的支持

## 范型概要

范型编程是关于抽象和分类算法和数据结构。它能实现：
1. 编译期检查
2. 代码重用
3. 类型安全

### 您必须知道的

虽然范型能帮助开发人员提高开发效率，但在开发中，当我们实现在编译期用具体类型替换范型时，重复代码是依然存在的

这在我们使用范型编写Starknet合约时可能会很关键，因为它会增加合约的大小。

### 范型类型

我们可以在函数，结构体，枚举中使用范型。

#### 函数

```rust
use array::ArrayTrait;
use debug::PrintTrait;

fn larger_list<T, impl TDrop: Drop<T>>(l1: Array<T>, l2: Array<T>) -> Array<T> {
    if l1.len() > l2.len() {
        l1
    } else {
        l2
    }
}

fn find_larger_uint_list() {
    let mut l1 = ArrayTrait::new();
    let mut l2 = ArrayTrait::new();

    l1.append(1);
    l1.append(2);

    l2.append(3);
    l2.append(4);
    l2.append(5);

    let l3 = larger_list(l1, l2);
    l3.len().print();
}

fn find_larger_bool_list() {
    let mut l1 = ArrayTrait::new();
    let mut l2 = ArrayTrait::new();

    l1.append(true);
    l1.append(false);

    l2.append(true);
    l2.append(false);
    l2.append(true);

    let l3 = larger_list(l1, l2);
    l3.len().print();
}

fn main() {
    find_larger_uint_list();
    find_larger_bool_list();
}
```

#### 结构体

我们可以在结构体的定义中使用范型来定义字段。我们使用<>的语法，这与函数定义非常类似。

```rust
struct Bill<T> {
    totalCost: T,
}

impl BillDrop<T, impl TDrop: Drop<T>> of Drop<Bill<T>>;

fn main() {
    let w = Bill { totalCost: 5888_u128 };
}
```

#### 枚举

枚举也可以使用多个范型类型。

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

## 总结

在这一章，我们学习了Cairo编程语言中范型的使用。