#[starknet::contract]
mod ownership_preserve{
    use array::ArrayTrait;
    use clone::Clone;
    use array::ArrayTCloneImpl;

    #[storage]
    struct Storage{
    }

    #[derive(Copy, Drop)]
    struct Point {
        x: u128,
        y: u128,
    }

    // 1. return ownership in function
    fn return_ownership_example(){
        let mut x = ArrayTrait::<felt252>::new();  // x comes into scope
        x = return_ownership(x);             // ownership of x's value is returned
        let y = x;     // this works     
    }

    fn return_ownership(some_array: Array<felt252>) -> Array<felt252> {
        some_array
    }

    // 2. copy
    fn copy_example(){
        // Point struct implements Copy trait
        let p1 = Point { x: 5, y: 10 };
        let p2 = p1;
        let p3 = p1; // this works     
    }

    // 3. clone
    fn clone_example(){
        let x = ArrayTrait::<felt252>::new();  // x comes into scope
        let y = x.clone();   // deeply copy x and bound to y
        let z = x;  // this works     
    }

    // 4. reference
    fn reference_example(){
        let mut x = ArrayTrait::<felt252>::new();  // x comes into scope
        use_reference(ref x); // pass a mutable reference of x to function
        let y = x; // this works     
    }

    fn use_reference(ref some_array: Array<felt252>) {
    }


    // 5. snapshot
    fn snapshot_example(){
        let x = ArrayTrait::<felt252>::new();  // x comes into scope
        use_snapshot(@x); // pass a snapshot of x to function
        let y = x; // this works     
    }

    fn use_snapshot(some_array: @Array<felt252>) {
    }
}