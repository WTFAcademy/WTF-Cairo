#[starknet::contract]
mod PrimitiveTypes {
    
    #[storage]
    struct Storage {}

    #[external(v0)]
    fn overflow(self: @ContractState) -> felt252 {
        let x: felt252 = -1;
        //0x800000000000011000000000000000000000000000000000000000000000000
        //=2^251+17⋅2^192
        return x;
    }

    #[external(v0)]
    fn integer(self: @ContractState) -> u256 {
        
        let _x_u8 = 1_u8;
        
        let _x_u16 = 1_u16;
        
        let _x_u32 = 1_u32;

        let _x_64 = 1_64;

        let _x_128 = 1_128;

        let _x_256 = u256 { high : 0, low: 10};

        let _value_usize = 1_usize;

        return _x_256;
    }

    #[external(v0)]
    fn string(self: @ContractState) {
        let _x_char = 'C';
        let _x_char_in_hex = 0x43;

        let _x_string = 'WTF Academy';
        let _x_string_in_hex = 0x5754462041636164656D79;

        let _x_long_string: ByteArray = "this is a string which has more than 31 characters";
    }

    #[external(v0)]
    fn tuple(self: @ContractState) -> u64 {
        let tup:(u32, u64, bool) = (10, 6, true);
        let (_x, y, _z) = tup;
        return y; 
    }
}
