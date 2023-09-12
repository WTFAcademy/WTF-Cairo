#[starknet::contract]
mod type_conversion{
    use traits::Into;
    use traits::TryInto;
    use option::OptionTrait;

    #[storage]
    struct Storage{
    }

    #[external(v0)]
    fn use_into(self: @ContractState){
        // from larger types to smaller types, success is guranteed
        // u8 -> u16 -> u32 -> u64 -> u128 -> felt252
        let x_u8: u8 = 13;
        let x_u16: u16 = x_u8.into();
        let x_u128: u128 = x_u16.into();
        let x_felt: felt252 = x_u128.into();
    }

    #[external(v0)]
    fn use_try_into(self: @ContractState){
        // from smaller types to smaller types, may fail
        // u8 <- u16 <- u32 <- u64 <- u128 <- felt252
        // try_into() returns an Option, you need to unwrap to get value
        let x_felt: felt252 = 13;
        let x_u128: u128 = x_felt.try_into().unwrap();
        let x_u16: u16 = x_u128.try_into().unwrap();
        let x_u8: u8 = x_u16.try_into().unwrap();
    }
}