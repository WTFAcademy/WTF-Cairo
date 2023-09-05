# WTF Cairo: 22. Ownership V: Snapshot

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we will delve into the concept of snapshots in Cairo, exploring how to create and utilize snapshots, and how they interact with Cairo's ownership system.

## Working with Snapshots

In Cairo, snapshots are immutable views of a value at a specific time. You can pass a snapshot of a value to a function, while retaining the ownership of the original value.
 
Let's illustrate this with an example function, `get_length()`, which calculates the length of an array. This function takes a snapshot of an array as a parameter, allowing us to maintain ownership of the array in the calling context:

```rust
use array::ArrayTrait;

fn snapshot_example(){
    let x = ArrayTrait::<felt252>::new();  // x comes into scope
    let x_snapshot = @x;
    let len = get_length(x_snapshot); // pass a snapshot of x to function
    let y = x; // this works     
}

// get the length of the array
fn get_length(some_array: @Array<felt252>) -> usize{
    some_array.len()
}
```

In the code above:

- The `get_length()` function takes the snapshot of an array as a parameter with the snapshot operator `@`.
- We create a snapshot of `x` with the `@` operator and pass it to the `get_length()` function.
- Importantly, since we passed a snapshot to the `get_length()`, the function should not mutate the array.
- The ownership of the array remains with `x` in the `snapshot_example` function, demonstrating snapshots' role in preserving ownership.

## Desnap a Snapshot

You can convert snapshots back to regular values with `desnap` operator `*`. Consider a scenario where we need to calculate the area of a rectangle but don't want to take ownership of the rectangle within our calculation function. Here's how you can do it:

```rust
#[derive(Copy, Drop)]
struct Rectangle {
    height: u64,
    width: u64,
}

fn desnap_example() {
    // create an Rectangle struct
    let rec = Rectangle { height: 5_u64, width: 10_u64 };
    // pass the snapshot of rec to function
    let area = calculate_area(@rec);
}

fn calculate_area(rec: @Rectangle) -> u64 {
    // use the desnap operator `*` get underlying values
    *rec.height * *rec.width
}
```

In the `calculate_area()` function, we use the `desnap` operator (`*`) to convert the snapshots back into regular values. This is possible only if the type is copyable. Note that arrays in Cairo are not copyable and hence cannot be 'desnapped' using the `*` operator.

## Summary

In this tutorial, we have explored snapshots in Cairo, a powerful feature that enables efficient management of ownership. By understanding snapshots, you can ensure safer function calls and maintain control over the data in your code.