#[starknet::contract]
mod error_handling{
    use array::ArrayTrait;
    use traits::Into;

    // storage variable
    #[storage]
    struct Storage{
    }

    // throw error if input is 0 with assert (recommended)
    #[external(v0)]
    fn assert_example(self: @ContractState, input: u128){
        assert( input == 0_u128, 'Error: Input not 0!');
    }

    // throw error if input is 0 with panic
    // panic accepts felt252 arrary as parameter
    #[external(v0)]
    fn panic_example(self: @ContractState, input: u128){
        if input == 0_u128 {
            let mut error_data = ArrayTrait::new();
            error_data.append(input.into());
            panic(error_data);
        }
    }

    // throw error if input is 0 with panic_with_felt252
    // panic_with_felt252 accepts felt252 as parameter
    #[external(v0)]
    fn panic_with_felt252_example(self: @ContractState, input: u128){
        if input == 0_u128 {
            panic_with_felt252('Error: Input not 0!');
        }
    }
}