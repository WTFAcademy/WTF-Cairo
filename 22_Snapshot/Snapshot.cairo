#[starknet::contract]
mod snapshot{
    use array::ArrayTrait;

    #[storage]
    struct Storage{
    }

    #[derive(Copy, Drop)]
    struct Rectangle {
        height: u64,
        width: u64,
    }

    fn snapshot_example(){
        let x = ArrayTrait::<felt252>::new();  // x comes into scope
        let len = get_length(@x); // pass a snapshot of x to function
        let y = x; // this works     
    }

    // get the length of the array
    fn get_length(some_array: @Array<felt252>) -> usize{
        some_array.len()
    }

    fn desnap_example() {
        // create an Rectangle struct
        let rec = Rectangle { height: 5_u64, width: 10_u64 };
        // pass the snapshot of rec to function
        let area = calculate_area(@rec);
    }

    fn calculate_area(rec: @Rectangle) -> u64 {
        // use the desnap operator `*` get underlying values
        *rec.height * *rec.width
    }
}