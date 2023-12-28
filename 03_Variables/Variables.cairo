#[starknet::contract]
mod variables {
    // declare storage variables
    #[storage]
    struct Storage{
        var_felt: felt252,
        var_bool: bool,
        var_uint: u8,
        }
    
    // read storage variable
    #[external(v0)]
    fn read_bool(self: @ContractState) -> bool {
        return self.var_bool.read();
    }
    
    // write storage variable
    #[external(v0)]
    fn write_bool(ref self: ContractState, bool_: bool) {
        self.var_bool.write(bool_);
    }

    // local variables
    #[external(v0)]
    fn local_var(self: @ContractState){
        // use `let` keywods to declare local variables 
        let local_felt: felt252 = 5;
        let local_bool = true;
        let local_uint = 1_u8;
    }
}
