#[contract]
mod control_flow {
    // example of if-else
    #[view]
    fn is_zero(x: u128) -> bool{
        // if-else
        if( x == 0_u128 ){
            true
        } else {
            false
        }
    }

    // example of else-if
    #[view]
    fn compare_256(x: u128) -> u8{
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
    #[view]
    fn is_zero_let(x: u128) -> bool{
        // return value from if-else
        let isZero = if( x == 0_u128 ){
            true
        } else {
            false
        };
        return isZero;
    }

    // example of loop
    #[view]
    fn sum_until(x: u128) -> u128{
        let mut i: u128 = 1;
        let mut sum: u128 = 0;
        // loop
        loop {
            if (i > x) {
                break ();
            } 
            sum += i;
        };
        return sum;
    }

    // example of return value from loop
    #[view]
    fn sum_until_let(x: u128) -> u128{
        let mut i: u128 = 1;
        let mut sum_i: u128 = 0;
        // return value from loop
        let sum = loop {
            if (i > x) {
                break sum_i;
            } 
            sum_i += i;
        };
        return sum;
    }
}
