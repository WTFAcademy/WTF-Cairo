#[starknet::contract]
mod snapshot{
    #[storage]
    struct Storage{
    }

    #[derive(Copy, Drop)]
    struct Rectangle {
        height: u64,
        width: u64,
    }

    #[external(v0)]
    fn snapshot_example(self: @ContractState)->(usize,usize){
        let mut x = ArrayTrait::<felt252>::new();  
        let x_snapshot = @x;
        x.append(1);
        let first_length = get_length(x_snapshot);
        let second_length = get_length(@x);
        return (first_length,second_length);    
    }

    // get the length of the array
    fn get_length(some_array: @Array<felt252>) -> usize{
        some_array.len()
    }

    #[external(v0)]
    fn desnap_example(self: @ContractState) ->(u64,u64) {
        let mut rec = Rectangle { height: 5_u64, width: 10_u64 };
        let area_first = calculate_area(@rec);
        rec.height = 6_u64;
        rec.width = 11_u64;
        let area_second = rec.height * rec.width;
        return (area_first, area_second);
    }

    fn calculate_area(rec: @Rectangle) -> u64 {
        (*rec).height * (*rec).width
    }
}
