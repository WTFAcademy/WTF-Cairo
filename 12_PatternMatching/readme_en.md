# WTF Cairo: 12. Pattern Matching

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will explore pattern matching with `match` keyword in Cairo. It provides a powerful and safe mechanism for handling different possible values of a type, typically an enum.

## `match` expression

The `match` keyword in Cairo is a powerful control flow operator that allows you to handle different possible values of an enum in a clear and concise way. It's similar to a `switch` statement in other languages, but it's more expressive and safer.

A `match` expression is made up of arms, Each arm consists of a pattern and the code that should be executed if the value given to the beginning of the `match` expression fits that arm's pattern. The code of the first pattern that matches the value is executed.

Here is a simple example of a `match` expression:

```rust
#[derive(Drop, Serde)]
enum Colors { 
    Red: (), 
    Green: (), 
    Blue: (), 
    }  

// match pattern (Colors)
#[view]
fn match_color(color: Colors) -> u8 {
    match color {
        Colors::Red(()) => 1_u8,
        Colors::Green(()) => 2_u8,
        Colors::Blue(()) => 3_u8,
    }
}

// match color example, should return 1_u8
#[view]
fn match_red() -> u8 {
    let color = get_red();
    match_color(color)
}
```

This example uses a `match` expression to process different `Colors` enum variants. The `match` expression evaluates the `color` variant and executes the corresponding code depending on the variant.

### Rules 

 
1. Every arm in a `match` expression includes a pattern and its associated code, separated by the `=>` operator.
2. `match` is exhaustive in Cairo, meaning you must cover all possible values of the type.
3. The order of the arms must follow the same order as the enum.
4. Use `{}` to wrap the arm code if it has multiple lines.

### Pattern binding

In Cairo, pattern binding allows you to break down data types asscociated with your data, such as enums or structs, and bind the inner parts of these data types to variables. This is particularly useful in a `match` expression, where different patterns can be matched and their inner values can be used in the corresponding code block.

```rust
#[derive(Drop, Serde)]
enum Actions { 
    Forward: u128, 
    Stop: (),
}

// match pattern with data (Actions)
#[view]
fn match_action(action: Actions) -> u128 {
    match action {
        Actions::Forward(dist) => dist,
        Actions::Stop(_) => 0_u128,
    }
}
```

In this example, `dist` is a pattern that binds to the value inside the `Forward` variant of the `Actions` enum. When `action` matches `Actions::Forward(dist)`, the variable `dist` gets assigned the value inside the `Forward` variant and can be used inside the match arm. Moreover, the underscore `_` acts as a placeholder to match any value without binding the value to a variable.

## Summary

In this chapter, we introduced Cairo's `match` keyword for pattern matching, providing clear, concise handling of enum values. We explored the exhaustive nature of `match` expressions and the utility of pattern binding, which breaks down complex data types, binding their inner parts to variables, enhancing code readability and efficiency.
