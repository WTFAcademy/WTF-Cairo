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

当我们在函数中引入泛型时，我们将它们包含在函数签名中，这也是我们通常在定参数和返回值的数据类型的地方。为了说明这一点，考虑以下情景：我们想要开发一个函数，用于识别两个项目数组中较大的那一个。如果我们需要对不同类型的列表进行此操作，通常需要每次重新定义函数。幸运的是，我们可以利用泛型实现一次函数，并重用于不同类型的场景。

下面的larger_list函数接受两个相同类型的列表作为参数，返回元素更多的列表，并丢弃另一个列表。由于它使用了泛型，在编译器在执行主函数时无法保证Array<T>可丢弃，我们必须在函数签名中指定类型T必须实现Drop特质。

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
1. 在结构体名称后的尖括号内声明类型参数的名称。
2. 在结构体定义中使用泛型类型。

```rust
struct Bill<T> {
    totalCost: T,
}

impl BillDrop<T, impl TDrop: Drop<T>> of Drop<Bill<T>>;

fn main() {
    let w = Bill { totalCost: 5888_u128 };
}
```

请注意，由于派生宏（derive macro）对范型的支持不好，当使用泛型类型时，我们必须直接编写要实现的特质。

#### 枚举

枚举也可以使用多个范型类型。

Result<T, E> 枚举对类型 T 和 E 进行泛型化，并且具有两个变体：Ok，它保存了一个类型为 T 的值，以及 Err，它保存了一个类型为 E 的值。通过使用 Result<T, E> 枚举，我们可以表达结果值的抽象概念，并在不同的变体中使用不同的类型值。

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

#### 范型函数

我们还可以在结构体和枚举上实现的方法中使用泛型类型。例如，我们可以为Bill<T>结构体的定义定义一个`totalCost`方法：

1. 使用泛型类型`T`定义BillTrait<T>特质， 该定义了一个返回Bill的`totalCost`快照的方法。
2. 在BillImpl<T>中实现该特质。在`特质`和`实现`的定义中都必须包含泛型类型。

```rust
struct Bill<T> {
    totalCost: T,
}

impl BillDrop<T, impl TDrop: Drop<T>> of Drop<Bill<T>>;

trait BillTrait<T> {
    fn totalCost(self: @Bill<T>) -> @T;
}

impl BillImpl<T> of BillTrait<T> {
    fn totalCost(self: @Bill<T>) -> @T {
        return self.totalCost;
    }
}

fn main() {
    let bill = Bill { totalCost: 8_u8 };
    assert(bill.totalCost() == 8, 0);
}
```

## 总结

在这一章，我们学习了Cairo编程语言中范型的使用。