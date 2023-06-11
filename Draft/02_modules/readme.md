# Modules

In Cairo, functions and modules are used to structure the code and define reusable pieces of logic. They are similar to Solidity functions and contracts, but there are some differences in their implementation and usage.

In this chapter, we are going to focus in modules and how to use it. 

## How to define a module

Cairo modules are used to group related functionality under a namespace. A module is defined using the `mod` keyword, followed by the module name and a block of code containing functions and other declarations. Modules can import other modules and use their functionality.

An example of a Cairo module:

```shell
#[contract]
mod Vote {
    // Core Library Imports
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use array::ArrayTrait;

    // Other declarations and functions
}
```

In this example, the `Vote` module imports other modules like `starknet` and `array`.

## Comparison with solidity

To declare a module in Cairo, we define it using the `mod` keyword, while Solidity utilizes the `contract` keyword to establish a contract.

As in solidity with `import` and `is` keywords, in Cairo we can incorporate external contract or libraries during compilation using `use` keywork, making all functions from the imported module accessible within the importing module. 

Also, Cairo modules serve as namespaces for related functionality. In Solidity, contracts themselves act as namespaces for their functions and variables.

## Conclusion

In this chapter, we learn how to declare a module. Using modules we are capable to organice a project. To import modules, you can use the `use` keyword, followed by the path to the item you want to import.
