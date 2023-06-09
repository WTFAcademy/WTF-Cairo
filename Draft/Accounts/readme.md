# WTF Cairo: . Accounts

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.wtf.academy)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---
In this chapter we will be talking about how  accounts are implemented in cairo

## Starknet Accounts

### All accounts on starknet are smart contracts

Having accounts as smart contracts allows accounts to have arbitary logic associated with them.

Enabling developers to be able to customize accounts in whatever way they like .This enables things like:

1. Signing transactions with your Fingerprint or Face id on your phone
1. Easy Account recovery e.g social recovery e.t.c
1. Fraud Monitoring
e.t.c

## Account Contracts

To signify that a contract is an account and not a regular contract ,we first have to add the #[account_contract] attribute to the contract.

```rust

    #[account_contract]
    mod Account{
       //logic for account goes here
    }

```

If it were a regular contract  like an ERC20 or ERC721 contract we would add the #[contract] attribute instead.

```rust

    #[contract]
    mod Account{
       //logic for contract goes here
    }

```

## Account Interface

Although accounts are customizable there are some function that every account contract must implement

All accounts must implement these functions

- `__validate__`
- `__execute__`

## `__validate__`

This function is called to verify the signature associated with an account. It contains arbitrary logic for verifying signatures.

To get all transaction information including the signature , we use the `get_tx_info` function from starknet

```rust
  use box::BoxTrait;

  let tx_info =starknet::get_tx_info().unbox();
  let signature =tx_info.signature;
  let transaction_hash =tx_info.transaction_hash;

```

starknet calls your `__validate__` function to verify your accounts's signature

```rust

#[account_contract]
mod Account{
fn __validate__ ()->felt252{
  let tx_info =starknet::get_tx_info().unbox();
  let signature =tx_info.signature;
  let transaction_hash =tx_info.transaction_hash;
  assert(logic_that_verifies_signature(transaction_hash,signature),'ERROR : INVALID SIGNATURE')
  starknet::VALIDATED
  
}

}

```
```starknet::VALIDATED ``` is a constant provided by the core library we return if validation is sucessful

The `__validate__` function by default has a gas limit ,constraining the logic you can put in there .This is to prevent DDos attacks ..
if the `__validate__` function is sucessful then the execute function is called..

### Other Validation functions

#### `__validate_declare__` 
This function validates your signature when you declare a contract ,
but it has the same logic as the `__validate__` function

#### `__validate_deploy__` 
This function validates your signature when you deploy  a contract ,
but it also has the same logic as the `__validate__` function



## `__execute__`

This function is the entrypoint to calling external contracts .It is how your contract interacts with other contracts.

It is called if the `__validate__` function is  sucesssful.

This function is basically a muticall function that calls one or more contracts sequentally .

it takes an array of a Contract call struct.


```rust
use starknet::ContractAddress;

struct Call {
    to : ContractAddress,
    selector: felt252,
    calldata :Array<felt252>
}
```


```rust
#[account_contract]
mod Account {
   use super::Call;
   use array::ArrayTrait;
   use array::panTrait;
   use zeroable::Zeroable;
   use starknet::contract_address::ContractAddressZeroable;
    
    fn __execute__(calls:Array<Call>) -> Array<Span<felt252>>{
           //the caller of the contract
           let caller = starknet::get_caller_address();
          //    verifies that the caller is not the zero address
           assert(caller.is_zero(),'ERROR: CALL FROM ZERO ADDRESS');
           multi_contract_calls(calls,ArrayTrait::new())

            

            
}
fn multi_contract_calls(mut calls:Array<Call>,mut result:Array<Span<felt252>>)->Array<Span<felt252>>{
    //pop_front removes the first element in the array
    //it returns an Option
    match calls.pop_front(){
                //destructuring the Option
                Option::Some(call)=> {
                    let res=single_contract_call(call);
                    //uses recursion beacause loops are not fully supported currently
                     result.append(res);
                     //uses recursion beacause loops are not fully supported currently
                    return multi_contract_calls(calls,result);

                },
                Option::None(_) => {return result;}
    }
}

 fn single_contract_call(call:Call)->Array<Span<felt252>>{
    let Call { to ,selector , calldata} = calls;
    starknet::call_contract_syscall(to,selector,calldata.span()).unwrap_syscall()
 }

}

```

## Account Standard Api

In other to for there to be compatability between different Accounts ,an Account standard will be created most likely by openzeppelin

it will contain the common functionality expected from an account.

### Below is a mock example of an Account standard api

```rust
    trait IAccount {
        fn get_public_key() -> felt252;
    
        fn supports_interface(interfaceId: felt252) -> bool;
        

        fn set_public_key(newPublicKey: felt252)->();

        fn is_valid_signature_(message_hash: felt252,signature: Span<felt252>) -> bool;

    fn __validate__(calls:Array<Call>)->felt252;
    
    fn __validate_declare__(calls:Array<Call>)->felt252;
        
    fn __execute__(calls:Array<Call>)->Array<Span<felt252>>;
}
```

## Conclusion

You can add any other logic or function to your account depending on your account needs, but the `__validate__` and  `__execute__` functions are compulsory and must be implemented
