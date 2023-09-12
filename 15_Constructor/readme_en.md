# WTF Cairo: 15. Constructor

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will explore `constructor` function in Cairo, a special function that initializes the state variables of a contract.

## Constructor

Same as Solidity, the `constructor` in Cairo is a special function which will automatically run once during the contract deployment.  It is often used to initialize the parameters of a contract, such as setting the `owner` address:

```rust
#[contract]
mod owner{
    // import contract address related libraries
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    // Define storage variable
    struct Storage{
        owner: ContractAddress,
    }

    // Set owner address during deployment
    #[constructor]
    fn constructor() {
        owner::write(get_caller_address());
    }
}
```

In the above contract, we've defined a storage variable `owner` within the `Storage` struct. This `owner` is then initialized in the `constructor` function to the address of the caller.

### Rules

1. The `constructor` function must be marked with the `#[constructor]` attribute.
2. Each contract can have, at most, one `constructor`.


## Summary

In this chapter, we introduced the `constructor` function in Cairo. This special function will automatically run once during contract deployment, setting the stage for state variables of the contract.