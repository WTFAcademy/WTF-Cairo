# WTF Cairo: 6. Tuple

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce tuples in Cairo, discussing their use as function arguments and return values.

## Tuple

A tuple is a collection of values of different types. Tuples are constructed using parentheses `(),` and each tuple itself is a value with a type signature (`T1`, `T2`, ...), where `T1`, `T2` represent the types of its members. Functions can use tuples to return multiple values, as tuples can hold any number of values.

Here's an example of the `reverse()` function. It accepts a tuple with `u32` and `bool` type parameters and returns another tuple with a reversed order.

```rust
#[contract]
mod tuple_reverse {
    // Tuples can be used as function arguments and as return values.
    #[view]
    fn reverse(pair: (u32, bool)) -> (bool, u32) {
        // Unpacking: `let` can be used to bind the members of a tuple to variables.
        let (integer, boolean) = pair;
        return (boolean, integer);
    }
}
```

## Unit

Unit type, also called the `()` type, is a special tuple with no elements and with a length of zero. It is commonly used in `enum`.


## Summary

In this chapter, we explored tuples in Cairo, covering their use as function arguments and return values, as well as how to unpack them.