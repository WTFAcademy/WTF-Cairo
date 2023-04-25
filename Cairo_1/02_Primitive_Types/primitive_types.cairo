#[contract]
mod declaring_primitive_types {
   # Unsigned 8-bit integer
    let value_u8 = 1_u8;

    # Unsigned 16-bit integer
    let value_u16 = 1_u16;

    # Unsigned 32-bit integer
    let value_u32 = 1_u32;

    # Unsigned 64-bit integer
    let value_u64 = 1_u64;

    # Unsigned 128-bit integer
    let value_u128 = 1_u128;

    # Unsigned 256-bit integer
    let value_u256 = 1_u256;

    # Unsigned size integer (typically used for representing indices and lengths)
    let value_usize = 1_usize;

    # Felt
    let number = 666;
    let my_address = "WTF Academy";
    let hello_string = 'Hello World!';
}