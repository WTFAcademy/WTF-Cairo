# Introduction

Let's remember that in Cairo 0, we used to work with felt and pointer, but in Cairo 1.0, now we have native access to more data types. 

## Felt

First, let's talk the most important primitive data types: `felt`. 

A `felt` (short for field element) is everything in Cairo, it stands for a 252-bit number (31 bytes) and it supports all base operations such as: addition, subtraction, multiplication and division. It is used to store addresses, strings, integers, etc. 

## String 

Cairo supports short string whose length is at most 31 characters but they're actually stored in `felt`.

A short string is simply a way to represent a field element, it`s not a real string. 

## Integer.

For the integers types `uint128` is supported already with `uint256` coming. But work with `uint256` in Cairo 0 is difficult because there are a lot of confusion for developers due to its `low` and `high` splits. The `uint128` type has functions to allow common arithmetic and comparison operations for example:

- uint128_checked_add
- uint128_checked_sub
- uint128_checked_mul
- uint128_safe_mod
- uint128_safe_divmod
- uint128_lt
- uint128_le
- uint128_gt
- uint128_ge
- uint128_eq
- uint128_ne

There are conversion functions, for example :

- uint128_from_felt
- uint128_to_felt

## Bool 

As in other programming language, Cairo 1.0 includes boolean data type. This data type has one of two possible values `true` or `false` which is intender to represent the two truth values of logic and boolean algebra. 

# How to use this primitives

Now, that we know the primitive data types that we have available in Cairo, we can use the `let`, `mut` and `ref` labes to declare a variable. 

## Let

With this label, we can declare a variable as follows:

```
let magic_number = 666;
let my_address = "WTF Academy";
let hello_string = 'Hello world!';
```
 Once we assign a value, we are not capable to change it and becomes a constant.

 ## Mut 

As we know, Cairo 1.0 is based on rust, so if you are familiar with rust programming language, you may be will know the meaning to add `mut` to a variable declaration.
 
In Cairo 1.0, when we add the label `mut` stands for a variable tan is mutable, this means tha the value can be modified. For example, to declare a mutable variable:

````
let mut b = 2;
b = 3;
````

## Ref

To work with reference en Cairo, we can use the label `ref` this allow to modify a variable that is passed as a reference. For example:

```
fn main() -> felt {
  let mut n = 1;
  b(ref n);
  n
}

fn b (ref n: felt){
  n = 1;
}
```

## Constant

To declare a global constant we use:

```
const num: felt = 15;
fn main() -> felt {
  NUM
}
```

 







