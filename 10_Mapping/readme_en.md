# WTF Cairo: 10. Mapping and other types

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce `mapping` and other useful types in Cairo.

## Mapping in Cairo

The `mapping` type enables users to query a corresponding `Value` using a `Key`. For instance, you can query the balance of an account by its address. In Cairo, the `LegacyMap` is used to create `mapping`.

In the example below, we create a mapping in storage variables called `balances`. This mapping stores the balances (values of type `u256`) for corresponding addresses (keys of type `ContractAddress`).

```rust
// balances storage variable: map from account address to u256
struct Storage {
    balances: LegacyMap::<ContractAddress, u256>,
}
```

You can query the balance of a given address. Note that Cairo does not natively support an `address` type like Solidity. Instead, you need to import it with `use starknet::ContractAddress;`.

```rust
// read balance
#[view]
fn read_balance(account: ContractAddress) -> u256 {
    balances::read(account)
}
```

The balance of a given address can be updated using the following function:

```rust
// update balance
#[external]
fn write_balance(account: ContractAddress, new_balance: u256) {
    balances::write(account, new_balance);
}
```

## Summary

In this chapter, we've discussed how to use the `mapping` type and other useful types in Cairo to create and manage key-value pairs in smart contracts. These concepts will help you develop more efficient and organized smart contracts on Starknet.
