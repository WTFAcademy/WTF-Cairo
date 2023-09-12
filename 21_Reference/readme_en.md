# WTF Cairo: 21. Ownership IV: Reference

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will delve into the use of reference in Cairo.

## Working with References

Mutable references in Cairo are used when we want a function to change the value of a parameter while retaining its ownership. Mutable references are implicitly returned at the end of a function's execution. This behavior allows the value to be modified by the function, while still being available in the scope from which the function was called.

You can use the `ref` keyword to create a mutable reference. 

```rust
use array::ArrayTrait;

fn reference_example(){
    let mut x = ArrayTrait::<felt252>::new();  // x comes into scope
    use_reference(ref x); // pass a mutable reference of x to function
    let y = x; // this works     
}

fn use_reference(ref some_array: Array<felt252>) {
}
```

In Cairo, only mutable variables can be marked with `ref`, as they are implicitly updated at the end of the function. As a result, the following code will fail to compile:

```rust
// immutable variable can't be passed as reference
let z = ArrayTrait::<felt252>::new(); 
use_reference(ref z); 
// error: Plugin diagnostic: ref argument must be a mutable variable.
```

Please note that mutable references in Cairo differ from references in Rust.

## Summary

In this chapter, we explored mutable references in Cairo, furthering our understanding of how this language manages variable ownership and modification. By incorporating mutable references into your coding toolkit, you're well-equipped to write more flexible and efficient Cairo programs.