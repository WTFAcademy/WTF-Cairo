# WTF Cairo: 15. Event

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.wtf.academy)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we explore Evnets in Cairo. 

## Event

Event allow a contract to emit infomation during the course of its execution that can be used outside of Starknet

An event can be created like this:

```rust
#[event]

fn Transfer(from_: felt, to: felt, value: u256) {}
```

The event can accept three arguments without returns

## Summary

In this chapter, we introduced Event in Cairo. We learned that how to define an events in a contract.