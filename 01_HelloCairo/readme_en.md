# WTF Cairo: 1. Hello Cairo!

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

## Introduction to Cairo

`Cairo` is the programming language for smart contracts on Ethereum's ZK-Rollup scaling solution, StarkNet. It is also used to write provable programs. Cairo has two main features:

ZK-friendly: `Cairo` is a Turing-complete programming language for general provable computation, which can be compiled into Stark-provable programs.

Hard to learn: `Cairo` has a steep learning curve and is currently in its early stages of development, with significant changes between versions.

The current version of `Cairo` is `1.0.0`, which is based on Rust. And it is significantly different from the previous 0.x versions.


## Development Tooling: Cairo CLI


Since `Cairo` is still in the early stages of development, the tools are constantly updated. Here, we use the Cairo CLI (Command Line Interface) to compile contracts.


### Configure Environment

To use the `Cairo CLI`, we need to install Rust and clone the Cairo repo.

1. Download [Rust](https://www.rust-lang.org/tools/install)

2. Install Rust:

    ```shell
    rustup override set stable && rustup update
    ```

3. Verify that Rust is installed correctly:

    ```shell
    cargo test
    ```

4. Clone the Cairo repo locally:

    ```shell
    git clone https://github.com/starkware-libs/cairo
    ```

### Compile Contracts

1. Switch to the Cairo repo folder locally:
    ```shell
    cd cairo
    ```

2. Use the following command to compile the Cairo contract into a Sierra ContractClass。 Replace `/path/to/input.cairo` with the contract file directory, and `/path/to/output.json` with the directory of the compiled output file.:

    ```shell
    cargo run --bin starknet-compile -- /path/to/input.cairo /path/to/output.json
    ```



## Hello Cairo

Our first Cairo contract is very simple, consisting of just 7 lines of code:

```rust
#[contract]
mod HelloCairo {
    #[view]
    fn hello_cairo() -> felt252 {
        return 'Hello Cairo!';
    }
}
```

We'll break it down and analyze the structure of a Cairo contract file:

Line 1 uses the `#[contract]` attribute to declare the code as a `StarkNet` contract. If not declared, it cannot be deployed on `StarkNet`.

```rust
#[contract]
```

Line 2 uses the `mod` keyword to create a contract module called `HelloCairo`. This is similar to `mod` in `Rust`, which is a collection of items, including structs, functions, etc.

```rust
mod HelloCairo {
}
```

Then, we wrote a function called `hello_cairo`. On line 3, we use the `#[view]` attribute to decorate the state mutability of the function. Similar to `view` in `solidity`, this function can be called externally, but can only read but not modify the state.

```rust
#[view]
```

Lines 4-6 declare the `hello_cairo` function. It has no parameters and returns a single value of type `felt252`. `felt` (field element) is one of the primitive types in `cairo`, and short strings are also represented by it. We will discuss this in detail in later chapters. In the function body, we set the return value to short string `'Hello Cairo!'`.

```rust
fn hello_cairo() -> felt252 {
    return 'Hello Cairo!';
}
```

## Compile and Deploy Code

Save the above contract code to a `HelloCairo.cairo` file, and use the `Cairo CLI` to compile it (be sure to do this in the root directory of the cairo repo):

```shell
cargo run --bin starknet-compile -- ./HelloCairo.cairo ./HelloCairo.json
```

After successful compilation, we can see a file called `HelloCairo.json`, with the `abi` section as follows:

```json
  "abi": [
    {
      "type": "function",
      "name": "hello_cairo",
      "inputs": [],
      "outputs": [
        {
          "type": "core::felt252"
        }
      ],
      "state_mutability": "view"
    }
  ]
```

From the contract abi, we can see that the Cairo contract `HelloCairo` contains an external function `hello_cairo` with no parameters and a return value of type `felt252`. The function's state mutability is set to `view` (read-only).

## Conclusion

In this tutorial, we briefly introduced `Cairo 1.0` and compiled our first `Cairo` smart contract - `Hello Cairo`. In the future, we will continue our journey with `Cairo`!

## References

1. [Cairo Docs](https://www.cairo-lang.org/docs/v1.0/)
2. [Starkling Cairo1](https://github.com/shramee/starklings-cairo1)
3. [Starknet Cairo 101](https://github.com/starknet-edu/starknet-cairo-101)