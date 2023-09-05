# WTF Cairo: 2. Primitive Types

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy\_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce traits and implementations.

## Traits

A `trait` in Cairo specifies a set of funtion signatures. This collection of function signatures creates a blueprint for building the functionality in a standard way.

When coupled with generic types, traits allow implementing the set of functionality for multiple types.

In this example we create an app that has some shapes.
So we write a trait `GeometryFunctions`, which is our blueprint for adding functionality to find `area` and `boundary` for a shape. Here is how the trait declaration could look like.

```rust
trait GeometryFunctions<T> {
    fn boundary(self: T) -> u64;
    fn area(self: T) -> u64;
}
```

## Implementations

Once we have our `trait`, we can start building the actual functionality based on this blueprint. We do this with an `implementation` using the keyword `impl`.

Continuing our example, one of the shapes we have is a `Rectangle`.

`Rectangle` `struct` looks like this,

```rust
struct Rectangle{
    h: u64,
    w: u64,
}
```

Now we want to implement `GeometryFunctions` functionality for our `Rectangle`. So we use `impl` keyword with a name for our implementation (`RectGeometryFunctions`) and tell Cairo the trait (`GeometryFunctions`) we are implementing along with any generic types (in our case `Rectangle`) that trait specifies. Then we start writing what our functions should do.

```rust
impl RectGeometryFunctions of GeometryFunctions<Rectangle> {
    fn boundary(self: Rectangle) -> u64 {
        2_u64 * (self.h + self.w)
    }
    fn area(self: Rectangle) -> u64 {
        self.h * self.w
    }
}
```

## Using the implementation functions

Implementation function can be used from the implementation like this,

```rust
ImplementationName::function_name( parameter1, parameter2 );
```

But when the implementation uses keyword `self` the methods can be accessed from struct objects like this, When calling the function like this, you don't need to pass `self` parameter value, it is automatically passed for you.

```rust
my_obj.function_name( parameter );
```

For our example we create a `Rectangle` `rect`,

```rust
let rect = Rectangle { h: 5_u64, w: 7_u64 };
```

Then `area` method can be called like this,

```rust
RectGeometryFunctions::area(rect);
```

But since our trait specification uses `self` keyword, it can also be called like this,

```rust
rect.area();
```
