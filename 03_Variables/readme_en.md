# WTF Cairo: 3. Variables

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce 2 types of variables in Cairo, `local` and `storage`.

## Local Variables

`local` variables are declared within functions. They are temporary and not stored on-chain.

```rust
// local variables
#[view]
fn local_var(){
    // use `let` keyword to declare local variables 
    let local_felt: felt252 = 5;
    let local_bool;
    local_bool = true;
    let local_uint = 1_u8;
}
```

## Storage Variables

Similar to Solidity, Cairo supports `storage` variables. They are stored on-chain and declared in a special structure called `Storage` within the contract. Each contract can have at most 1 `Storage` structure.

```rust
// declare storage variables
struct Storage{
    var_felt: felt252,
    var_bool: bool,
    var_uint: u8,
}
```

Each storage variable has 2 member functions: `read()` and `write()`. All `storage` variables are `private` by default. You need to declare read and write functions explicitly to make them public.

```rust
// read storage variable
#[view]
fn read_bool() -> bool {
    return var_bool::read();
}

// write storage variable
#[external]
fn write_bool(bool_: bool) {
    var_bool::write(bool_);
}
```

## Summary

In this chapter, we delved into `local` and `storage` variables in Cairo.