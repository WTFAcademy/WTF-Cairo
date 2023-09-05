# WTF Cairo: . System Calls

We are learning `Cairo`, and write `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.gg/5akcruXrsk)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85mizdw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In these Chapter we will be learning about system calls in cairo

## System Calls

Starknet provides us with low level function in cairo to perform certian operations specific to starknet

For example :

1. Calling other contracts within a contract
1. Deploying a contract
1. getting information about the current starknet blockchain state e.g block_hash ,contract caller , transaction information e.t.c.

system calls under the hood are written in Seirra (the language cairo compliles down into ) and not in cairo,this is for performance reasons

All syscalls can be found in the starknet  module

To use a sycall you first have to import it


##### For example

```rust
use starknet::call_contract_syscall
use starknet::deploy_syscall
 ```

## ```call_contract_syscall```

This syscall is used to call another contract within a contract it allows cross contract interactions

it takes three arguments

- ```address : ContractAddress```
- ```entry_point_selector: felt252```
- ```calldata : Span<felt252>```

| Arguments    | Description|
| -------- | ------- |
| address  | The address of the contract you want to call.   |
| entry_point_selector| The signature or selector of a function in the contract you are about to call e.g ```tranfer()```|
| calldata  | An array of the contract call data or arguments  |

##### Example

```rust

call_contract_syscall(address,entry_point_selector,calldata);
 ```

It returns a response ```SyscallResult<Span<felt252>>```

To get the syscall result use the ```.unwrap_syscall()``` method

## ```deploy_syscall```

This syscall is used to deploy a contract within a contract .It deploys an instance of an alraedy decleared  class hash .

##### ```Note!!!: The class hash of the contract has to be decleared already```

it takes four arguments

- ```class_hash: ClassHash```
- ```contract_address_salt: felt252```
- ```calldata : Span<felt252>```
- ```deploy_from_zero: bool```

| Arguments    | Description|
| -------- | ------- |
| class_hash  |  The class hash of the contract to be deployed   |
| contract_address_salt| A random  value used in the creation of the contract|
| calldata  | An array of the constructor calldata |
| deploy_from_zero  | If true the zero address is used in the generating the contract address, if false the caller address is used|

##### Example

```rust
deploy_syscall(
    class_hash
    contract_address_salt,
    calldata,
    true
);
 ```

It returns a response ```SyscallResult<(ContractAddress, Span::<felt252>)>```

To get the syscall result use the ```.unwrap_syscall()``` method

## ```library_call_syscall```

This syscall is the equavalent to delegate call in solidity . It allows you to use a decleared class hash as a library for another contract i.e .Using code defined elsewhere in your contract.

##### ```Note!!!: The class hash  has to be decleared  already```

it takes three arguments

- ```class_hash: ClassHash```
- ```entry_point_selector: felt252```
- ```calldata : Span<felt252>```

| Arguments    | Description|
| -------- | ------- |
| class_hash  |  The class hash you want to use  |
| entry_point_selector| A signature or selector for a function in that class e.g ```tranfer()```|
| calldata  | An array of  call data or arguments  |

##### Example

```rust
library_call_syscall(class_hash,entry_point_selector,calldata);
 ```

It returns a response ```SyscallResult<Span<felt252>>```

To get the syscall result use the ```.unwrap_syscall()``` method

## ```replace_class_syscall```

This syscall replaces the current class hash  of a contract with a new class hash which is specified.
i.e swaps the current contract code for another
It is used in upgrading contracts.

##### ```Note!!!: After calling replace_class_syscall, the code currently executing from the old class hash will finish running.The new class has will be used from the next transaction onwards or if the contract is called via the call_contract syscall in the same transaction (after the replacement).```

it takes only one argument

- ```class_hash: ClassHash```

| Arguments    | Description|
| -------- | ------- |
| class_hash  |  The new class hash you want to replace the old one with |

##### ```Note!!!: The new class hash has to be decleared first```

##### Example

```rust
replace_class_syscall(class_hash)
 ```

This syscall doesnt return anything.

## ```get_execution_info_syscall```

This syscall is the singular syscall for getting all block,transaction,execution information
including:

1. getting contract address
1. getting transcation info e.tc

##### Example

```rust
get_execution_info_syscall();
 ```

It returns a response ```SyscallResult<Box<starknet::info::ExecutionInfo>>```.

To get the syscall result we  have call both ```.unwrap_syscall().unbox()``` methods

After unwrapping and unboxing we get back an ```ExecutionInfo``` struct

```rust
struct ExecutionInfo {
    block_info: Box<BlockInfo>,
    tx_info: Box<TxInfo>,
    caller_address: ContractAddress,
    contract_address: ContractAddress,
    entry_point_selector: felt252,
}
 ```

## ```send_message_to_l1_syscall```

This syscall is used to send messages to l1 contracts allowing communication between contracts on ethereum and starknet using starknet as a bridge

it takes two arguments

- ```to_address: felt252```
- ```payload: Span<felt252>```

| Arguments    | Description|
| -------- | ------- |
| to_address  |  The recipient’s L1 address|
| payload  |  An array of messages to be sent |

##### Example

```rust
send_message_to_l1_syscall(to_address, payload);
 ```

This syscall doesnt return anything.

## ```storage_write_syscall```

This syscall write to storage in a particular contract .It is the low  level way of writing storage. Useful when writing your own custom storage variable with your own implementation.

it takes three arguments

- ```address_domain: u32```
- ```address: StorageAddress```
- ```value: felt252```

| Arguments    | Description|
| -------- | ------- |
| address_domain:  | Data location or data avalability mode where your data would be made avaliable i.e..either on ethereum or offchain|
| address |  A defined storage address you want to write to |
| value|  The value to write to storage|

##### ```Note!!!: The default address_domain is 0 ,representing using ethereum for data avalability```

##### ```Note!!!: You have  to define a storage address```

#### Defining a storage address

```rust
let storage_address = storage_base_address_from_felt252(3534535754756246375475423547453)
 ```

#### Writing to storage

```rust
storage_write_syscall(0, storage_address, 'Hello') 
 ```

##### ```Note!!!: You can also  a write non felt252 values by converting them to felts```

##### Example

```rust
use traits::Into;


let age =25_u32;

storage_write_syscall(0, storage_address,age.into()) ;
 ```

This syscall doesnt return anything.

## ```storage_read_syscall```

This syscall reads a particular value from storage in a particular contract .It is the low level way of reading  from storage. Useful when writing your own custom storage variable with your own implementation.

it takes two arguments

- ```address_domain: u32```
- ```address: StorageAddress```

| Arguments    | Description|
| -------- | ------- |
| address_domain:  | Data location or data avalability mode where your data would be made avaliable i.e..either on ethereum or offchain|
| address |  A defined storage address you want to read from |

##### ```Note!!!: The default address_domain is 0 ,representing using ethereum for data avalability```

##### ```Note!!!: You have  to define a storage address```

#### Defining a storage address

```rust
let storage_address = storage_base_address_from_felt252(3534535754756246375475423547453)
 ```

#### Reading from storage

```rust
storage_read_syscall(0, storage_address);
 ```

It returns a response ```SyscallResult<Span<felt252>>```

To get the syscall result use the ```.unwrap_syscall()``` method

## ```emit_event_syscall```

This syscall is used for emitting events .Events are tthe transaction logs of contracts that can be accessed only from outside the contract.

it takes two arguments

- ```keys: Span<felt252>```
- ```data: Span<felt252>```

| Arguments    | Description|
| -------- | ------- |
| keys:  | An array of the events keys |
| address |  an array of events values |

##### ```Note!!!: Keys are values should match eact other in both arrays```

#### Example

```rust
let keys = ArrayTrait::new();
keys.append('transfer');
keys.append('deposit');
let values = ArrayTrait::new();
values.append(1);
values.append(2);
emit_event_syscall(keys.span(), values.span())
 ```

This syscall doesnt return anything.

## Conclusion

As a cairo dev you would barely use system calls directly has there are high level ways of accessing these functions ,but in some cases this knowlege will be useful .It is also good to know what is happening under the hood of the high level function you use all the time.
