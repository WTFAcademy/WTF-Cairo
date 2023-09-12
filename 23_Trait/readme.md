---
title: 23. 特质和实现
tags:
  - cairo
  - starknet
  - trait
  - impl
  - implementation
---

# WTF Cairo极简教程: 23. 特质和实现

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在本教程中，我们将探讨 Cairo 中的特质（trait）和实现（Implementaion），让你更好地进行模块化设计和代码重用。

## Trait

在 Cairo 中，Trait 是一种定义了某些行为（方法）的抽象类型。它本身不会实现任何功能，但是会指定一组函数签名，，它只是定义了一种模式，或者说约定了一种行为方式。然后你可以在任何类型上实现这些 Trait，从而允许这些类型拥有与 Trait 定义的相应行为。

下面，我们举个计算矩形几何属性的例子。首先，我们创建一个 `Rectangle` 结构体，它包含两个字段：高度 `h` 和宽度 `w`。

```rust
// 示例结构体
#[derive(Copy, Drop)]
struct Rectangle{
    h: u64,
    w: u64,
}
```

然后我们创建一个叫做 `GeometryFunctions` 的 Trait，它包含两个函数 `area()` 和 `boundary()`，分别用来计算矩阵的面积和周长。

```rust
// 我们的蓝图，trait
trait RectGeometry {
    fn boundary(self: Rectangle) -> u64;
    fn area(self: Rectangle) -> u64;
}
```

Trait 声明以 `trait` 关键字开始，接着是 Trait 名称（用帕斯卡命名 `PascalCase`），然后在 `{}` 内写一组函数签名（不是实现了的函数）。

## Implementation

有了 `trait`，我们就可以开始构建功能了。编写实现的规则：

1. 实现中的函数参数和返回值类型必须与 trait 规范相同。
2. trait 中的所有函数必须由实现来实现。

下面是实现 `RectGeometry` Trait 的例子：

```rust
// 为 `Rectangle` 类型的 trait 的实现
impl RectGeometryImpl of RectGeometry {
    fn boundary(self: Rectangle) -> u64 {
        2_u64 * (self.h + self.w)
    }

    fn area(self: Rectangle) -> u64 {
        self.h * self.w
    }
}
```

实现以 `impl` 关键字开始，接着是实现的名称（`RectGeometryImpl`），然后是 `of` 关键字和正在实现的 trait 的名称（`RectGeometry`），以及包含在 trait 中的函数集合。


## 使用实现的函数

### 1. 通过实现名称

你可以通过实现名称来从实现中调用函数：

```rust
ImplementationName::function_name( parameter1, parameter2 );
```

例如：

```rust
let rect = Rectangle { h: 5_u64, w: 7_u64 };
RectGeometryImpl::boundary(rect);
RectGeometryImpl::area(rect);
```

### 2. 通过结构体对象

当实现的函数参数使用 `self` 关键字时，可以直接从相应的结构体对象访问方法。在这种情况下，你不需要明确传递 `self` 参数值，它会自动为你提供。

```rust
obj_name.function_name( parameter );
```

例如：

```rust
let rect = Rectangle { h: 5_u64, w: 7_u64 };
rect.boundary();
rect.area();
```

## 总结

在本章中，我们探讨了 Cairo 中的特质（trait）和实现（Implementation）。通过理解并适用这些概念，你将能够更好地进行模块化设计和代码重用，提高代码的可读性和可维护性。