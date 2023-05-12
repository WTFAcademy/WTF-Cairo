# WTF Cairo: 16. Assert

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.wtf.academy)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we explore Assert in Cairo. 

## Assert

Assert is used to handle Error message and access controls in contract,You can create custom errors in Cairo, which are outputted to the user upon failed execution. This can be very useful for implementing checks and proper access control mechanisms.

With Cairo 1.0, you can easily do this using the assert statement in a similar pattern to the require statement in Solidity:

```rust
assert(sender != 0, 'ERC20: transfer from 0');
```

Where the error message must be less than 31 characters.

## Summary

In this chapter, we introduced Assert in Cairo 1.0. assert in Cairo is similar with require in Solidity.