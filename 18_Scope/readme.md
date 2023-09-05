# WTF Cairo: 18. Ownershipt I: Scope

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will explore the concept of Ownership in Cairo, starting with the fundamental idea of scope.

## Ownership

Cairo employs the ownership system from Rust to achieve memory safety and high performance. 

In Cairo, every piece of data has a single "owner", and the scope of this owner determines the lifetime of the value. When the owner goes out of scope, Cairo automatically cleans up the value and any resources it was using, which is a process known as "dropping".

The rules of ownership in Cairo are as follows:

1. Each value in Cairo has a variable that's called its owner.
2. There can only be one owner at a time.
3. When the owner goes out of scope, the value will be dropped.
4. A value cannot go out of scope unless it has been previously moved.

## Scope

To comprehend Rule #3, we must first understand what "scope" means. 

In Cairo, a scope is a section of your code where a variable is valid and can be used. It is defined by a pair of curly brackets `{}`. When a variable comes into scope, it is valid until it goes out of scope. When it goes out of scope, its value is dropped and any memory or resources it held are freed.

Here's a simple example of function scope:

```rust
fn scope_function() {
    let x = 'hello';   // x comes into scope

    // x can be used here
    let y = x;

} // x goes out of scope and is dropped here
```

In this example, the variable `x` comes into scope at the point where it is declared. It remains in scope for the duration of the `scope_function` function, and then it goes out of scope at the end of `scope_function`. At that point, its value is dropped.

In Cairo, you can create nested scopes within a function. A nested scope is created with a new set of curly brackets `{}`. Variables created in the inner scope are not accessible in the outer scope. 

```rust
fn scope_nested() {
    let outer_var = 'outer'; // outer_var is in the outer scope

    {
        let inner_var = 'inner'; // inner_var is in the inner scope
    }

    // inner_var is out of scope here

    // outer_var is still in scope here
    let x = outer_var;
}
```

In all these examples, you can see that the scope of a variable is determined by where it is declared. Once a variable goes out of scope, Cairo automatically cleans up any resources associated with that variable.


## Summary

In this chapter, we introduced the rules of ownership and the concept of scope in Cairo. We will explore the concept of "Move" in the next chapter.
