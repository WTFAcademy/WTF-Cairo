#[starknet::contract]
mod Generics{
    #[storage]
    struct Storage{
    }

    // generic struct
    struct Pair<T> {
        first: T,
        second: T,
    }

    // generic enum
    enum OptionExample<T> {
        Some: T,
        None: (),
    }

    // generic function
    // a and b must have the same type
    fn swap<T>(a: T, b: T) -> (T, T) {
        (b, a)
    }

    fn test_swap() {
        // you can swap two u128 variables
        let a = 5_u128;
        let b = 10_u128;
        let swaped_u128 = swap(a, b);

        // you can also swap two felt252 variables
        let c = 5;
        let d = 10;
        let swaped_felt = swap(c, d);
    }

    // generic trait
    trait PairTrait<T> {
        fn new(a: T, b: T) -> Pair<T>;
        fn getFirst(self: @Pair<T>) -> T;
    }

    // implement Copy and Drop trait on generic struct
    impl PairDrop<T, impl TDrop: Drop<T>> of Drop<Pair<T>>;
    impl PairCopy<T, impl TCopy: Copy<T>> of Copy<Pair<T>>;

    // implementation generic method
    // only work with type with Copy trait
    impl PairImpl<T, impl TCopy: Copy<T>> of PairTrait<T> {
        fn new(a: T, b: T) -> Pair<T> {
            Pair { first: a, second: b }
        }

        fn getFirst(self: @Pair<T>) -> T {
            return *self.first;
        }
    }
}