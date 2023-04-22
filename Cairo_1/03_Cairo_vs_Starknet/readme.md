# Cairo vs Starknet

In this chapter we are going to learn about the difference between Cairo and Starknet.

## What is Starknet?

Starknet is a permissionless decentralized Validity-Rollup (also known as a “ZK-Rollup”). It operates as an L2 network over Ethereum, enabling any dApp to achieve unlimited scale for its computation – without compromising Ethereum’s composability and security, thanks to Starknet’s reliance on the safest and most scalable cryptographic proof system – STARK.

## What is Cairo?

Cairo is a Turing complete programming language for creating STARK-provable programs for general computation. **Cairo is the native smart contract language for Starknet**, a permissionless decentralized Validity-Rollup.

Cairo 1.0 is the upgraded Rust-inspired version of Cairo, allowing developers to write Starknet smart contracts in a safe and convenient manner.

## So, what's the difference

Cairo is a programming language for writing provable programs, where one party can prove to another that a certain computation was executed correctly. Cairo and similar proof systems can be used to provide scalability to blockchains.

StarkNet uses the Cairo programming language both for its infrastructure and for writing StarkNet contracts. 

## How to programming in Cairo

Let's see the following example and analize how it works.

```
// Calculates fib...
fn fib(a: felt252, b: felt252, n: felt252) -> felt252 {
    match n {
        0 => a,
        _ => fib(b, a + b, n - 1),
    }
}
```
In this program, we wan to calculate the fibonacci number.
 
- First, the function receives three arguments: `a`, `b` and  `n`, this are felt type.
- Then, the `match` label is going to compare the value that we receive in n.
    - if this value is equal to n, then returns a. Otherwise, we call recursively the function. 

If you know rust, you can compare Cairo vs. Rust programs


## How to write StarkNet contracts

Let's use this example to understand the new format to write a Starknet Contract

```
#[contract]
mod SimpleStorage {
   struct Storage {
       balance: felt252
   }

   #[event]
   fn BalanceIncreased(balance: felt252) {}

   #[external]
   fn increase_balance(amount: felt252) {
      let new_balance = balance::read() + amount;
      balance::write(new_balance);
      BalanceIncreased(new_balance);
   }

   #[view]
   fn get_balance() -> felt252 {
       balance::read()
   }
}
```

- `#[contract]` is a macro to indicate that this is a Starknet Contract. 
- `mod` keyword which implies that it's a module containing some logical piece of code. 
-  `struct Storage` create a store variable on-chain.
- `#[event]` is a new feature in Cairo 1.0. You define an event just like a function with the name of the event and the values you would like to emit within the bracket as argument. 
- `#[external]` this macro means that the function can be called externally or outside the contract. In the followinf chapters we will talk about the different macros and how to use it.
- `#[view]` with this macro the function can read the values but not modify any variables.
- `::read()` and `::write()` with this functions we read and write in the storage variable. 

In the following chapters we will see in more detail each of these new features in Cairo 1.0.







