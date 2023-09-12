#[starknet::contract]
mod ownership_move{
    use array::ArrayTrait;

    #[storage]
    struct Storage{
    }

    #[derive(Copy, Drop)]
    struct Point {
        x: u128,
        y: u128,
    }

    #[derive(Copy)]
    struct Point_Nodrop {
        x: u128,
        y: u128,
    }

    #[derive(Drop)]
    struct Point_Drop {
        x: u128,
        y: u128,
    }

    // move variable example
    fn move_variable() {
        let x = ArrayTrait::<felt252>::new();  // x becomes the owner of the data
        let y = x;                      // ownership is moved from x to y

        let z = x;              // this will cause a compile error
    }

    // move function example
    fn move_function(){
        let x = ArrayTrait::<felt252>::new();  // x comes into scope

        takes_ownership(x);             // x's value moves into the function
                                        // ... and so is no longer valid here

        // let y = x;           // This would cause a compile error because x is no longer valid

    } // Here, x goes out of scope, but because its value was moved, nothing happens


    fn takes_ownership(some_array: Array<felt252>){ // some_array comes into scope
    } // Here, some_string goes out of scope and `drop` is called, the backing memory is freed

    // copy felt example, integers and felt implemented Copy trait by default
    fn copy_felt(){
        // uint and felt implements Copy trait by default
        let x = 5; // x owns the value 5
        let y = x; // a copy of x is generated and assigned to y
        let z = x; // another copy of x is generated and assigned to z
    }

    // copy struct example, Point implemented Copy trait manually in the contract
    fn copy_struct(){
        // Point struct implements Copy trait
        let p1 = Point { x: 5, y: 10 };
        foo(p1); // a copy of p1 is generated and passed to foo()
        foo(p1); // another copy of p1 is generated and passed to foo()
    }

    fn foo(p: Point) {
        // do something with p
    }

    // no drop example
    fn nodrop_struct(){
        // let p1 = Point_Nodrop { x: 5, y: 10 };
        // error: Variable not dropped.
    }

    // drop example
    fn drop_struct(){
        let p1 = Point_Drop { x: 5, y: 10 };
    }
}