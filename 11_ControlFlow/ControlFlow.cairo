#[starknet::contract]
mod control_flow {
    #[storage]
    struct Storage{
    }

    // example of if-else
    #[external(v0)]
    fn is_zero(self: @ContractState, x: u128) -> bool{
        // if-else
        if( x == 0_u128 ){
            true
        } else {
            false
        }
    }

    // example of else-if
    #[external(v0)]
    fn compare_256(self: @ContractState, x: u128) -> u8{
        // else-if
        if( x < 256_u128 ){
            0_u8
        } else if (x == 256_u128 ){
            1_u8
        } else {
            2_u8
        }
    }

    // example of return value from if-else
    #[external(v0)]
    fn is_zero_let(self: @ContractState, x: u128) -> bool{
        // return value from if-else
        let isZero = if( x == 0_u128 ){
            true
        } else {
            false
        };
        return isZero;
    }

    // example of loop
    #[external(v0)]
    fn sum_until(self: @ContractState, x: u128) -> u128{
        let mut i: u128 = 1;
        let mut sum: u128 = 0;
        // loop
        loop {
            if (i > x) {
                break ();
            } 
            sum += i;
            i += 1;
        };
        return sum;
    }

    // example of return value from loop
    #[external(v0)]
    fn sum_until_let(self: @ContractState, x: u128) -> u128{
        let mut i: u128 = 1;
        let mut sum_i: u128 = 0;
        // return value from loop
        let sum = loop {
            if (i > x) {
                break sum_i;
            } 
            sum_i += i;
            i += 1;
        };
        return sum;
    }
}