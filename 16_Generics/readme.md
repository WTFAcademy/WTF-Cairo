# WTF Cairo: 16. Generics

We are learning `Cairo`, and writing `WTF Cairo Tutorials` for Starknet newbies. The tutorials are based on `Cairo 1.0`.

Twitter: [@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy Community：[Discord](https://discord.wtf.academy)｜[Wechat](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[Website](https://wtf.academy)

All codes and tutorials are open-sourced on GitHub: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

In this chapter, we introduce generics in Cairo.

## Generics in general

Generic programming is about abstracting and classifying algorithms and data structures. It enables us to:
1. Achieve compile-time checking
2. Achieve code reusability
3. Achieve type safety

### You must know

Even generic can help save development effort for developers, while replacing a generic type with the concrete type during the compilation, code duplication still exists.

This may be of importance when you are writing Starknet contracts and using a generic for multiple types, as it will cause contract size to increment.

### Generic Data Types

We can use generics to define functions, structs, enums, and methods.

#### Functions

When we incorporate generics into a function, we include them in the function signature where we would usually specify the data types of the parameter and return value. To illustrate, consider the scenario where we aim to develop a function that identifies the larger of two arrays of items. If we require this operation for lists of various types, we would typically have to redefine the function each time. Fortunately, we can leverage generics to implement the function once and proceed with other tasks.

The following larger_list function takes two lists of the same type as parameters, returns the one with more elements and drops the other one. As it uses generics, and the compiler has no way to guarantee that an Array<T> is droppable when executing the main function, we must specify in the function signature that the type T must implement the drop trait.

```rust
use array::ArrayTrait;
use debug::PrintTrait;

fn larger_list<T, impl TDrop: Drop<T>>(l1: Array<T>, l2: Array<T>) -> Array<T> {
    if l1.len() > l2.len() {
        l1
    } else {
        l2
    }
}

fn find_larger_uint_list() {
    let mut l1 = ArrayTrait::new();
    let mut l2 = ArrayTrait::new();

    l1.append(1);
    l1.append(2);

    l2.append(3);
    l2.append(4);
    l2.append(5);

    let l3 = larger_list(l1, l2);
    l3.len().print();
}

fn find_larger_bool_list() {
    let mut l1 = ArrayTrait::new();
    let mut l2 = ArrayTrait::new();

    l1.append(true);
    l1.append(false);

    l2.append(true);
    l2.append(false);
    l2.append(true);

    let l3 = larger_list(l1, l2);
    l3.len().print();
}

fn main() {
    find_larger_uint_list();
    find_larger_bool_list();
}
```

#### Structs

We can use generic type parameters for the fields of a struct definition. We use the <> syntax, which is similar to function definitions.
1. Declare the name of the type parameter inside the angle brackets just after the struct name.
2. Use the generic type in the struct definition.

```rust
struct Bill<T> {
    totalCost: T,
}

impl BillDrop<T, impl TDrop: Drop<T>> of Drop<Bill<T>>;

fn main() {
    let w = Bill { totalCost: 5888_u128 };
}
```

Notice that, as the derive macro is not working well with generics, we must directly write the traits you want to use, when using generic types.

#### Enums

Enums can use multiple generic types as well.

The Result<T, E> enum is generic over the types T and E, and has two variants: Ok, which holds one value of type T and Err that holds one value of type E. By using the Result<T, E> enum, it is possible for us to express the abstract concept of a result value and use different type value in different variants.

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

#### Generic Methods

We can also use the generic types in the methods implemented on structs and enums. For example, we can define a totalCost method for the definition of Bill<T> struct:

1. Define BillTrait<T> trait using a generic type T which defines a method that returns a snapshot of the `totalCost` from Bill. 
2. Implement the trait in BillImpl<T>. You must include a generic type in both definitions of the trait and the implementation.

```rust
struct Bill<T> {
    totalCost: T,
}

impl BillDrop<T, impl TDrop: Drop<T>> of Drop<Bill<T>>;

trait BillTrait<T> {
    fn totalCost(self: @Bill<T>) -> @T;
}

impl BillImpl<T> of BillTrait<T> {
    fn totalCost(self: @Bill<T>) -> @T {
        return self.totalCost;
    }
}

fn main() {
    let bill = Bill { totalCost: 8_u8 };
    assert(bill.totalCost() == 8, 0);
}
```

## Summary

In this chapter, we introduced generics in Cairo.