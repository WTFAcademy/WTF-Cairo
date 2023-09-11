#[starknet::contract]
mod declaring_primitive_types {
    #[storage]
    struct Storage {}

    #[external(v0)]
    fn hello_cairo(self: @ContractState) {
        // Felt: Field Element, can represent 252 bit integer
        let x_felt = 666;
        let y_felt = x_felt * 2;
        // short string is represented with felt
        let x_shortString = 'WTF Academy';

        // boolean: true or false
        let x_bool = true;
        let y_bool = false;

        // Unsigned Integers
        // Unsigned 8-bit integer
        let x_u8 = 1_u8;
        let y_u8: u8 = 2;
        // Unsigned 16-bit integer
        let x_u16 = 1_u16;
        // Unsigned 32-bit integer
        let x_u32 = 1_u32;
        // Unsigned 64-bit integer
        let x_u64 = 1_u64;
        // Unsigned 128-bit integer
        let x_u128 = 1_u128;
        // Unsigned size integer (typically used for representing indices and lengths)
        let value_usize = 1_usize;
    }
}