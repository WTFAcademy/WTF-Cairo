#[contract]
mod variables {
    // declare storage variables
    struct Storage{
        var_felt: felt252,
        var_bool: bool,
        var_uint: u8,
        }
    
    // read storage variable
    #[view]
    fn read_bool() -> bool {
        return var_bool::read();
    }
    
    // write storage variable
    #[external]
    fn write_bool(bool_: bool) {
        var_bool::write(bool_);
    }

    // local variables
    #[view]
    fn local_var(){
        // use `let` keywods to declare local variables 
        let local_felt: felt252 = 5;
        let local_bool;
        local_bool = true;
        let local_uint = 1_u8;
    }
}
