#[starknet::contract]
mod reference{
    use array::ArrayTrait;

    #[storage]
    struct Storage{
    }

    fn reference_example(){
        let mut x = ArrayTrait::<felt252>::new();  // x comes into scope
        use_reference(ref x); // pass a mutable reference of x to function
        let y = x; // this works  
        
        // immutable variable can't be passed as reference
        let z = ArrayTrait::<felt252>::new(); 
        // use_reference(ref z); 
        // error: Plugin diagnostic: ref argument must be a mutable variable.
    }

    fn use_reference(ref some_array: Array<felt252>) {
    }
}