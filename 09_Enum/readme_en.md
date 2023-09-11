# WTF Cairo: 9. Enum

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce `enum` (enumeration) in Cairo.

## Enum in Cairo

Enums in Cairo are a means to define a set of named values, or variants, each with an associated data type. Utilizing enums can enhance code readability and reduce errors.

Enums are defined using the `enum` keyword, followed by a given name with the first letter capitalized.

```rust
#[derive(Drop, Serde)]
enum Colors { 
    Red: (), 
    Green: (), 
    Blue: (), 
}
```

Unlike Rust, variants in Cairo enums have associated types. In the example above, the `Red`, `Green`, and `Blue` variants in the `Colors` enum have unit types `()`. In the following example, we define an `Actions` enum with different variant types:

```rust
#[derive(Copy, Drop)]
enum Actions { 
    Forward: u128, 
    Backward: u128, 
    Stop: (),
}
```

### Creating Enum Variants

You can create an enum variant using the following syntax:

```rust
let forward = Actions::Forward((1_u128));
```

### Returning Enums in Functions

Enums can be returned in functions:

```rust
// Return red color
#[view]
fn get_red() -> Colors {
    Colors::Red(())
}
```

## Summary

In this tutorial, we've covered how to define enums, create enum variants, and return enums in functions. This knowledge will help you to create more readable and error-resistant code in Cairo.

