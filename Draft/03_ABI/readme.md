# Interfaces and ABI

The ability of contracts to interact with other smart contracts on the blockchain is a common pattern found in smart contract development.

In this chapter you will learn about interfaces and ABIs to understand how cross-contract interactions between Starknet contracts can be achieved. 

## Interfaces

An interface is a list of a contract's function definitions (name, parameters, visibility and return value) contained in a smart contract without implementations. 

Interfaces in Cairo are traits with the `#[abi]` attribute. 

For your Cairo code to qualify as an interface, it must meet the following requirements:

1. Must be appended with the #[abi] attribute.
2. Your interface functions should have no implementations.
3. You must explicitly declare the function's decorator.
4. Your interface should not declare a constructor.
5. Your interface should not declare state variables.

For example, let's declare a simple ERC20 Interface: 

```shell
use starknet::ContractAddress;

#[abi]
trait IERC20 {
    #[view]
    fn name() -> felt252;

    #[view]
    fn symbol() -> felt252;

    #[view]
    fn decimals() -> u8;

    #[view]
    fn total_supply() -> u256;

    #[view]
    fn balance_of(account: ContractAddress) -> u256;

    #[view]
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;

    #[external]
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn approve(spender: ContractAddress, amount: u256) -> bool;
}
```

## ABI

An ABI (Application Binary Interface) gives a smart contract the ability to communicate and interact with external applications or other smart contracts. 

While we write our smart contract logics in high-level Cairo, they are stored on the VM as executable bytecodes which are in binary formats. Since this bytecode is not human readable, it requires interpretation to be understood. This is where ABIs come into play, defining specific methods which can be called to a smart contract for execution.

Every contract on Starknet has an ABI that defines how to encode and decode data when calling its methods.

# Conclusion

Cross-contract interactions between smart contracts on a blockchain is a common practice which enables us to build flexible contracts that can speak with each other.

In the next chapter, we are going to be looking into how we can call other smart contracts using a Contract Dispatcher, Library Dispatcher, and System calls.