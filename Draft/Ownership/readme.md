# WTF Cairo: Ownership

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy\_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will talk about ownership.

## Ownership

In Cairo, every value has an owner, And there can only be one owner for a value at a time. And after this owner is done executing and goes out of scope, the value is dropped. This makes the language memory safe, disallows memory operations that could cause runtime errors and prevents security issues arising from out of bound memory access.

The ownership model is a complete byproduct of the linear type system. While we will cover practical implications and examples, if you'd like to learn more, check out [Ownership in the Cairo book](https://cairo-book.github.io/ch03-00-understanding-ownership.html).

### Simple types

For simple primitives with known size, they are simply copied when used multiple times. Consider this example,

```rust
let x = 25_u32;
my_function(x);
my_second_function(x);
```

Here we bind `u32` value `25` to `x`. Then pass it to `my_function`. Then when it's passed to `my_second_function` the value is copied.

### Complex types

Now let's see what happens with more complex values.
Let's say we have a struct that looks like this...

```rust
struct MyStruct {
	x: u32,
	y: u32
}
```

Now using a `MyStruct` value for `x` with the same code,

```rust
let x = MyStruct{ x: 25_u32, y: 20_u32 };
my_function(x);
my_second_function(x);
```

#### We get a few errors,

1. error: Variable not dropped...
2. error: Variable was previously moved...

#### Variable not dropped

All the values need to be dropped when they go out of scope, the functionality for this dropping is implemented by `Drop` trait.
So updating `MyStruct` to derive `Drop` fixes that for us.

```rust
#[derive(Drop)]
struct MyStruct {
	x: u32,
	y: u32
}
```

All custom types need to derive `Drop` so they can be dropped when they go out of scope.

#### Variable was previously moved

For the second error, let's see what's going on.

First we add a variable `x` with a value of type `MyStruct`. Now this function owns the variable `x`.
Then we pass it to function `my_function()`. Now the ownership is passed to `my_function` scope.
On the third line we try to re-use variable `x` but it is no longer owned by this function. So we get the error that the value was `moved` and can't be used again, which is our second error.

There are at least two ways to address this issue,

1. Transfer ownership of the variable back to the parent scope by returning the value.
2. Derive `Copy` trait to pass a Copy of the value

### Return to transfer back the ownership

Function `my_function` could at the end of it's business with `x` return it back to the caller.

```rust
fn my_function( x: MyStruct ) -> MyStruct {
   // Does some stuff
   x // Returns back x
}
```

Then the caller could bind the returned value to any variable, like this...

```rust
let x = MyStruct{ x: 25_u32, y: 20_u32 };
let x = my_function(x); // Notice re-binding x to returned value
my_second_function(x);
```

Now, if function `my_function` is already supposed to return something, You could use a `tuple` to return multiple values or derive `Copy` as discussed in the next seciton.

### Derive `Copy` to pass copies

Deriving `Copy` for your type will allow you to pass copies of the value, allowing you to use them for multiple functions.

```rust
 #[derive(Copy, Drop)]
 struct MyCopyableStruct{
     x: u32,
     y: u32,
 }
```

Then, this will be just fine

```rust
let x = MyCopyableStruct{ x: 25_u32, y: 20_u32 };
my_third_function(x);
my_fourth_function(x); // Passed the second time, easy!
```
