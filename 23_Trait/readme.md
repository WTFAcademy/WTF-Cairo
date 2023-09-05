# WTF Cairo: 23. Trait and Implementation

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this tutorial, we'll explore Trait and Implementation in Cairo, enabling us to perform modular design and code reuse.

## Trait

In Cairo, a Trait is an abstract type that defines certain behaviors (methods). It does not implement any functionality itself, but specifies a set of function signatures. It merely defines a pattern or agrees on a way of behaving. Then, you can implement these traits on any type, allowing these types to have behavior consistent with that defined by the Trait.

Let's take an example of calculating rectangle geometric properties. First, we create a `Rectangle` struct that includes two fields: height `h` and width `w`.

```rust
// Example struct
#[derive(Copy, Drop)]
struct Rectangle{
    h: u64,
    w: u64,
}
```

Then, we create a Trait called `GeometryFunctions` which contains two functions `area()` and `boundary()`, used to calculate the area and perimeter of the recangle, respectively.

```rust
// Our blueprint, the trait
trait RectGeometry {
    fn boundary(self: Rectangle) -> u64;
    fn area(self: Rectangle) -> u64;
}
```

Trait declaration begins with the `trait` keyword, followed by the Trait name (in `PascalCase`), and a group of function signatures in `{}`.

## Implementation

With our `trait` established, we're ready to build functions. The rules for writing implementations are:

1. The function parameters and return value types in the implementation must be identical to the trait specification.
2. All the functions in the trait must be implemented by the implementation.

Here is an example of implementing the `RectGeometry` Trait:


```rust
// Implementation for the trait for type `Rectangle`
impl RectGeometryImpl of RectGeometry {
    fn boundary(self: Rectangle) -> u64 {
        2_u64 * (self.h + self.w)
    }

    fn area(self: Rectangle) -> u64 {
        self.h * self.w
    }
}
```

The implementation starts with the `impl` keyword, followed by the name of the implementation (`RectGeometryImpl`), then the `of` keyword and the name of the trait being implemented (`RectGeometry`), and the set of functions included in the trait.


## Using Functions from the Implementation

### 1. Use with Implementation Name

You can call functions from the implementation:

```rust
ImplementationName::function_name( parameter1, parameter2 );
```

For instance:

```rust
let rect = Rectangle { h: 5_u64, w: 7_u64 };
RectGeometryImpl::boundary(rect);
RectGeometryImpl::area(rect);
```



### 2. Use with Struct Object

When the implementation uses the `self` keyword in function parameters, the methods can be accessed directly from the struct objects. In this case, you don't need to explicitly pass the `self` parameter value; it's automatically provided for you.

```rust
obj_name.function_name( parameter );
```

For instance:

```rust
let rect = Rectangle { h: 5_u64, w: 7_u64 };
rect.boundary();
rect.area();
```

## Summary

In this chapter, we explored traits and implementations in Cairo. By understanding these concepts, you will be able to perform modular design and code reuse better, improving the readability and maintainability of your code.